import 'package:drift/drift.dart';

import '../data/local/app_database.dart' as db;
import '../models/workout_session.dart' as models;
import '../models/workout_history_item.dart';
import '../models/workout_session_details.dart';

class WorkoutRepository {
  final db.AppDatabase database;

  WorkoutRepository(this.database);

  Future<void> saveWorkout({
    required models.WorkoutSession session,
    required DateTime endTime,
  }) async {
    await database.transaction(() async {
      // Save workout session.
      await database
          .into(database.workoutSessions)
          .insert(
            db.WorkoutSessionsCompanion.insert(
              id: session.id,
              type: session.type.name,
              programName: Value(session.programName),
              startTime: session.startTime,
              endTime: endTime,
            ),
          );

      // Save exercises and their sets.
      for (
        var exerciseIndex = 0;
        exerciseIndex < session.exercises.length;
        exerciseIndex++
      ) {
        final workoutExercise = session.exercises[exerciseIndex];
        final exercise = workoutExercise.exercise;

        final workoutExerciseId = '${session.id}_exercise_$exerciseIndex';

        await database
            .into(database.workoutExercises)
            .insert(
              db.WorkoutExercisesCompanion.insert(
                id: workoutExerciseId,
                sessionId: session.id,
                exerciseId: exercise.id,
                exerciseName: exercise.name,
                exerciseNameEn: Value(exercise.nameEn),
                muscleGroup: exercise.muscleGroup,
                muscleGroupEn: Value(exercise.muscleGroupEn),
                exerciseOrder: exerciseIndex,
              ),
            );

        for (final set in workoutExercise.sets) {
          await database
              .into(database.workoutSets)
              .insert(
                db.WorkoutSetsCompanion.insert(
                  id: '${workoutExerciseId}_set_${set.setNumber}',
                  workoutExerciseId: workoutExerciseId,
                  setNumber: set.setNumber,
                  weight: set.weight,
                  reps: set.reps,
                  isCompleted: set.isCompleted,
                ),
              );
        }
      }
    });
  }

  Future<List<db.WorkoutSession>> getWorkoutHistory() {
    return (database.select(
      database.workoutSessions,
    )..orderBy([(session) => OrderingTerm.desc(session.startTime)])).get();
  }

  Future<List<WorkoutHistoryItem>> getWorkoutHistoryItems() async {
    final sessions = await getWorkoutHistory();

    if (sessions.isEmpty) return [];

    final sessionIds = sessions.map((session) => session.id).toList();

    // Load all exercises for all sessions in one query.
    final exercises = await (database.select(
      database.workoutExercises,
    )..where((exercise) => exercise.sessionId.isIn(sessionIds))).get();

    final exerciseIds = exercises.map((exercise) => exercise.id).toList();

    // Map each exercise to its session.
    final sessionIdByExerciseId = {
      for (final exercise in exercises) exercise.id: exercise.sessionId,
    };

    // Count exercises per session.
    final exerciseCountBySession = <String, int>{};

    for (final exercise in exercises) {
      exerciseCountBySession.update(
        exercise.sessionId,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }

    // Load all sets in one query.
    final sets = exerciseIds.isEmpty
        ? []
        : await (database.select(
            database.workoutSets,
          )..where((set) => set.workoutExerciseId.isIn(exerciseIds))).get();

    final completedSetsBySession = <String, int>{};
    final totalWeightBySession = <String, double>{};

    for (final set in sets) {
      if (!set.isCompleted) continue;

      final sessionId = sessionIdByExerciseId[set.workoutExerciseId];
      if (sessionId == null) continue;

      completedSetsBySession.update(
        sessionId,
        (count) => count + 1,
        ifAbsent: () => 1,
      );

      totalWeightBySession.update(
        sessionId,
        (weight) => weight + (set.weight * set.reps),
        ifAbsent: () => set.weight * set.reps,
      );
    }

    return sessions.map((session) {
      return WorkoutHistoryItem(
        id: session.id,
        type: session.type,
        programName: session.programName,
        startTime: session.startTime,
        endTime: session.endTime,
        exerciseCount: exerciseCountBySession[session.id] ?? 0,
        completedSets: completedSetsBySession[session.id] ?? 0,
        totalWeightLifted: totalWeightBySession[session.id] ?? 0,
      );
    }).toList();
  }

  Future<WorkoutSessionDetails?> getWorkoutDetails(String sessionId) async {
    // 1. جلب الجلسة.
    final session = await (database.select(
      database.workoutSessions,
    )..where((table) => table.id.equals(sessionId))).getSingleOrNull();

    if (session == null) return null;

    // 2. جلب جميع تمارين الجلسة.
    final exercises =
        await (database.select(database.workoutExercises)
              ..where((table) => table.sessionId.equals(sessionId))
              ..orderBy([(table) => OrderingTerm.asc(table.exerciseOrder)]))
            .get();

    if (exercises.isEmpty) {
      return WorkoutSessionDetails(
        id: session.id,
        type: session.type,
        programName: session.programName,
        startTime: session.startTime,
        endTime: session.endTime,
        exercises: [],
      );
    }

    final exerciseIds = exercises.map((exercise) => exercise.id).toList();

    // 3. جلب جميع مجموعات التمارين باستعلام واحد.
    final sets =
        await (database.select(database.workoutSets)
              ..where((table) => table.workoutExerciseId.isIn(exerciseIds))
              ..orderBy([(table) => OrderingTerm.asc(table.setNumber)]))
            .get();

    // تجميع المجموعات حسب التمرين.
    final setsByExerciseId = <String, List<WorkoutSetDetails>>{};

    for (final set in sets) {
      setsByExerciseId
          .putIfAbsent(set.workoutExerciseId, () => [])
          .add(
            WorkoutSetDetails(
              setNumber: set.setNumber,
              weight: set.weight,
              reps: set.reps,
              isCompleted: set.isCompleted,
            ),
          );
    }

    // بناء تفاصيل التمارين.
    final exerciseDetails = exercises.map((exercise) {
      return WorkoutExerciseDetails(
        id: exercise.id,
        exerciseId: exercise.exerciseId,
        exerciseName: exercise.exerciseName,
        exerciseNameEn: exercise.exerciseNameEn,
        muscleGroup: exercise.muscleGroup,
        muscleGroupEn: exercise.muscleGroupEn,
        exerciseOrder: exercise.exerciseOrder,
        sets: setsByExerciseId[exercise.id] ?? [],
      );
    }).toList();

    return WorkoutSessionDetails(
      id: session.id,
      type: session.type,
      programName: session.programName,
      startTime: session.startTime,
      endTime: session.endTime,
      exercises: exerciseDetails,
    );
  }

  Future<int> getCompletedTrainingDaysSince(DateTime startDate) async {
    final history = await getWorkoutHistoryItems();
    final now = DateTime.now();

    final trainingDays = <String>{};

    for (final workout in history) {
      if (workout.completedSets <= 0) continue;
      if (workout.startTime.isBefore(startDate)) continue;
      if (workout.startTime.isAfter(now)) continue;

      final date = workout.startTime;

      trainingDays.add('${date.year}-${date.month}-${date.day}');
    }

    return trainingDays.length;
  }
}
