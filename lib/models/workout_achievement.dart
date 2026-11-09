class WorkoutAchievement {
  final String id;
  final int currentValue;
  final int targetValue;
  final DateTime? unlockedAt;

  const WorkoutAchievement({
    required this.id,
    required this.currentValue,
    required this.targetValue,
    this.unlockedAt,
  });

  bool get isUnlocked => currentValue >= targetValue;

  double get progress {
    if (targetValue <= 0) return 1;

    return (currentValue / targetValue).clamp(0.0, 1.0);
  }
}