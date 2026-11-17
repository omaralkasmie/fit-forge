import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../routes/app_router.dart';
import '../services/workout_scope.dart';
import '../models/workout_session.dart';

const Color _bgColor = Color(0xFF0B0B16);
const Color _cardColor = Color(0xFF15182F);
const Color _purpleColor = Color(0xFF9B5CFF);
const Color _pinkColor = Color(0xFFE34DFF);
const Color _greenColor = Color(0xFF20C997);

class WorkoutSummaryScreen extends StatelessWidget {
  const WorkoutSummaryScreen({super.key});

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }

    return '${duration.inMinutes} min';
  }

  @override
  Widget build(BuildContext context) {
    final manager = WorkoutScope.of(context);
    final l10n = AppLocalizations.of(context)!;

    final session = manager.completedSession;
    final endTime = manager.workoutEndTime;

    if (session == null || endTime == null) {
      return Scaffold(
        backgroundColor: _bgColor,
        body: Center(
          child: Text(
            'No workout summary available',
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    final duration = endTime.difference(session.startTime);

    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              const SizedBox(height: 28),

              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [_purpleColor, _pinkColor],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _purpleColor.withValues(alpha: 0.35),
                      blurRadius: 30,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: Colors.white,
                  size: 52,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                l10n.workoutCompleted,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                l10n.workoutSummaryTitle,
                style: const TextStyle(color: Colors.white54, fontSize: 15),
              ),

              Container(
  width: double.infinity,
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: _cardColor,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: _purpleColor.withValues(alpha: 0.4),
    ),
  ),
  child: Row(
    children: [
      const Icon(
        Icons.fitness_center,
        color: _pinkColor,
        size: 26,
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              session.type == WorkoutType.program
                  ?l10n.programWorkoutLabel
                  : l10n.freeWorkoutLabel,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
            if (session.type == WorkoutType.program &&
                session.programName != null) ...[
              const SizedBox(height: 5),
              Text(
                session.programName!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    ],
  ),
),
const SizedBox(height: 20),

              const SizedBox(height: 35),

              _SummaryCard(
                icon: Icons.timer_rounded,
                title: l10n.workoutDuration,
                value: _formatDuration(duration),
                color: _purpleColor,
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      icon: Icons.fitness_center_rounded,
                      title: l10n.exercisesCompleted,
                      value: '${session.completedExercises}',
                      color: _pinkColor,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _SummaryCard(
                      icon: Icons.check_circle_rounded,
                      title: l10n.setsCompleted,
                      value: '${manager.completedSets}',
                      color: _greenColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _SummaryCard(
                icon: Icons.monitor_weight_rounded,
                title: l10n.totalWeightLifted,
                value:
                    '${manager.totalWeightLifted.toStringAsFixed(1)} ${l10n.kilogramsUnit}',
                color: _purpleColor,
              ),

              const SizedBox(height: 38),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [_purpleColor, _pinkColor],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: _purpleColor.withValues(alpha: 0.3),
                        blurRadius: 18,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.go(AppRouter.home);
                    },
                    icon: const Icon(Icons.home_rounded, color: Colors.white),
                    label: Text(
                      l10n.backToHome,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
          const SizedBox(height: 7),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
