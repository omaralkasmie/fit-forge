import 'exercise.dart';
import 'workout_set.dart';

class WorkoutExercise {
  final Exercise exercise;
  final List<WorkoutSet> sets;

  WorkoutExercise({required this.exercise, List<WorkoutSet>? sets})
    : sets =
          sets ??
          List.generate(
            exercise.suggestedSets,
            (index) => WorkoutSet(setNumber: index + 1, reps: 0),
          );

  bool get isCompleted =>
      sets.isNotEmpty && sets.every((set) => set.isCompleted);

  int get completedSets => sets.where((set) => set.isCompleted).length;
}
