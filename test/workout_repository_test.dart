import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:fit_forge/data/local/app_database.dart'
    hide WorkoutSession, WorkoutExercise, WorkoutSet;
import 'package:fit_forge/repositories/workout_repository.dart';
import 'package:fit_forge/models/workout_session.dart';
import 'package:fit_forge/models/workout_exercise.dart';
import 'package:fit_forge/models/workout_set.dart';
import 'package:fit_forge/models/exercise.dart';
import 'package:fit_forge/repositories/active_workout_repository.dart';

void main() {
  late AppDatabase database;
  late WorkoutRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = WorkoutRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('saveAndDeleteActiveWorkout', () {
  test('saves workout to history and deletes active snapshot', () async {
    final activeRepository = ActiveWorkoutRepository(database);

    final exercise = Exercise(
      id: 'atomic_test_exercise',
      name: 'تمرين الاختبار الذري',
      muscleGroup: 'الصدر',
      description: '',
      image: '',
      suggestedSets: 2,
      suggestedReps: 10,
      difficulty: 'متوسط',
      equipment: 'بار',
    );

    final session = WorkoutSession(
      id: 'atomic_test_session',
      type: WorkoutType.free,
      startTime: DateTime(2026, 11, 26, 10),
      exercises: [
        WorkoutExercise(
          exercise: exercise,
          sets: [
            WorkoutSet(
              setNumber: 1,
              weight: 40,
              reps: 10,
              isCompleted: true,
            ),
            WorkoutSet(
              setNumber: 2,
              weight: 45,
              reps: 8,
              isCompleted: true,
            ),
          ],
        ),
      ],
    );

    final endTime = DateTime(2026, 11, 26, 10, 45);

    // حفظ نسخة الجلسة النشطة أولاً.
    await activeRepository.saveActiveWorkout(session: session);

    // حفظها في السجل وحذف النسخة النشطة ذرياً.
    await repository.saveAndDeleteActiveWorkout(
      session: session,
      endTime: endTime,
    );

    // التأكد من وجود الجلسة في سجل التمارين.
    final history = await repository.getWorkoutHistory();

    expect(history.length, 1);
    expect(history.single.id, session.id);

    // التأكد من سلامة تفاصيل الجلسة المحفوظة.
    final details = await repository.getWorkoutDetails(session.id);

    expect(details, isNotNull);
    expect(details!.exercises.length, 1);
    expect(details.exercises.single.exerciseId, exercise.id);
    expect(details.exercises.single.sets.length, 2);
    expect(details.exercises.single.sets[0].weight, 40);
    expect(details.exercises.single.sets[1].reps, 8);

    // التأكد من حذف النسخة النشطة.
    final activeWorkout = await activeRepository.getActiveWorkout();

    expect(activeWorkout, isNull);

    expect(
      await database.select(database.activeWorkoutExercises).get(),
      isEmpty,
    );

    expect(
      await database.select(database.activeWorkoutSets).get(),
      isEmpty,
    );
  });
});

  Future<void> addWorkout({
    required String id,
    required DateTime startTime,
    bool completed = true,
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
              weight: 20,
              reps: 10,
              isCompleted: completed,
            ),
          ],
        ),
      ],
    );

    await repository.saveWorkout(
      session: session,
      endTime: startTime.add(const Duration(minutes: 30)),
    );
  }

  group('getCompletedTrainingDaysSince', () {
    test('multiple workouts on the same day count as one day', () async {
      final now = DateTime.now();
      final day = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(const Duration(
        days:1
      )).add(const Duration(hours: 9));
      final startDate = day.subtract(const Duration(days: 5));

      await addWorkout(id: 'workout_1', startTime: day);
      await addWorkout(
        id: 'workout_2',
        startTime: day.add(const Duration(hours: 5)),
      );

      final result = await repository.getCompletedTrainingDaysSince(startDate);

      expect(result, 1);
    });

    test('different training days count separately', () async {
      final now = DateTime.now();
      final day1 = DateTime(
  now.year,
  now.month,
  now.day,
).subtract(const Duration(days: 1)).add(const Duration(hours: 9));
      final day2 = day1.subtract(const Duration(days: 1));
      final startDate = day2.subtract(const Duration(days: 5));

      await addWorkout(id: 'workout_1', startTime: day1);
      await addWorkout(id: 'workout_2', startTime: day2);

      final result = await repository.getCompletedTrainingDaysSince(startDate);

      expect(result, 2);
    });

    test('workouts without completed sets do not count', () async {
      final now = DateTime.now();
      final day = DateTime(now.year, now.month, now.day, 9);
      final startDate = day.subtract(const Duration(days: 5));

      await addWorkout(id: 'workout_1', startTime: day, completed: false);

      final result = await repository.getCompletedTrainingDaysSince(startDate);

      expect(result, 0);
    });

    test('workouts before cycle start do not count', () async {
      final now = DateTime.now();
      final day = DateTime(now.year, now.month, now.day, 9);
      final startDate = day.subtract(const Duration(days: 2));

      await addWorkout(
        id: 'workout_1',
        startTime: startDate.subtract(const Duration(days: 1)),
      );

      final result = await repository.getCompletedTrainingDaysSince(startDate);

      expect(result, 0);
    });

    test('future workouts do not count', () async {
      final now = DateTime.now();
      final tomorrow = DateTime(
        now.year,
        now.month,
        now.day,
      ).add(const Duration(days: 1));

      final startDate = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(const Duration(days: 5));

      await addWorkout(id: 'workout_1', startTime: tomorrow);

      final result = await repository.getCompletedTrainingDaysSince(startDate);

      expect(result, 0);
    });
  });
}
