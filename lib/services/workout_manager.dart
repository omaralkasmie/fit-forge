import 'package:flutter/foundation.dart';

import '../models/exercise.dart';
import '../models/workout_exercise.dart';
import '../models/workout_session.dart';
import '../repositories/workout_repository.dart';
import '../models/workout_history_item.dart';
import '../models/workout_session_details.dart';

class WorkoutManager extends ChangeNotifier {
  final WorkoutRepository _workoutRepository;

  WorkoutManager({required this._workoutRepository});

  WorkoutSession? _session;

  WorkoutSession? get session => _session;

  bool get hasActiveWorkout => _session != null;

  bool get isWorkoutCompleted => _session?.isCompleted ?? false;

  int get completedExercises => _session?.completedExercises ?? 0;

  int get totalExercises => _session?.exercises.length ?? 0;
  WorkoutSession? _completedSession;
  DateTime? _workoutEndTime;

  WorkoutSession? get completedSession => _completedSession;

  DateTime? get workoutEndTime => _workoutEndTime;

  int get completedSets {
    final session = _completedSession;
    if (session == null) return 0;

    return session.exercises.fold(
      0,
      (total, exercise) => total + exercise.completedSets,
    );
  }

  double get totalWeightLifted {
    final session = _completedSession;
    if (session == null) return 0;

    double total = 0;

    for (final exercise in session.exercises) {
      for (final set in exercise.sets) {
        if (set.isCompleted) {
          total += set.weight * set.reps;
        }
      }
    }

    return total;
  }

  void startFreeWorkout(List<Exercise> exercises) {
    _startWorkout(exercises: exercises, type: WorkoutType.free);
  }

  void startProgramWorkout({
    required String programName,
    required List<Exercise> exercises,
  }) {
    _startWorkout(
      exercises: exercises,
      type: WorkoutType.program,
      programName: programName,
    );
  }

  void _startWorkout({
    required List<Exercise> exercises,
    required WorkoutType type,
    String? programName,
  }) {
    _completedSession = null;
    _workoutEndTime = null;

    _session = WorkoutSession(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: type,
      programName: programName,
      exercises: exercises
          .map((exercise) => WorkoutExercise(exercise: exercise))
          .toList(),
    );

    notifyListeners();
  }

  void addExercise(Exercise exercise) {
    if (_session == null) return;

    final exists = _session!.exercises.any(
      (item) => item.exercise.id == exercise.id,
    );

    if (exists) return;

    _updateExercises([
      ..._session!.exercises,
      WorkoutExercise(exercise: exercise),
    ]);
  }

  void removeExercise(int index) {
    if (_session == null) return;
    if (index < 0 || index >= totalExercises) return;

    final exercises = [..._session!.exercises];
    exercises.removeAt(index);

    _updateExercises(exercises);
  }

  void reorderExercises(int oldIndex, int newIndex) {
    if (_session == null) return;

    final exercises = [..._session!.exercises];

    if (oldIndex < 0 || oldIndex >= exercises.length) return;
    if (newIndex < 0 || newIndex >= exercises.length) return;

    final exercise = exercises.removeAt(oldIndex);
    exercises.insert(newIndex, exercise);

    _updateExercises(exercises);
  }

  void updateSet({
    required int exerciseIndex,
    required int setIndex,
    required double weight,
    required int reps,
  }) {
    final workoutExercise = _getExercise(exerciseIndex);
    if (workoutExercise == null) return;

    if (setIndex < 0 || setIndex >= workoutExercise.sets.length) {
      return;
    }

    final set = workoutExercise.sets[setIndex];

    if (set.isCompleted) return;

    set.weight = weight;
    set.reps = reps;

    notifyListeners();
  }

  bool completeSet({required int exerciseIndex, required int setIndex}) {
    final workoutExercise = _getExercise(exerciseIndex);
    if (workoutExercise == null) return false;

    if (setIndex < 0 || setIndex >= workoutExercise.sets.length) {
      return false;
    }

    final set = workoutExercise.sets[setIndex];

    if (set.isCompleted || set.reps <= 0 || set.weight < 0) {
      return false;
    }

    set.isCompleted = true;

    notifyListeners();
    return true;
  }

  WorkoutExercise? _getExercise(int index) {
    if (_session == null) return null;

    if (index < 0 || index >= _session!.exercises.length) {
      return null;
    }

    return _session!.exercises[index];
  }

  void _updateExercises(List<WorkoutExercise> exercises) {
    final current = _session!;

    _session = WorkoutSession(
      id: current.id,
      type: current.type,
      programName: current.programName,
      exercises: exercises,
      startTime: current.startTime,
    );

    notifyListeners();
  }

  Future<bool> finishWorkout() async {
    if (_session == null) return false;

    final sessionToSave = _session!;
    final endTime = DateTime.now();

    try {
      await _workoutRepository.saveWorkout(
        session: sessionToSave,
        endTime: endTime,
      );

      _completedSession = sessionToSave;
      _workoutEndTime = endTime;
      _session = null;

      notifyListeners();

      return true;
    } catch (error, stackTrace) {
      debugPrint('Failed to save workout: $error');
      debugPrintStack(stackTrace: stackTrace);

      return false;
    }
  }

  Future<List<WorkoutHistoryItem>> getWorkoutHistory() {
    return _workoutRepository.getWorkoutHistoryItems();
  }

  void cancelWorkout() {
    _session = null;
    _completedSession = null;
    _workoutEndTime = null;

    notifyListeners();
  }
  Future<WorkoutSessionDetails?> getWorkoutDetails(
  String sessionId,
) {
  return _workoutRepository.getWorkoutDetails(sessionId);
}
}
