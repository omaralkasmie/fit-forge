import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/workout_session_details.dart';
import '../services/workout_scope.dart';

const Color _backgroundColor = Color(0xFF0B0B16);
const Color _cardColor = Color(0xFF15182F);
const Color _purpleColor = Color(0xFF8B5CF6);
const Color _greenColor = Color(0xFF22C55E);

class WorkoutDetailsScreen extends StatefulWidget {
  final String sessionId;

  const WorkoutDetailsScreen({
    super.key,
    required this.sessionId,
  });

  @override
  State<WorkoutDetailsScreen> createState() =>
      _WorkoutDetailsScreenState();
}

class _WorkoutDetailsScreenState extends State<WorkoutDetailsScreen> {
  late Future<WorkoutSessionDetails?> _detailsFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadDetails();
  }

  void _loadDetails() {
    _detailsFuture = WorkoutScope.of(context)
        .getWorkoutDetails(widget.sessionId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(l10n.workoutDetailsTitle),
      ),
      body: FutureBuilder<WorkoutSessionDetails?>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: _purpleColor,
              ),
            );
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Text(
                l10n.workoutDetailsError,
                style: const TextStyle(color: Colors.white70),
              ),
            );
          }

          final workout = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSummaryCard(workout, l10n),
              const SizedBox(height: 24),
              Text(
                l10n.workoutExercisesTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...workout.exercises.map(
                (exercise) => _buildExerciseCard(
                  exercise,
                  isArabic,
                  l10n,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(
    WorkoutSessionDetails workout,
    AppLocalizations l10n,
  ) {
    final duration = workout.duration;
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF29204F),
            Color(0xFF17182F),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _purpleColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          _summaryRow(
            Icons.calendar_today,
            l10n.workoutDetailsDate,
            '${workout.startTime.year}/'
                '${workout.startTime.month.toString().padLeft(2, '0')}/'
                '${workout.startTime.day.toString().padLeft(2, '0')}',
          ),
          const SizedBox(height: 16),
          _summaryRow(
            Icons.access_time,
            l10n.workoutDetailsDuration,
            hours > 0
                ? '${hours}h ${minutes}m'
                : '${minutes}m ${seconds}s',
          ),
          const SizedBox(height: 16),
          _summaryRow(
            Icons.fitness_center,
            l10n.workoutDetailsExercises,
            '${workout.exercises.length}',
          ),
          const SizedBox(height: 16),
          _summaryRow(
            Icons.check_circle_outline,
            l10n.workoutDetailsCompletedSets,
            '${workout.completedSets}',
          ),
          const Divider(
            color: Colors.white12,
            height: 28,
          ),
          _summaryRow(
            Icons.monitor_weight_outlined,
            l10n.workoutDetailsTotalWeight,
            '${workout.totalWeightLifted.toStringAsFixed(1)} kg',
            valueColor: _greenColor,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    IconData icon,
    String label,
    String value, {
    Color valueColor = Colors.white,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: _purpleColor,
          size: 20,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseCard(
    WorkoutExerciseDetails exercise,
    bool isArabic,
    AppLocalizations l10n,
  ) {
    final exerciseName = isArabic
        ? exercise.exerciseName
        : exercise.exerciseNameEn ?? exercise.exerciseName;

    final muscleGroup = isArabic
        ? exercise.muscleGroup
        : exercise.muscleGroupEn ?? exercise.muscleGroup;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exerciseName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            muscleGroup,
            style: const TextStyle(
              color: _purpleColor,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.workoutDetailsSet,
                  style: const TextStyle(color: Colors.white54),
                ),
              ),
              Expanded(
                child: Text(
                  l10n.workoutDetailsWeight,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white54),
                ),
              ),
              Expanded(
                child: Text(
                  l10n.workoutDetailsReps,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white54),
                ),
              ),
              const SizedBox(width: 24),
            ],
          ),
          const SizedBox(height: 10),
          ...exercise.sets.map(
            (set) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${set.setNumber}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${set.weight.toStringAsFixed(1)} kg',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${set.reps}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Icon(
                    set.isCompleted
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: set.isCompleted
                        ? _greenColor
                        : Colors.white30,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}