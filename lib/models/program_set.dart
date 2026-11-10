class ProgramSet {
  final int setNumber;
  final double targetWeight;
  final int targetReps;

  const ProgramSet({
    required this.setNumber,
    this.targetWeight = 0,
    this.targetReps = 10,
  });
}