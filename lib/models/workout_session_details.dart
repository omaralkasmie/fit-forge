class WorkoutSessionDetails {
  final String id;
  final String type;
  final String? programName;
  final DateTime startTime;
  final DateTime endTime;
  final List<WorkoutExerciseDetails> exercises;

  const WorkoutSessionDetails({
    required this.id,
    required this.type,
    this.programName,
    required this.startTime,
    required this.endTime,
    required this.exercises,
  });

  Duration get duration => endTime.difference(startTime);

  int get completedSets => exercises.fold(
        0,
        (total, exercise) => total + exercise.completedSets,
      );

  double get totalWeightLifted => exercises.fold(
        0,
        (total, exercise) => total + exercise.totalWeightLifted,
      );
}

class WorkoutExerciseDetails {
  final String id;
  final String exerciseId;
  final String exerciseName;
  final String? exerciseNameEn;
  final String muscleGroup;
  final String? muscleGroupEn;
  final int exerciseOrder;
  final List<WorkoutSetDetails> sets;

  const WorkoutExerciseDetails({
    required this.id,
    required this.exerciseId,
    required this.exerciseName,
    this.exerciseNameEn,
    required this.muscleGroup,
    this.muscleGroupEn,
    required this.exerciseOrder,
    required this.sets,
  });

  int get completedSets =>
      sets.where((set) => set.isCompleted).length;

  double get totalWeightLifted => sets
      .where((set) => set.isCompleted)
      .fold(0, (total, set) => total + set.weight * set.reps);
}

class WorkoutSetDetails {
  final int setNumber;
  final double weight;
  final int reps;
  final bool isCompleted;

  const WorkoutSetDetails({
    required this.setNumber,
    required this.weight,
    required this.reps,
    required this.isCompleted,
  });
}