import 'workout_exercise.dart';

enum WorkoutType {
  free,
  program,
}

class WorkoutSession {
  final String id;
  final WorkoutType type;
  final String? programName;
  final List<WorkoutExercise> exercises;
  final DateTime startTime;

  WorkoutSession({
    required this.id,
    required this.type,
    this.programName,
    required List<WorkoutExercise> exercises,
    DateTime? startTime,
  })  : exercises = List.unmodifiable(exercises),
        startTime = startTime ?? DateTime.now();

  bool get isCompleted =>
      exercises.isNotEmpty &&
      exercises.every((exercise) => exercise.isCompleted);

  int get completedExercises =>
      exercises.where((exercise) => exercise.isCompleted).length;
}