import 'package:drift/drift.dart';

import '../data/local/app_database.dart' as db;
import '../models/training_program.dart';
import '../models/program_exercise.dart';
import '../models/program_set.dart';

class TrainingProgramRepository {
  final db.AppDatabase database;

  TrainingProgramRepository(this.database);

  bool _isValidProgram(TrainingProgram program) {
    if (program.id.trim().isEmpty) return false;
    if (program.nameAr.trim().isEmpty) return false;
    if (program.nameEn.trim().isEmpty) return false;
    if (program.durationWeeks <= 0) return false;
    if (program.exercises.isEmpty) return false;

    final exerciseIds = <String>{};
    final exerciseOrders = <int>{};

    for (final exercise in program.exercises) {
      if (exercise.exerciseId.trim().isEmpty) return false;
      if (exercise.exerciseOrder <= 0) return false;

      if (!exerciseIds.add(exercise.exerciseId)) return false;
      if (!exerciseOrders.add(exercise.exerciseOrder)) return false;

      if (exercise.sets.isEmpty) return false;

      final setNumbers = <int>{};

      for (final set in exercise.sets) {
        if (set.setNumber <= 0) return false;
        if (!setNumbers.add(set.setNumber)) return false;

        if (set.targetReps <= 0) return false;
        if (!set.targetWeight.isFinite || set.targetWeight < 0) {
          return false;
        }
      }
    }

    return true;
  }

  // حفظ برنامج جديد أو تحديث برنامج موجود.
  Future<void> saveProgram(TrainingProgram program) async {
    if (program.type == ProgramType.builtIn) {
      throw ArgumentError('Built-in programs cannot be saved directly.');
    }
    if (!_isValidProgram(program)) {
      throw ArgumentError('Invalid training program data.');
    }

    await database.transaction(() async {
      // حذف النسخة القديمة إن وجدت.
      await (database.delete(
        database.trainingPrograms,
      )..where((table) => table.id.equals(program.id))).go();

      // حفظ بيانات البرنامج.
      await database
          .into(database.trainingPrograms)
          .insert(
            db.TrainingProgramsCompanion.insert(
              id: program.id,
              nameAr: program.nameAr,
              nameEn: program.nameEn,
              descriptionAr: program.descriptionAr,
              descriptionEn: program.descriptionEn,
              durationWeeks: program.durationWeeks,
              levelAr: program.levelAr,
              levelEn: program.levelEn,
              category: program.category,
              type: program.type.name,
              sourceProgramId: Value(program.sourceProgramId),
            ),
          );

      // حفظ تمارين البرنامج ومجموعاتها.
      for (final exercise in program.exercises) {
        final exerciseId = '${program.id}_exercise_${exercise.exerciseOrder}';

        await database
            .into(database.programExercises)
            .insert(
              db.ProgramExercisesCompanion.insert(
                id: exerciseId,
                programId: program.id,
                exerciseId: exercise.exerciseId,
                exerciseOrder: exercise.exerciseOrder,
              ),
            );

        for (final set in exercise.sets) {
          await database
              .into(database.programSets)
              .insert(
                db.ProgramSetsCompanion.insert(
                  id: '${exerciseId}_set_${set.setNumber}',
                  programExerciseId: exerciseId,
                  setNumber: set.setNumber,
                  targetWeight: set.targetWeight,
                  targetReps: set.targetReps,
                ),
              );
        }
      }
    });
  }

  // جلب جميع البرامج المحفوظة باستعلامات مجمعة.
  Future<List<TrainingProgram>> getSavedPrograms() async {
    // 1. جلب البرامج.
    final rows = await database.select(database.trainingPrograms).get();

    if (rows.isEmpty) return [];

    final programIds = rows.map((row) => row.id).toList();

    // 2. جلب تمارين جميع البرامج باستعلام واحد.
    final exerciseRows =
        await (database.select(database.programExercises)
              ..where((table) => table.programId.isIn(programIds))
              ..orderBy([(table) => OrderingTerm.asc(table.exerciseOrder)]))
            .get();

    final exerciseIds = exerciseRows.map((row) => row.id).toList();

    // 3. جلب مجموعات جميع التمارين باستعلام واحد.
    final setRows =
        await (database.select(database.programSets)
              ..where((table) => table.programExerciseId.isIn(exerciseIds))
              ..orderBy([(table) => OrderingTerm.asc(table.setNumber)]))
            .get();

    // 4. تجميع المجموعات حسب التمرين.
    final setsByExerciseId = <String, List<ProgramSet>>{};

    for (final row in setRows) {
      setsByExerciseId
          .putIfAbsent(row.programExerciseId, () => [])
          .add(
            ProgramSet(
              setNumber: row.setNumber,
              targetWeight: row.targetWeight,
              targetReps: row.targetReps,
            ),
          );
    }

    // 5. تجميع التمارين حسب البرنامج.
    final exercisesByProgramId = <String, List<ProgramExercise>>{};

    for (final row in exerciseRows) {
      exercisesByProgramId
          .putIfAbsent(row.programId, () => [])
          .add(
            ProgramExercise(
              exerciseId: row.exerciseId,
              exerciseOrder: row.exerciseOrder,
              sets: setsByExerciseId[row.id] ?? [],
            ),
          );
    }

    // 6. بناء البرامج وإرجاعها.
    return rows.map((row) {
      return TrainingProgram(
        id: row.id,
        nameAr: row.nameAr,
        nameEn: row.nameEn,
        descriptionAr: row.descriptionAr,
        descriptionEn: row.descriptionEn,
        durationWeeks: row.durationWeeks,
        levelAr: row.levelAr,
        levelEn: row.levelEn,
        category: row.category,
        type: ProgramType.values.firstWhere(
          (type) => type.name == row.type,
          orElse: () => ProgramType.custom,
        ),
        sourceProgramId: row.sourceProgramId,
        exercises: exercisesByProgramId[row.id] ?? [],
      );
    }).toList();
  }

  // جلب برنامج محدد مع تمارينه ومجموعاته.
  Future<TrainingProgram?> getProgramById(String programId) async {
    final row = await (database.select(
      database.trainingPrograms,
    )..where((table) => table.id.equals(programId))).getSingleOrNull();

    if (row == null) return null;

    final exerciseRows =
        await (database.select(database.programExercises)
              ..where((table) => table.programId.equals(programId))
              ..orderBy([(table) => OrderingTerm.asc(table.exerciseOrder)]))
            .get();

    final exerciseIds = exerciseRows.map((exercise) => exercise.id).toList();

    final setRows = exerciseIds.isEmpty
        ? <db.ProgramSet>[]
        : await (database.select(database.programSets)
                ..where((table) => table.programExerciseId.isIn(exerciseIds))
                ..orderBy([(table) => OrderingTerm.asc(table.setNumber)]))
              .get();

    final setsByExerciseId = <String, List<ProgramSet>>{};

    for (final set in setRows) {
      setsByExerciseId
          .putIfAbsent(set.programExerciseId, () => [])
          .add(
            ProgramSet(
              setNumber: set.setNumber,
              targetWeight: set.targetWeight,
              targetReps: set.targetReps,
            ),
          );
    }

    final exercises = exerciseRows.map((exercise) {
      return ProgramExercise(
        exerciseId: exercise.exerciseId,
        exerciseOrder: exercise.exerciseOrder,
        sets: setsByExerciseId[exercise.id] ?? [],
      );
    }).toList();

    return TrainingProgram(
      id: row.id,
      nameAr: row.nameAr,
      nameEn: row.nameEn,
      descriptionAr: row.descriptionAr,
      descriptionEn: row.descriptionEn,
      durationWeeks: row.durationWeeks,
      levelAr: row.levelAr,
      levelEn: row.levelEn,
      category: row.category,
      type: ProgramType.values.firstWhere(
        (type) => type.name == row.type,
        orElse: () => ProgramType.custom,
      ),
      sourceProgramId: row.sourceProgramId,
      exercises: exercises,
    );
  }

  // حذف برنامج محفوظ.
  Future<void> deleteProgram(String programId) async {
    await (database.delete(
      database.trainingPrograms,
    )..where((table) => table.id.equals(programId))).go();
  }
}
