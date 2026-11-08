import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/workout_progress_stats.dart';
import '../routes/app_router.dart';
import '../services/workout_manager.dart';
import '../services/workout_scope.dart';
import '../widgets/custom_bottom_navigation.dart';

const Color progressBg = Color(0xFF080B1B);
const Color progressCard = Color(0xFF10142B);
const Color progressPurple = Color(0xFF7138FF);
const Color progressPink = Color(0xFFED168E);
const Color progressBlue = Color(0xFF168BFF);
const Color progressGreen = Color(0xFF20D6A1);
const Color progressOrange = Color(0xFFFF851B);

enum _ProgressPeriod { week, month, year }

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  WorkoutManager? _workoutManager;
  Future<WorkoutProgressStats>? _statsFuture;

  _ProgressPeriod _selectedPeriod = _ProgressPeriod.month;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_workoutManager == null) {
      _workoutManager = WorkoutScope.of(context);
      _loadStats();
    }
  }

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime get _startDate {
    switch (_selectedPeriod) {
      case _ProgressPeriod.week:
        return _today.subtract(const Duration(days: 6));

      case _ProgressPeriod.month:
        return DateTime(_today.year, _today.month, 1);

      case _ProgressPeriod.year:
        return DateTime(_today.year, 1, 1);
    }
  }

  DateTime get _endDate {
    return _today.add(const Duration(days: 1));
  }

  void _loadStats() {
    _statsFuture = _workoutManager!.getProgressStats(
      startDate: _startDate,
      endDate: _endDate,
    );
  }

  void _changePeriod(_ProgressPeriod period) {
    if (_selectedPeriod == period) return;

    setState(() {
      _selectedPeriod = period;
      _loadStats();
    });
  }

  String _periodLabel(AppLocalizations l10n) {
    switch (_selectedPeriod) {
      case _ProgressPeriod.week:
        return l10n.progressWeek;
      case _ProgressPeriod.month:
        return l10n.progressMonth;
      case _ProgressPeriod.year:
        return l10n.progressYear;
    }
  }

  Future<void> _openWorkoutHistory() async {
    await context.push(AppRouter.workoutHistory);

    if (mounted) {
      setState(_loadStats);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: progressBg,
      appBar: AppBar(
        backgroundColor: progressBg,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          l10n.progressTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildHeader(l10n),
          const SizedBox(height: 16),
          _buildWorkoutHistoryButton(l10n),
          const SizedBox(height: 24),
          Text(
            l10n.activitySummary,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildPeriodSelector(l10n),
          const SizedBox(height: 18),
          FutureBuilder<WorkoutProgressStats>(
            future: _statsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 60),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: progressPurple,
                    ),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      snapshot.error.toString(),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                );
              }

              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }

              final stats = snapshot.data!;

              return Column(
                children: [
                  _buildStats(stats, l10n),
                  const SizedBox(height: 22),
                  _buildActivityCard(stats, l10n),
                ],
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
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
          const Icon(Icons.insights, color: Colors.white, size: 34),
          const SizedBox(height: 14),
          Text(
            l10n.everyWorkout,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.progressSubtitle,
            style: const TextStyle(
              color: Color(0xFFD3D4F4),
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutHistoryButton(AppLocalizations l10n) {
    return InkWell(
      onTap: _openWorkoutHistory,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: progressCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: progressPurple.withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: progressPurple.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.history,
                color: progressPurple,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                l10n.workoutHistoryTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 17,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: _PeriodButton(
            label: l10n.progressWeek,
            selected: _selectedPeriod == _ProgressPeriod.week,
            onTap: () => _changePeriod(_ProgressPeriod.week),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _PeriodButton(
            label: l10n.progressMonth,
            selected: _selectedPeriod == _ProgressPeriod.month,
            onTap: () => _changePeriod(_ProgressPeriod.month),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _PeriodButton(
            label: l10n.progressYear,
            selected: _selectedPeriod == _ProgressPeriod.year,
            onTap: () => _changePeriod(_ProgressPeriod.year),
          ),
        ),
      ],
    );
  }

  Widget _buildStats(
    WorkoutProgressStats stats,
    AppLocalizations l10n,
  ) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: l10n.workoutsLabel,
            value: '${stats.workoutCount}',
            subtitle: _periodLabel(l10n),
            icon: Icons.fitness_center,
            color: progressPurple,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            title: l10n.trainingDaysLabel,
            value: '${stats.trainingDays}',
            subtitle: _periodLabel(l10n),
            icon: Icons.calendar_month,
            color: progressPink,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            title: l10n.hoursLabel,
            value: stats.totalHours.toStringAsFixed(1),
            subtitle: l10n.trainingHours,
            icon: Icons.timer_outlined,
            color: progressBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityCard(
    WorkoutProgressStats stats,
    AppLocalizations l10n,
  ) {
    final bars = _createActivityBars(stats, l10n);

    final hasActivity = bars.any((bar) => bar.value > 0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: progressCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.progressActivityTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.progressActivitySubtitle,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),

          // Total weight lifted
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: progressPurple.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.fitness_center,
                  color: progressPurple,
                  size: 26,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.progressTotalWeight,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ),
                Text(
                  '${stats.totalWeightLifted.toStringAsFixed(1)} ${l10n.weightUnit}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          if (!hasActivity)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.insert_chart_outlined,
                      color: Colors.white38,
                      size: 42,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.progressNoActivity,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SizedBox(
              height: 150,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: bars.map((bar) {
                  return _ActivityBar(
                    value: bar.value,
                    maxValue: bars
                        .map((item) => item.value)
                        .reduce((a, b) => a > b ? a : b),
                    label: bar.label,
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  List<_ActivityBarData> _createActivityBars(
    WorkoutProgressStats stats,
    AppLocalizations l10n,
  ) {
    final points = stats.activityPoints;
    final locale = l10n.localeName;

    if (_selectedPeriod == _ProgressPeriod.week) {
      return List.generate(7, (index) {
        final date = _startDate.add(Duration(days: index));

        final matchingPoints = points.where(
          (point) =>
              point.date.year == date.year &&
              point.date.month == date.month &&
              point.date.day == date.day,
        );

        final count = matchingPoints.fold<int>(
          0,
          (sum, point) => sum + point.workoutCount,
        );

        return _ActivityBarData(
          value: count,
          label: DateFormat.E(locale).format(date),
        );
      });
    }

    if (_selectedPeriod == _ProgressPeriod.month) {
      return List.generate(5, (index) {
        final startDay = (index * 7) + 1;
        final endDay = startDay + 6;

        final count = points
            .where((point) {
              return point.date.day >= startDay &&
                  point.date.day <= endDay;
            })
            .fold<int>(
              0,
              (sum, point) => sum + point.workoutCount,
            );

        return _ActivityBarData(
          value: count,
          label: '$startDay-${endDay > DateTime.now().day && index == 4 ? DateTime.now().day : endDay}',
        );
      });
    }

    return List.generate(12, (index) {
      final month = index + 1;

      final count = points
          .where((point) => point.date.month == month)
          .fold<int>(
            0,
            (sum, point) => sum + point.workoutCount,
          );

      return _ActivityBarData(
        value: count,
        label: DateFormat.MMM(locale).format(
          DateTime(_today.year, month),
        ),
      );
    });
  }
}

class _ActivityBarData {
  final int value;
  final String label;

  const _ActivityBarData({
    required this.value,
    required this.label,
  });
}

class _PeriodButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PeriodButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: selected ? progressPurple : progressCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? progressPurple : Colors.white10,
          ),
        ),
        child: Center(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: selected ? Colors.white : Colors.white60,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 14),
      decoration: BoxDecoration(
        color: progressCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityBar extends StatelessWidget {
  final int value;
  final int maxValue;
  final String label;

  const _ActivityBar({
    required this.value,
    required this.maxValue,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final barHeight = value == 0
        ? 4.0
        : 18.0 + (80.0 * value / maxValue);

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '$value',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            width: 18,
            height: barHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(
                colors: [progressPurple, Color(0xFFB04AFF)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}