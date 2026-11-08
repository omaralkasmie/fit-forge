class WorkoutProgressStats {
  final int workoutCount;
  final int trainingDays;
  final Duration totalDuration;
  final double totalWeightLifted;
  final List<WorkoutActivityPoint> activityPoints;

  const WorkoutProgressStats({
    required this.workoutCount,
    required this.trainingDays,
    required this.totalDuration,
    required this.totalWeightLifted,
    required this.activityPoints,
  });

  double get totalHours =>
      totalDuration.inMinutes / 60.0;
}

class WorkoutActivityPoint {
  final DateTime date;
  final int workoutCount;
  final double totalWeightLifted;

  const WorkoutActivityPoint({
    required this.date,
    required this.workoutCount,
    required this.totalWeightLifted,
  });
}