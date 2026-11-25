import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';

import 'package:fit_forge/data/local/app_database.dart' as db;
import 'package:fit_forge/models/exercise.dart';
import 'package:fit_forge/models/workout_exercise.dart' as models;
import 'package:fit_forge/models/workout_session.dart' as models;
import 'package:fit_forge/models/workout_set.dart' as models;
import 'package:fit_forge/repositories/active_workout_repository.dart';

void main() {
  late db.AppDatabase database;
  late ActiveWorkoutRepository repository;

  setUp(() {
    database = db.AppDatabase(NativeDatabase.memory());
    repository = ActiveWorkoutRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  models.WorkoutSession createTestSession() {
    const exercise1 = Exercise(
      id: 'test_001',
      name: 'ضغط الصدر بالبار',
      muscleGroup: 'الصدر',
      description: 'تمرين الصدر',
      image: 'bench_press.jpg',
      suggestedSets: 3,
      suggestedReps: 12,
      difficulty: 'متوسط',
      equipment: 'بار',
      nameEn: 'Barbell Bench Press',
      equipmentIds: ['barbell', 'bench'],
    );

    const exercise2 = Exercise(
      id: 'test_002',
      name: 'سحب أمامي',
      muscleGroup: 'الظهر',
      description: 'تمرين الظهر',
      image: 'lat_pulldown.jpg',
      suggestedSets: 2,
      suggestedReps: 10,
      difficulty: 'مبتدئ',
      equipment: 'كابل',
      source: 'external',
      category: 'strength',
      secondaryMuscles: ['biceps'],
    );

    return models.WorkoutSession(
      id: 'session_001',
      type: models.WorkoutType.program,
      programName: 'برنامج بناء العضلات',
      startTime: DateTime(2026, 11, 25, 10, 30),
      exercises: [
        models.WorkoutExercise(
          exercise: exercise1,
          sets: [
            models.WorkoutSet(
              setNumber: 1,
              weight: 40,
              reps: 12,
              isCompleted: true,
            ),
            models.WorkoutSet(
              setNumber: 2,
              weight: 45,
              reps: 10,
              isCompleted: false,
            ),
            models.WorkoutSet(
              setNumber: 3,
              weight: 50,
              reps: 8,
              isCompleted: false,
            ),
          ],
        ),
        models.WorkoutExercise(
          exercise: exercise2,
          sets: [
            models.WorkoutSet(
              setNumber: 1,
              weight: 30,
              reps: 10,
              isCompleted: false,
            ),
            models.WorkoutSet(
              setNumber: 2,
              weight: 35,
              reps: 8,
              isCompleted: false,
            ),
          ],
        ),
      ],
    );
  }

  group('ActiveWorkoutRepository', () {
    test('returns null when no active workout exists', () async {
      final result = await repository.getActiveWorkout();

      expect(result, isNull);
    });

    test('saves and restores the complete active workout', () async {
      final original = createTestSession();

      await repository.saveActiveWorkout(session: original);

      final restored = await repository.getActiveWorkout();

      expect(restored, isNotNull);
      expect(restored!.id, original.id);
      expect(restored.type, original.type);
      expect(restored.programName, original.programName);
      expect(restored.startTime, original.startTime);

      expect(restored.exercises.length, 2);

      final firstExercise = restored.exercises[0];

      expect(firstExercise.exercise.id, 'test_001');
      expect(firstExercise.exercise.name, 'ضغط الصدر بالبار');
      expect(firstExercise.exercise.nameEn, 'Barbell Bench Press');
      expect(
        firstExercise.exercise.equipmentIds,
        ['barbell', 'bench'],
      );

      expect(firstExercise.sets.length, 3);
      expect(firstExercise.sets[0].weight, 40);
      expect(firstExercise.sets[0].reps, 12);
      expect(firstExercise.sets[0].isCompleted, isTrue);

      expect(firstExercise.sets[1].weight, 45);
      expect(firstExercise.sets[1].reps, 10);
      expect(firstExercise.sets[1].isCompleted, isFalse);

      final secondExercise = restored.exercises[1];

      expect(secondExercise.exercise.id, 'test_002');
      expect(secondExercise.exercise.source, 'external');
      expect(secondExercise.exercise.category, 'strength');
      expect(secondExercise.exercise.secondaryMuscles, ['biceps']);

      expect(secondExercise.sets.length, 2);
      expect(secondExercise.sets[0].weight, 30);
      expect(secondExercise.sets[1].weight, 35);
    });

    test('replaces the previous active workout', () async {
      final firstSession = createTestSession();

      await repository.saveActiveWorkout(session: firstSession);

      final secondSession = models.WorkoutSession(
        id: 'session_002',
        type: models.WorkoutType.free,
        exercises: [],
      );

      await repository.saveActiveWorkout(session: secondSession);

      final restored = await repository.getActiveWorkout();

      expect(restored, isNotNull);
      expect(restored!.id, 'session_002');
      expect(restored.type, models.WorkoutType.free);
      expect(restored.programName, isNull);
      expect(restored.exercises, isEmpty);
    });

    test('deletes the active workout and its children', () async {
      final session = createTestSession();

      await repository.saveActiveWorkout(session: session);

      await repository.deleteActiveWorkout(session.id);

      final restored = await repository.getActiveWorkout();

      expect(restored, isNull);

      expect(
        await database.select(database.activeWorkoutExercises).get(),
        isEmpty,
      );

      expect(
        await database.select(database.activeWorkoutSets).get(),
        isEmpty,
      );
    });

    test('preserves free workout type without a program name', () async {
      final session = models.WorkoutSession(
        id: 'free_session',
        type: models.WorkoutType.free,
        exercises: [],
      );

      await repository.saveActiveWorkout(session: session);

      final restored = await repository.getActiveWorkout();

      expect(restored, isNotNull);
      expect(restored!.type, models.WorkoutType.free);
      expect(restored.programName, isNull);
      expect(restored.exercises, isEmpty);
    });
  });
}