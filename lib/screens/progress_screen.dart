import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/workout_progress_stats.dart';
import '../routes/app_router.dart';
import '../services/workout_manager.dart';
import '../services/workout_scope.dart';
import '../widgets/custom_bottom_navigation.dart';
import '../models/workout_achievement.dart';


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

  Future<List<WorkoutAchievement>>? _achievementsFuture;

  _ProgressPeriod _selectedPeriod = _ProgressPeriod.month;

  void _loadAchievements() {
    _achievementsFuture = _workoutManager!.getWorkoutAchievements();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_workoutManager == null) {
      _workoutManager = WorkoutScope.of(context);
      _loadStats();
      _loadAchievements();
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
      setState(() {
        _loadStats();
        _loadAchievements();
      });
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
                  const SizedBox(height: 24),
                  _buildAchievementsSection(l10n),
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

Widget _buildAchievementsSection(AppLocalizations l10n) {
  return FutureBuilder<List<WorkoutAchievement>>(
    future: _achievementsFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: CircularProgressIndicator(color: progressPurple),
          ),
        );
      }

      if (snapshot.hasError || !snapshot.hasData) {
        return const SizedBox.shrink();
      }

      final achievements = snapshot.data!;
      final unlockedCount =
          achievements.where((item) => item.isUnlocked).length;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.achievementsTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '$unlockedCount / ${achievements.length}',
                style: const TextStyle(
                  color: progressPurple,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: achievements.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.88,
            ),
            itemBuilder: (context, index) {
              final achievement = achievements[index];

              return _AchievementCard(
                achievement: achievement,
                title: _achievementTitle(achievement.id, l10n),
                description:
                    _achievementDescription(achievement.id, l10n),
                icon: _achievementIcon(achievement.id),
                l10n: l10n,
              );
            },
          ),
        ],
      );
    },
  );
}

String _achievementTitle(String id, AppLocalizations l10n) {
  switch (id) {
    case 'first_workout':
      return l10n.achievementFirstWorkout;
    case 'five_workouts':
      return l10n.achievementFiveWorkouts;
    case 'ten_workouts':
      return l10n.achievementTenWorkouts;
    case 'ten_training_days':
      return l10n.achievementTenDays;
    case 'twenty_five_workouts':
      return l10n.achievementTwentyFiveWorkouts;
    case 'fifty_workouts':
      return l10n.achievementFiftyWorkouts;
    default:
      return '';
  }
}

String _achievementDescription(String id, AppLocalizations l10n) {
  switch (id) {
    case 'first_workout':
      return l10n.achievementFirstWorkoutDesc;
    case 'five_workouts':
      return l10n.achievementFiveWorkoutsDesc;
    case 'ten_workouts':
      return l10n.achievementTenWorkoutsDesc;
    case 'ten_training_days':
      return l10n.achievementTenDaysDesc;
    case 'twenty_five_workouts':
      return l10n.achievementTwentyFiveWorkoutsDesc;
    case 'fifty_workouts':
      return l10n.achievementFiftyWorkoutsDesc;
    default:
      return '';
  }
}

IconData _achievementIcon(String id) {
  switch (id) {
    case 'first_workout':
      return Icons.flag_rounded;
    case 'five_workouts':
      return Icons.local_fire_department_rounded;
    case 'ten_workouts':
      return Icons.fitness_center_rounded;
    case 'ten_training_days':
      return Icons.calendar_month_rounded;
    case 'twenty_five_workouts':
      return Icons.military_tech_rounded;
    case 'fifty_workouts':
      return Icons.emoji_events_rounded;
    default:
      return Icons.star_rounded;
  }
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
class _AchievementCard extends StatefulWidget {
  final WorkoutAchievement achievement;
  final String title;
  final String description;
  final IconData icon;
  final AppLocalizations l10n;

  const _AchievementCard({
    required this.achievement,
    required this.title,
    required this.description,
    required this.icon,
    required this.l10n,
  });

  @override
  State<_AchievementCard> createState() => _AchievementCardState();
}

class _AchievementCardState extends State<_AchievementCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.75,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant _AchievementCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.achievement.isUnlocked &&
        widget.achievement.isUnlocked) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final achievement = widget.achievement;
    final unlocked = achievement.isUnlocked;
    final color = unlocked ? progressPurple : Colors.blueGrey;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: progressCard,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: color.withValues(
                    alpha: unlocked ? 0.55 : 0.2,
                  ),
                ),
                boxShadow: unlocked
                    ? [
                        BoxShadow(
                          color: progressPurple.withValues(
                            alpha: 0.22 * _controller.value,
                          ),
                          blurRadius: 18 * _controller.value,
                          spreadRadius: 1,
                        ),
                      ]
                    : [],
              ),
              child: child,
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  widget.icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: unlocked ? Colors.white : Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Text(
                  widget.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: achievement.progress,
                  minHeight: 6,
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              const SizedBox(height: 7),
              Text(
                unlocked
                    ? widget.l10n.achievementUnlocked
                    : '${achievement.currentValue} / ${achievement.targetValue} ${widget.l10n.achievementProgress}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: unlocked ? progressGreen : Colors.white54,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}