import 'package:drift/drift.dart';

import '../data/local/app_database.dart' as db;
import '../models/training_program.dart';
import '../models/program_exercise.dart';
import '../models/program_set.dart';

class TrainingProgramRepository {
  final db.AppDatabase database;

  TrainingProgramRepository(this.database);

  // حفظ برنامج جديد أو تحديث برنامج موجود.
  Future<void> saveProgram(TrainingProgram program) async {
    if (program.type == ProgramType.builtIn) {
      throw ArgumentError(
        'Built-in programs cannot be saved directly.',
      );
    }

    await database.transaction(() async {
      // حذف النسخة القديمة إن وجدت.
      await (database.delete(database.trainingPrograms)
            ..where((table) => table.id.equals(program.id)))
          .go();

      // حفظ بيانات البرنامج.
      await database.into(database.trainingPrograms).insert(
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
        final exerciseId =
            '${program.id}_exercise_${exercise.exerciseOrder}';

        await database.into(database.programExercises).insert(
              db.ProgramExercisesCompanion.insert(
                id: exerciseId,
                programId: program.id,
                exerciseId: exercise.exerciseId,
                exerciseOrder: exercise.exerciseOrder,
              ),
            );

        for (final set in exercise.sets) {
          await database.into(database.programSets).insert(
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

  // جلب جميع البرامج المحفوظة.
  Future<List<TrainingProgram>> getSavedPrograms() async {
    final rows = await database.select(database.trainingPrograms).get();

    final programs = <TrainingProgram>[];

    for (final row in rows) {
      final program = await getProgramById(row.id);

      if (program != null) {
        programs.add(program);
      }
    }

    return programs;
  }

  // جلب برنامج محدد مع تمارينه ومجموعاته.
  Future<TrainingProgram?> getProgramById(String programId) async {
    final row = await (database.select(database.trainingPrograms)
          ..where((table) => table.id.equals(programId)))
        .getSingleOrNull();

    if (row == null) return null;

    final exerciseRows = await (database.select(database.programExercises)
          ..where((table) => table.programId.equals(programId))
          ..orderBy([
            (table) => OrderingTerm.asc(table.exerciseOrder),
          ]))
        .get();

    final exercises = <ProgramExercise>[];

    for (final exerciseRow in exerciseRows) {
      final setRows = await (database.select(database.programSets)
            ..where(
              (table) =>
                  table.programExerciseId.equals(exerciseRow.id),
            )
            ..orderBy([
              (table) => OrderingTerm.asc(table.setNumber),
            ]))
          .get();

      exercises.add(
        ProgramExercise(
          exerciseId: exerciseRow.exerciseId,
          exerciseOrder: exerciseRow.exerciseOrder,
          sets: setRows.map((set) {
            return ProgramSet(
              setNumber: set.setNumber,
              targetWeight: set.targetWeight,
              targetReps: set.targetReps,
            );
          }).toList(),
        ),
      );
    }

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
    await (database.delete(database.trainingPrograms)
          ..where((table) => table.id.equals(programId)))
        .go();
  }
}