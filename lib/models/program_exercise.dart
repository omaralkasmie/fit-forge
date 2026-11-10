import 'program_set.dart';

class ProgramExercise {
  final String exerciseId;
  final int exerciseOrder;
  final List<ProgramSet> sets;

  const ProgramExercise({
    required this.exerciseId,
    required this.exerciseOrder,
    required this.sets,
  });
}