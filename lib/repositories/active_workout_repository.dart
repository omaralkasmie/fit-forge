import 'package:drift/drift.dart';

import '../data/local/app_database.dart' as db;
import '../models/exercise.dart';
import '../models/workout_exercise.dart';
import '../models/workout_session.dart';
import '../models/workout_set.dart';
import '../services/exercise_serializer.dart';

class ActiveWorkoutRepository {
  final db.AppDatabase database;

  ActiveWorkoutRepository(this.database);

  /// Saves the complete active workout as one atomic transaction.
  /// Only one active workout is allowed at a time.
  Future<void> saveActiveWorkout({
    required WorkoutSession session,
  }) async {
    await database.transaction(() async {
      // Remove the previous snapshot and its children.
      await database.delete(database.activeWorkoutSets).go();
      await database.delete(database.activeWorkoutExercises).go();
      await database.delete(database.activeWorkoutSessions).go();

      // Save the active session.
      await database
          .into(database.activeWorkoutSessions)
          .insert(
            db.ActiveWorkoutSessionsCompanion.insert(
              id: session.id,
              type: session.type.name,
              programName: Value(session.programName),
              startTime: session.startTime,
            ),
          );

      // Save exercises and their complete data.
      for (
        var exerciseIndex = 0;
        exerciseIndex < session.exercises.length;
        exerciseIndex++
      ) {
        final workoutExercise = session.exercises[exerciseIndex];

        final workoutExerciseId =
            '${session.id}_exercise_$exerciseIndex';

        await database
            .into(database.activeWorkoutExercises)
            .insert(
              db.ActiveWorkoutExercisesCompanion.insert(
                id: workoutExerciseId,
                sessionId: session.id,
                exerciseData: ExerciseSerializer.toJson(
                  workoutExercise.exercise,
                ),
                exerciseOrder: exerciseIndex,
              ),
            );

        // Save all sets.
        for (final set in workoutExercise.sets) {
          await database
              .into(database.activeWorkoutSets)
              .insert(
                db.ActiveWorkoutSetsCompanion.insert(
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

  /// Restores the active workout, including exercises and sets.
  Future<WorkoutSession?> getActiveWorkout() async {
    final sessions = await database
        .select(database.activeWorkoutSessions)
        .get();

    if (sessions.isEmpty) return null;

    if (sessions.length > 1) {
      throw StateError(
        'More than one active workout was found.',
      );
    }

    final storedSession = sessions.single;

    final workoutType = WorkoutType.values.firstWhere(
      (type) => type.name == storedSession.type,
      orElse: () => throw FormatException(
        'Unknown workout type: ${storedSession.type}',
      ),
    );

    // Load exercises in their original order.
    final storedExercises =
        await (database.select(database.activeWorkoutExercises)
              ..where(
                (table) => table.sessionId.equals(storedSession.id),
              )
              ..orderBy([
                (table) => OrderingTerm.asc(table.exerciseOrder),
              ]))
            .get();

    if (storedExercises.isEmpty) {
      return WorkoutSession(
        id: storedSession.id,
        type: workoutType,
        programName: storedSession.programName,
        exercises: [],
        startTime: storedSession.startTime,
      );
    }

    final exerciseIds = storedExercises
        .map((exercise) => exercise.id)
        .toList();

    // Load all sets in one query.
    final storedSets =
        await (database.select(database.activeWorkoutSets)
              ..where(
                (table) => table.workoutExerciseId.isIn(exerciseIds),
              )
              ..orderBy([
                (table) => OrderingTerm.asc(table.setNumber),
              ]))
            .get();

    // Group sets by their workout exercise.
    final setsByExerciseId = <String, List<WorkoutSet>>{};

    for (final storedSet in storedSets) {
      setsByExerciseId
          .putIfAbsent(
            storedSet.workoutExerciseId,
            () => [],
          )
          .add(
            WorkoutSet(
              setNumber: storedSet.setNumber,
              weight: storedSet.weight,
              reps: storedSet.reps,
              isCompleted: storedSet.isCompleted,
            ),
          );
    }

    // Rebuild workout exercises with their original exercise data.
    final workoutExercises = storedExercises.map((storedExercise) {
      final Exercise exercise = ExerciseSerializer.fromJson(
        storedExercise.exerciseData,
      );

      return WorkoutExercise(
        exercise: exercise,
        sets: setsByExerciseId[storedExercise.id] ?? [],
      );
    }).toList();

    return WorkoutSession(
      id: storedSession.id,
      type: workoutType,
      programName: storedSession.programName,
      exercises: workoutExercises,
      startTime: storedSession.startTime,
    );
  }

  /// Deletes the active workout snapshot.
  Future<void> deleteActiveWorkout(String sessionId) async {
    await database.transaction(() async {
      final exerciseIds =
          await (database.select(database.activeWorkoutExercises)
                ..where(
                  (table) => table.sessionId.equals(sessionId),
                ))
              .map((row) => row.id)
              .get();

      if (exerciseIds.isNotEmpty) {
        await (database.delete(database.activeWorkoutSets)
              ..where(
                (table) =>
                    table.workoutExerciseId.isIn(exerciseIds),
              ))
            .go();
      }

      await (database.delete(database.activeWorkoutExercises)
            ..where(
              (table) => table.sessionId.equals(sessionId),
            ))
          .go();

      await (database.delete(database.activeWorkoutSessions)
            ..where(
              (table) => table.id.equals(sessionId),
            ))
          .go();
    });
  }
}