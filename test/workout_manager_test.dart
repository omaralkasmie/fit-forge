import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';

import 'dart:async';

import 'package:fit_forge/data/local/app_database.dart'
    hide
        WorkoutSession,
        WorkoutExercise,
        WorkoutSet,
        ProgramExercise,
        ProgramSet;
import 'package:fit_forge/models/exercise.dart';
import 'package:fit_forge/models/workout_session.dart';
import 'package:fit_forge/models/workout_exercise.dart';
import 'package:fit_forge/models/workout_set.dart';
import 'package:fit_forge/repositories/workout_repository.dart';
import 'package:fit_forge/repositories/training_cycle_repository.dart';
import 'package:fit_forge/services/workout_manager.dart';
import 'package:fit_forge/models/program_exercise.dart' as program_models;
import 'package:fit_forge/models/program_set.dart' as program_set_models;

class DelayedWorkoutRepository extends WorkoutRepository {
  DelayedWorkoutRepository(super.database);

  final saveStarted = Completer<void>();
  final allowSave = Completer<void>();

  @override
  Future<void> saveWorkout({
    required WorkoutSession session,
    required DateTime endTime,
  }) async {
    if (!saveStarted.isCompleted) {
      saveStarted.complete();
    }

    await allowSave.future;
  }
}

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
    bool isCompleted = true,
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
              isCompleted: isCompleted,
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
  group('WorkoutManager getWorkoutAchievements', () {
    test('returns locked achievements when there are no workouts', () async {
      final result = await manager.getWorkoutAchievements();

      expect(result, hasLength(6));

      for (final achievement in result) {
        expect(achievement.currentValue, 0);
        expect(achievement.isUnlocked, false);
        expect(achievement.progress, 0);
      }
    });

    test('unlocks achievements when their targets are reached', () async {
      for (var i = 0; i < 50; i++) {
        await addWorkout(
          id: 'workout_$i',
          startTime: DateTime(2026, 1, 1).add(Duration(days: i)),
          durationMinutes: 30,
          weight: 20,
          reps: 10,
        );
      }

      final result = await manager.getWorkoutAchievements();

      final achievements = {
        for (final achievement in result) achievement.id: achievement,
      };

      expect(achievements['first_workout']!.currentValue, 50);
      expect(achievements['five_workouts']!.currentValue, 50);
      expect(achievements['ten_workouts']!.currentValue, 50);
      expect(achievements['ten_training_days']!.currentValue, 50);
      expect(achievements['twenty_five_workouts']!.currentValue, 50);
      expect(achievements['fifty_workouts']!.currentValue, 50);

      for (final achievement in result) {
        expect(achievement.isUnlocked, true);
        expect(achievement.progress, 1);
      }
    });

    test(
      'counts multiple workouts on the same day as one training day',
      () async {
        await addWorkout(
          id: 'workout_1',
          startTime: DateTime(2026, 1, 1, 9),
          durationMinutes: 30,
          weight: 20,
          reps: 10,
        );

        await addWorkout(
          id: 'workout_2',
          startTime: DateTime(2026, 1, 1, 17),
          durationMinutes: 30,
          weight: 20,
          reps: 10,
        );

        await addWorkout(
          id: 'workout_3',
          startTime: DateTime(2026, 1, 2, 9),
          durationMinutes: 30,
          weight: 20,
          reps: 10,
        );

        final result = await manager.getWorkoutAchievements();

        final workoutAchievement = result.firstWhere(
          (item) => item.id == 'first_workout',
        );

        final trainingDaysAchievement = result.firstWhere(
          (item) => item.id == 'ten_training_days',
        );

        expect(workoutAchievement.currentValue, 3);
        expect(trainingDaysAchievement.currentValue, 2);
      },
    );

    test('ignores workouts without completed sets', () async {
      await addWorkout(
        id: 'completed',
        startTime: DateTime(2026, 1, 1, 9),
        durationMinutes: 30,
        weight: 20,
        reps: 10,
      );

      await addWorkout(
        id: 'incomplete',
        startTime: DateTime(2026, 1, 2, 9),
        durationMinutes: 30,
        weight: 20,
        reps: 10,
        isCompleted: false,
      );

      final result = await manager.getWorkoutAchievements();

      final workoutAchievement = result.firstWhere(
        (item) => item.id == 'first_workout',
      );

      final trainingDaysAchievement = result.firstWhere(
        (item) => item.id == 'ten_training_days',
      );

      expect(workoutAchievement.currentValue, 1);
      expect(trainingDaysAchievement.currentValue, 1);
    });
  });
  group('WorkoutManager save protection', () {
    test('does not cancel workout while saving', () async {
      final delayedRepository = DelayedWorkoutRepository(database);

      final delayedManager = WorkoutManager(
        workoutRepository: delayedRepository,
        trainingCycleRepository: trainingCycleRepository,
      );

      try {
        final exercise = Exercise(
          id: 'protection_test',
          name: 'تمرين الحماية',
          muscleGroup: 'الصدر',
          description: '',
          image: '',
          suggestedSets: 1,
          suggestedReps: 10,
          difficulty: 'مبتدئ',
          equipment: 'دمبل',
        );

        delayedManager.startFreeWorkout([exercise]);

        delayedManager.updateSet(
          exerciseIndex: 0,
          setIndex: 0,
          weight: 20,
          reps: 10,
        );

        expect(delayedManager.completeSet(exerciseIndex: 0, setIndex: 0), true);

        final finishFuture = delayedManager.finishWorkout();

        await delayedRepository.saveStarted.future;

        // محاولة إلغاء الجلسة أثناء الحفظ.
        delayedManager.cancelWorkout();

        expect(delayedManager.session, isNotNull);
        expect(delayedManager.session!.id, isNotEmpty);

        // السماح بإكمال عملية الحفظ.
        delayedRepository.allowSave.complete();

        expect(await finishFuture, true);
        expect(delayedManager.session, isNull);
      } finally {
        if (!delayedRepository.allowSave.isCompleted) {
          delayedRepository.allowSave.complete();
        }

        delayedManager.dispose();
      }
    });
    test('does not start a valid program workout while saving', () async {
      final delayedRepository = DelayedWorkoutRepository(database);

      final delayedManager = WorkoutManager(
        workoutRepository: delayedRepository,
        trainingCycleRepository: trainingCycleRepository,
      );

      try {
        final exercise = Exercise(
          id: 'program_protection_test',
          name: 'تمرين البرنامج',
          muscleGroup: 'الصدر',
          description: '',
          image: '',
          suggestedSets: 1,
          suggestedReps: 10,
          difficulty: 'مبتدئ',
          equipment: 'دمبل',
        );

        delayedManager.startFreeWorkout([exercise]);

        delayedManager.updateSet(
          exerciseIndex: 0,
          setIndex: 0,
          weight: 20,
          reps: 10,
        );

        expect(delayedManager.completeSet(exerciseIndex: 0, setIndex: 0), true);

        final originalSessionId = delayedManager.session!.id;

        final finishFuture = delayedManager.finishWorkout();

        await delayedRepository.saveStarted.future;

        delayedManager.startProgramWorkoutWithSets(
          programName: 'برنامج الاختبار',
          exercises: [exercise],
          programExercises: [
            program_models.ProgramExercise(
              exerciseId: exercise.id,
              exerciseOrder: 1,
              sets: [
                program_set_models.ProgramSet(
                  setNumber: 1,
                  targetWeight: 20,
                  targetReps: 10,
                ),
              ],
            ),
          ],
        );

        expect(delayedManager.session, isNotNull);
        expect(delayedManager.session!.id, originalSessionId);

        delayedRepository.allowSave.complete();

        expect(await finishFuture, true);
        expect(delayedManager.session, isNull);
      } finally {
        if (!delayedRepository.allowSave.isCompleted) {
          delayedRepository.allowSave.complete();
        }

        delayedManager.dispose();
      }
    });
    test('does not start a program workout while saving', () async {
      final delayedRepository = DelayedWorkoutRepository(database);

      final delayedManager = WorkoutManager(
        workoutRepository: delayedRepository,
        trainingCycleRepository: trainingCycleRepository,
      );

      try {
        final exercise = Exercise(
          id: 'program_protection_test',
          name: 'تمرين البرنامج',
          muscleGroup: 'الصدر',
          description: '',
          image: '',
          suggestedSets: 1,
          suggestedReps: 10,
          difficulty: 'مبتدئ',
          equipment: 'دمبل',
        );

        delayedManager.startFreeWorkout([exercise]);

        delayedManager.updateSet(
          exerciseIndex: 0,
          setIndex: 0,
          weight: 20,
          reps: 10,
        );

        expect(delayedManager.completeSet(exerciseIndex: 0, setIndex: 0), true);

        final originalSessionId = delayedManager.session!.id;

        final finishFuture = delayedManager.finishWorkout();

        await delayedRepository.saveStarted.future;

        delayedManager.startProgramWorkoutWithSets(
          programName: 'برنامج الاختبار',
          exercises: [exercise],
          programExercises: [],
        );

        expect(delayedManager.session, isNotNull);
        expect(delayedManager.session!.id, originalSessionId);

        delayedRepository.allowSave.complete();

        expect(await finishFuture, true);
        expect(delayedManager.session, isNull);
      } finally {
        if (!delayedRepository.allowSave.isCompleted) {
          delayedRepository.allowSave.complete();
        }

        delayedManager.dispose();
      }
    });
  });
}
