import 'package:flutter/foundation.dart';

import '../models/exercise.dart';
import '../models/workout_exercise.dart';
import '../models/workout_session.dart';
import '../repositories/workout_repository.dart';
import '../models/workout_history_item.dart';
import '../models/workout_session_details.dart';
import '../models/workout_progress_stats.dart';
import '../models/workout_achievement.dart';
import '../repositories/training_cycle_repository.dart';
import '../models/training_cycle_progress.dart';
import '../models/program_exercise.dart';
import '../models/workout_set.dart';

class WorkoutManager extends ChangeNotifier {
  final WorkoutRepository _workoutRepository;
  final TrainingCycleRepository _trainingCycleRepository;

  WorkoutManager({
    required WorkoutRepository workoutRepository,
    required TrainingCycleRepository trainingCycleRepository,
  }) : _workoutRepository = workoutRepository,
       _trainingCycleRepository = trainingCycleRepository;

  WorkoutSession? _session;

  WorkoutSession? get session => _session;

  bool get hasActiveWorkout => _session != null;

  bool get isWorkoutCompleted => _session?.isCompleted ?? false;

  int get completedExercises => _session?.completedExercises ?? 0;

  int get totalExercises => _session?.exercises.length ?? 0;

  bool _isSessionComplete() {
    final currentSession = _session;

    if (currentSession == null) return false;

    if (currentSession.exercises.isEmpty) return false;

    for (final exercise in currentSession.exercises) {
      if (exercise.sets.isEmpty) return false;

      for (final set in exercise.sets) {
        if (!set.isCompleted) return false;
      }
    }

    return true;
  }

  WorkoutSession? _completedSession;
  DateTime? _workoutEndTime;

  bool _isFinishingWorkout = false;

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

  void startProgramWorkoutWithSets({
    required String programName,
    required List<Exercise> exercises,
    required List<ProgramExercise> programExercises,
  }) {
    if (exercises.isEmpty || programExercises.isEmpty) return;

    final sortedProgramExercises = [...programExercises]
      ..sort((a, b) => a.exerciseOrder.compareTo(b.exerciseOrder));

    // التحقق من وجود جميع التمارين قبل إنشاء الجلسة.
    for (final programExercise in sortedProgramExercises) {
      final exists = exercises.any(
        (item) => item.id == programExercise.exerciseId,
      );

      if (!exists) return;
    }

    final workoutExercises = <WorkoutExercise>[];

    for (final programExercise in sortedProgramExercises) {
      final exercise = exercises.firstWhere(
        (item) => item.id == programExercise.exerciseId,
      );

      final sets = programExercise.sets.map((programSet) {
        return WorkoutSet(
          setNumber: programSet.setNumber,
          weight: programSet.targetWeight,
          reps: programSet.targetReps,
        );
      }).toList();

      workoutExercises.add(WorkoutExercise(exercise: exercise, sets: sets));
    }

    _completedSession = null;
    _workoutEndTime = null;

    _session = WorkoutSession(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: WorkoutType.program,
      programName: programName,
      exercises: workoutExercises,
    );

    notifyListeners();
  }

  void _startWorkout({
    required List<Exercise> exercises,
    required WorkoutType type,
    String? programName,
  }) {
    if (exercises.isEmpty) return;

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

    if (!weight.isFinite || weight < 0) return;

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

    if (set.isCompleted ||
        set.reps <= 0 ||
        !set.weight.isFinite ||
        set.weight < 0) {
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
    if (_isFinishingWorkout) return false;

    if (!_isSessionComplete()) return false;

    _isFinishingWorkout = true;

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
    } finally {
      _isFinishingWorkout = false;
      notifyListeners();
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

  Future<WorkoutSessionDetails?> getWorkoutDetails(String sessionId) {
    return _workoutRepository.getWorkoutDetails(sessionId);
  }

  Future<WorkoutProgressStats> getProgressStats({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final history = await getWorkoutHistory();

    final filteredWorkouts = history.where((workout) {
      return !workout.startTime.isBefore(startDate) &&
          workout.startTime.isBefore(endDate);
    }).toList();

    final trainingDays = <String>{};
    final dailyActivity = <DateTime, WorkoutActivityPoint>{};

    Duration totalDuration = Duration.zero;
    double totalWeightLifted = 0;

    for (final workout in filteredWorkouts) {
      final date = DateTime(
        workout.startTime.year,
        workout.startTime.month,
        workout.startTime.day,
      );

      final dateKey = '${date.year}-${date.month}-${date.day}';

      trainingDays.add(dateKey);

      totalDuration += workout.duration;
      totalWeightLifted += workout.totalWeightLifted;

      final previous = dailyActivity[date];

      dailyActivity[date] = WorkoutActivityPoint(
        date: date,
        workoutCount: (previous?.workoutCount ?? 0) + 1,
        totalWeightLifted:
            (previous?.totalWeightLifted ?? 0) + workout.totalWeightLifted,
      );
    }

    final activityPoints = dailyActivity.values.toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return WorkoutProgressStats(
      workoutCount: filteredWorkouts.length,
      trainingDays: trainingDays.length,
      totalDuration: totalDuration,
      totalWeightLifted: totalWeightLifted,
      activityPoints: activityPoints,
    );
  }

  Future<List<WorkoutAchievement>> getWorkoutAchievements() async {
    final history = await getWorkoutHistory();

    final completedWorkouts = history
        .where((workout) => workout.completedSets > 0)
        .toList();

    final trainingDays = <String>{};

    for (final workout in completedWorkouts) {
      final date = workout.startTime;

      trainingDays.add('${date.year}-${date.month}-${date.day}');
    }

    return [
      WorkoutAchievement(
        id: 'first_workout',
        currentValue: completedWorkouts.length,
        targetValue: 1,
      ),
      WorkoutAchievement(
        id: 'five_workouts',
        currentValue: completedWorkouts.length,
        targetValue: 5,
      ),
      WorkoutAchievement(
        id: 'ten_workouts',
        currentValue: completedWorkouts.length,
        targetValue: 10,
      ),
      WorkoutAchievement(
        id: 'ten_training_days',
        currentValue: trainingDays.length,
        targetValue: 10,
      ),
      WorkoutAchievement(
        id: 'twenty_five_workouts',
        currentValue: completedWorkouts.length,
        targetValue: 25,
      ),
      WorkoutAchievement(
        id: 'fifty_workouts',
        currentValue: completedWorkouts.length,
        targetValue: 50,
      ),
    ];
  }

  Future<TrainingCycleProgress> getTrainingCycleProgress() async {
    final cycle = await _trainingCycleRepository.getOrCreateCycle();

    final completedDays = await _workoutRepository
        .getCompletedTrainingDaysSince(cycle.startDate);

    return TrainingCycleProgress(
      completedDays: completedDays.clamp(0, cycle.targetDays),
      targetDays: cycle.targetDays,
      startDate: cycle.startDate,
    );
  }
}
