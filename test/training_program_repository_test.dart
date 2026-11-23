import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:fit_forge/data/local/app_database.dart'
    hide TrainingProgram, ProgramExercise, ProgramSet;
import 'package:fit_forge/models/training_program.dart';
import 'package:fit_forge/models/program_exercise.dart';
import 'package:fit_forge/models/program_set.dart';
import 'package:fit_forge/repositories/training_program_repository.dart';

void main() {
  late AppDatabase database;
  late TrainingProgramRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = TrainingProgramRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  TrainingProgram createValidProgram({
    String id = 'test_program',
    List<ProgramExercise>? exercises,
  }) {
    return TrainingProgram(
      id: id,
      nameAr: 'برنامج تجريبي',
      nameEn: 'Test Program',
      descriptionAr: 'وصف تجريبي',
      descriptionEn: 'Test description',
      durationWeeks: 4,
      levelAr: 'مبتدئ',
      levelEn: 'Beginner',
      category: 1,
      type: ProgramType.custom,
      exercises:
          exercises ??
          [
            ProgramExercise(
              exerciseId: 'chest_001',
              exerciseOrder: 1,
              sets: [ProgramSet(setNumber: 1, targetWeight: 0, targetReps: 10)],
            ),
          ],
    );
  }

  group('TrainingProgramRepository validation', () {
    test('saves a valid custom program', () async {
      final program = createValidProgram();

      await repository.saveProgram(program);

      final savedProgram = await repository.getProgramById(program.id);

      expect(savedProgram, isNotNull);
      expect(savedProgram!.nameEn, 'Test Program');
      expect(savedProgram.exercises.length, 1);
    });

    test('rejects a program without exercises', () async {
      final program = createValidProgram(exercises: []);

      expect(() => repository.saveProgram(program), throwsArgumentError);
    });

    test('rejects a set with zero repetitions', () async {
      final program = createValidProgram(
        exercises: [
          ProgramExercise(
            exerciseId: 'chest_001',
            exerciseOrder: 1,
            sets: [ProgramSet(setNumber: 1, targetReps: 0)],
          ),
        ],
      );

      expect(() => repository.saveProgram(program), throwsArgumentError);
    });

    test('rejects a negative target weight', () async {
      final program = createValidProgram(
        exercises: [
          ProgramExercise(
            exerciseId: 'chest_001',
            exerciseOrder: 1,
            sets: [ProgramSet(setNumber: 1, targetWeight: -5, targetReps: 10)],
          ),
        ],
      );

      expect(() => repository.saveProgram(program), throwsArgumentError);
    });

    test('rejects duplicate exercise IDs', () async {
      final program = createValidProgram(
        exercises: [
          ProgramExercise(
            exerciseId: 'chest_001',
            exerciseOrder: 1,
            sets: [ProgramSet(setNumber: 1, targetReps: 10)],
          ),
          ProgramExercise(
            exerciseId: 'chest_001',
            exerciseOrder: 2,
            sets: [ProgramSet(setNumber: 1, targetReps: 10)],
          ),
        ],
      );

      expect(() => repository.saveProgram(program), throwsArgumentError);
    });
    test('keeps existing program when invalid update is rejected', () async {
      // حفظ البرنامج الأصلي.
      final originalProgram = createValidProgram();

      await repository.saveProgram(originalProgram);

      // محاولة تحديثه ببرنامج غير صالح يحمل نفس المعرف.
      final invalidProgram = createValidProgram(
        id: originalProgram.id,
        exercises: [],
      );

      await expectLater(
        repository.saveProgram(invalidProgram),
        throwsArgumentError,
      );

      // التأكد من بقاء البرنامج الأصلي.
      final savedProgram = await repository.getProgramById(originalProgram.id);

      expect(savedProgram, isNotNull);
      expect(savedProgram!.nameAr, originalProgram.nameAr);
      expect(savedProgram.nameEn, originalProgram.nameEn);
      expect(savedProgram.exercises.length, 1);
      expect(savedProgram.exercises.first.exerciseId, 'chest_001');
    });
    test('rejects NaN and infinite target weights', () async {
      for (final weight in [double.nan, double.infinity]) {
        final program = createValidProgram(
          exercises: [
            ProgramExercise(
              exerciseId: 'chest_001',
              exerciseOrder: 1,
              sets: [
                ProgramSet(setNumber: 1, targetWeight: weight, targetReps: 10),
              ],
            ),
          ],
        );

        await expectLater(repository.saveProgram(program), throwsArgumentError);
      }
    });

    test('rejects duplicate set numbers', () async {
      final program = createValidProgram(
        exercises: [
          ProgramExercise(
            exerciseId: 'chest_001',
            exerciseOrder: 1,
            sets: [
              ProgramSet(setNumber: 1, targetReps: 10),
              ProgramSet(setNumber: 1, targetReps: 12),
            ],
          ),
        ],
      );

      await expectLater(repository.saveProgram(program), throwsArgumentError);
    });
  });
  test('returns saved programs even when they have no exercises', () async {
    await database
        .into(database.trainingPrograms)
        .insert(
          TrainingProgramsCompanion.insert(
            id: 'empty_program',
            nameAr: 'برنامج فارغ',
            nameEn: 'Empty Program',
            descriptionAr: '',
            descriptionEn: '',
            durationWeeks: 4,
            levelAr: 'مبتدئ',
            levelEn: 'Beginner',
            category: 1,
            type: ProgramType.custom.name,
          ),
        );

    final programs = await repository.getSavedPrograms();

    expect(programs.length, 1);
    expect(programs.first.id, 'empty_program');
    expect(programs.first.exercises, isEmpty);
  });
  test('replaces old exercises and sets when updating a program', () async {
    final originalProgram = createValidProgram();

    await repository.saveProgram(originalProgram);

    final updatedProgram = createValidProgram(
      id: originalProgram.id,
      exercises: [
        ProgramExercise(
          exerciseId: 'back_001',
          exerciseOrder: 1,
          sets: [
            ProgramSet(setNumber: 1, targetReps: 12),
            ProgramSet(setNumber: 2, targetReps: 10),
          ],
        ),
      ],
    );

    await repository.saveProgram(updatedProgram);

    final savedProgram = await repository.getProgramById(originalProgram.id);

    expect(savedProgram, isNotNull);
    expect(savedProgram!.exercises.length, 1);
    expect(savedProgram.exercises.first.exerciseId, 'back_001');
    expect(savedProgram.exercises.first.sets.length, 2);
  });
  test('deletes a program and its exercises and sets', () async {
    final program = createValidProgram();

    await repository.saveProgram(program);

    await repository.deleteProgram(program.id);

    final savedProgram = await repository.getProgramById(program.id);

    final exercises = await database.select(database.programExercises).get();

    final sets = await database.select(database.programSets).get();

    expect(savedProgram, isNull);
    expect(exercises, isEmpty);
    expect(sets, isEmpty);
  });
  test('retrieves multiple exercises and sets in correct order', () async {
    final program = createValidProgram(
      exercises: [
        ProgramExercise(
          exerciseId: 'chest_001',
          exerciseOrder: 2,
          sets: [
            ProgramSet(setNumber: 2, targetReps: 8),
            ProgramSet(setNumber: 1, targetReps: 12),
          ],
        ),
        ProgramExercise(
          exerciseId: 'back_001',
          exerciseOrder: 1,
          sets: [ProgramSet(setNumber: 1, targetReps: 10)],
        ),
      ],
    );

    await repository.saveProgram(program);

    final savedProgram = await repository.getProgramById(program.id);

    expect(savedProgram, isNotNull);
    expect(savedProgram!.exercises.map((e) => e.exerciseId).toList(), [
      'back_001',
      'chest_001',
    ]);
    expect(savedProgram.exercises.last.sets.map((s) => s.setNumber).toList(), [
      1,
      2,
    ]);
  });
 
}
