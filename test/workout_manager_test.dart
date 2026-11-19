import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';

import 'package:fit_forge/data/local/app_database.dart'
    hide WorkoutSession, WorkoutExercise, WorkoutSet;
import 'package:fit_forge/models/exercise.dart';
import 'package:fit_forge/models/workout_session.dart';
import 'package:fit_forge/models/workout_exercise.dart';
import 'package:fit_forge/models/workout_set.dart';
import 'package:fit_forge/repositories/workout_repository.dart';
import 'package:fit_forge/repositories/training_cycle_repository.dart';
import 'package:fit_forge/services/workout_manager.dart';

void main() {
  late AppDatabase database;
  late WorkoutRepository workoutRepository;
  late TrainingCycleRepository trainingCycleRepository;
  late WorkoutManager manager;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());

    workoutRepository = WorkoutRepository(database);
    trainingCycleRepository = TrainingCycleRepository(database);

    manager = WorkoutManager(
      workoutRepository: workoutRepository,
      trainingCycleRepository: trainingCycleRepository,
    );
  });

  tearDown(() async {
    manager.dispose();
    await database.close();
  });

  Future<void> addWorkout({
    required String id,
    required DateTime startTime,
    required int durationMinutes,
    required double weight,
    required int reps,
  }) async {
    final exercise = Exercise(
      id: 'test_exercise',
      name: 'تمرين الاختبار',
      muscleGroup: 'الصدر',
      description: '',
      image: '',
      suggestedSets: 1,
      suggestedReps: 10,
      difficulty: 'مبتدئ',
      equipment: 'دمبل',
    );

    final session = WorkoutSession(
      id: id,
      type: WorkoutType.free,
      startTime: startTime,
      exercises: [
        WorkoutExercise(
          exercise: exercise,
          sets: [
            WorkoutSet(
              setNumber: 1,
              weight: weight,
              reps: reps,
              isCompleted: true,
            ),
          ],
        ),
      ],
    );

    await workoutRepository.saveWorkout(
      session: session,
      endTime: startTime.add(Duration(minutes: durationMinutes)),
    );
  }

  group('WorkoutManager getProgressStats', () {
    test('includes start date and excludes end date', () async {
      final startDate = DateTime(2026, 1, 1);
      final endDate = DateTime(2026, 1, 4);

      await addWorkout(
        id: 'before',
        startTime: DateTime(2025, 12, 31, 10),
        durationMinutes: 30,
        weight: 20,
        reps: 10,
      );

      await addWorkout(
        id: 'at_start',
        startTime: startDate,
        durationMinutes: 30,
        weight: 20,
        reps: 10,
      );

      await addWorkout(
        id: 'at_end',
        startTime: endDate,
        durationMinutes: 30,
        weight: 20,
        reps: 10,
      );

      final result = await manager.getProgressStats(
        startDate: startDate,
        endDate: endDate,
      );

      expect(result.workoutCount, 1);
      expect(result.trainingDays, 1);
      expect(result.totalDuration, const Duration(minutes: 30));
      expect(result.totalWeightLifted, 200);
    });

    test('aggregates multiple workouts on the same day', () async {
      final startDate = DateTime(2026, 1, 1);
      final endDate = DateTime(2026, 1, 4);

      await addWorkout(
        id: 'workout_1',
        startTime: DateTime(2026, 1, 2, 9),
        durationMinutes: 30,
        weight: 20,
        reps: 10,
      );

      await addWorkout(
        id: 'workout_2',
        startTime: DateTime(2026, 1, 2, 17),
        durationMinutes: 45,
        weight: 15,
        reps: 10,
      );

      final result = await manager.getProgressStats(
        startDate: startDate,
        endDate: endDate,
      );

      expect(result.workoutCount, 2);
      expect(result.trainingDays, 1);
      expect(result.totalDuration, const Duration(minutes: 75));
      expect(result.totalWeightLifted, 350);

      expect(result.activityPoints, hasLength(1));
      expect(result.activityPoints.first.workoutCount, 2);
      expect(result.activityPoints.first.totalWeightLifted, 350);
    });

    test('sorts activity points by date', () async {
      final startDate = DateTime(2026, 1, 1);
      final endDate = DateTime(2026, 1, 5);

      await addWorkout(
        id: 'later',
        startTime: DateTime(2026, 1, 3, 9),
        durationMinutes: 30,
        weight: 20,
        reps: 10,
      );

      await addWorkout(
        id: 'earlier',
        startTime: DateTime(2026, 1, 2, 9),
        durationMinutes: 30,
        weight: 20,
        reps: 10,
      );

      final result = await manager.getProgressStats(
        startDate: startDate,
        endDate: endDate,
      );

      expect(result.workoutCount, 2);
      expect(result.trainingDays, 2);
      expect(result.activityPoints, hasLength(2));

      expect(result.activityPoints.first.date, DateTime(2026, 1, 2));

      expect(result.activityPoints.last.date, DateTime(2026, 1, 3));
    });
  });
}
