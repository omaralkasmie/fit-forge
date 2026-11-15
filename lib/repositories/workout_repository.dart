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

    final historyItems = <WorkoutHistoryItem>[];

    for (final session in sessions) {
      final exercises = await (database.select(
        database.workoutExercises,
      )..where((exercise) => exercise.sessionId.equals(session.id))).get();

      int completedSets = 0;
      double totalWeightLifted = 0;

      for (final exercise in exercises) {
        final sets = await (database.select(
          database.workoutSets,
        )..where((set) => set.workoutExerciseId.equals(exercise.id))).get();

        for (final set in sets) {
          if (set.isCompleted) {
            completedSets++;
            totalWeightLifted += set.weight * set.reps;
          }
        }
      }

      historyItems.add(
        WorkoutHistoryItem(
          id: session.id,
          type: session.type,
          programName: session.programName,
          startTime: session.startTime,
          endTime: session.endTime,
          exerciseCount: exercises.length,
          completedSets: completedSets,
          totalWeightLifted: totalWeightLifted,
        ),
      );
    }

    return historyItems;
  }

  Future<WorkoutSessionDetails?> getWorkoutDetails(
  String sessionId,
) async {
  final session = await (database.select(database.workoutSessions)
        ..where((table) => table.id.equals(sessionId)))
      .getSingleOrNull();

  if (session == null) return null;

  final exercises = await (database.select(database.workoutExercises)
        ..where((table) => table.sessionId.equals(sessionId))
        ..orderBy([
          (table) => OrderingTerm.asc(table.exerciseOrder),
        ]))
      .get();

  final exerciseDetails = <WorkoutExerciseDetails>[];

  for (final exercise in exercises) {
    final sets = await (database.select(database.workoutSets)
          ..where((table) => table.workoutExerciseId.equals(exercise.id))
          ..orderBy([
            (table) => OrderingTerm.asc(table.setNumber),
          ]))
        .get();

    exerciseDetails.add(
      WorkoutExerciseDetails(
        id: exercise.id,
        exerciseId: exercise.exerciseId,
        exerciseName: exercise.exerciseName,
        exerciseNameEn: exercise.exerciseNameEn,
        muscleGroup: exercise.muscleGroup,
        muscleGroupEn: exercise.muscleGroupEn,
        exerciseOrder: exercise.exerciseOrder,
        sets: sets.map((set) {
          return WorkoutSetDetails(
            setNumber: set.setNumber,
            weight: set.weight,
            reps: set.reps,
            isCompleted: set.isCompleted,
          );
        }).toList(),
      ),
    );
  }

  return WorkoutSessionDetails(
    id: session.id,
    type: session.type,
    programName: session.programName,
    startTime: session.startTime,
    endTime: session.endTime,
    exercises: exerciseDetails,
  );
}

Future<int> getCompletedTrainingDaysSince(
  DateTime startDate,
) async {
  final history = await getWorkoutHistoryItems();

  final trainingDays = <String>{};

  for (final workout in history) {
    if (workout.completedSets <= 0) continue;
    if (workout.startTime.isBefore(startDate)) continue;

    final date = workout.startTime;

    trainingDays.add(
      '${date.year}-${date.month}-${date.day}',
    );
  }

  return trainingDays.length;
}
}
