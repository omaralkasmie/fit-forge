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
}
