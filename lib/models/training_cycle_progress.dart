class TrainingCycleProgress {
  final int completedDays;
  final int targetDays;
  final DateTime startDate;

  const TrainingCycleProgress({
    required this.completedDays,
    required this.targetDays,
    required this.startDate,
  });

  double get progress {
    if (targetDays <= 0) return 0;

    return (completedDays / targetDays).clamp(0.0, 1.0);
  }

  bool get isCompleted => completedDays >= targetDays;

  int get remainingDays =>
      (targetDays - completedDays).clamp(0, targetDays);
}