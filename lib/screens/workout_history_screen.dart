import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/workout_history_item.dart';
import '../services/workout_scope.dart';

const Color _backgroundColor = Color(0xFF0B0B16);
const Color _cardColor = Color(0xFF15182F);
const Color _purpleColor = Color(0xFF7138FF);
const Color _greenColor = Color(0xFF20D6A1);

class WorkoutHistoryScreen extends StatefulWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  State<WorkoutHistoryScreen> createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  late Future<List<WorkoutHistoryItem>> _historyFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadHistory();
  }

  void _loadHistory() {
    final manager = WorkoutScope.of(context);
    _historyFuture = manager.getWorkoutHistory();
  }

  Future<void> _refreshHistory() async {
    setState(_loadHistory);
    await _historyFuture;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          l10n.workoutHistoryTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<WorkoutHistoryItem>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: _purpleColor),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Something went wrong.',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final history = snapshot.data ?? [];

          if (history.isEmpty) {
            return _buildEmptyState(l10n);
          }

          return RefreshIndicator(
            color: _purpleColor,
            backgroundColor: _cardColor,
            onRefresh: _refreshHistory,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildSummaryCard(history, l10n),
                const SizedBox(height: 24),
                ...history.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _buildWorkoutCard(item, l10n),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(
    List<WorkoutHistoryItem> history,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF5627DF), Color(0xFF11143A)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.fitness_center, color: Colors.white, size: 32),
          const SizedBox(height: 16),
          Text(
            l10n.totalWorkouts,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            '${history.length}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(WorkoutHistoryItem item, AppLocalizations l10n) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final date = DateFormat(
      'dd MMM yyyy',
      isArabic ? 'ar' : 'en',
    ).format(item.startTime);

    final time = DateFormat(
      'hh:mm a',
      isArabic ? 'ar' : 'en',
    ).format(item.startTime);

    final duration = item.duration;
    final durationText =
        '${duration.inMinutes} min ${duration.inSeconds.remainder(60)} sec';

    final workoutType = item.type == 'free'
        ? l10n.freeWorkout
        : l10n.programWorkout;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: _purpleColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.fitness_center, color: _purpleColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workoutType,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$date • $time',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.check_circle, color: _greenColor, size: 24),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white12),
          const SizedBox(height: 14),
          Row(
            children: [
              _InfoItem(
                icon: Icons.list_alt,
                label: l10n.exercisesLabel,
                value: '${item.exerciseCount}',
              ),
              _InfoItem(
                icon: Icons.repeat,
                label: l10n.workoutHistorySetsLabel,
                value: '${item.completedSets}',
              ),
              _InfoItem(
                icon: Icons.timer_outlined,
                label: l10n.durationLabel,
                value: durationText,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.fitness_center, color: _purpleColor, size: 18),
              const SizedBox(width: 8),
              Text(
                l10n.totalWeightLifted,
                style: const TextStyle(color: Colors.white60, fontSize: 13),
              ),
              const Spacer(),
              Text(
                '${item.totalWeightLifted.toStringAsFixed(1)} kg',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 76,
              color: _purpleColor.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.noWorkoutHistory,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.startFirstWorkout,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _purpleColor, size: 19),
          const SizedBox(height: 7),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
