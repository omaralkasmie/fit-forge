class WorkoutHistoryItem {
  final String id;
  final String type;
  final String? programName;
  final DateTime startTime;
  final DateTime endTime;
  final int exerciseCount;
  final int completedSets;
  final double totalWeightLifted;

  const WorkoutHistoryItem({
    required this.id,
    required this.type,
    this.programName,
    required this.startTime,
    required this.endTime,
    required this.exerciseCount,
    required this.completedSets,
    required this.totalWeightLifted,
  });

  Duration get duration => endTime.difference(startTime);
}
