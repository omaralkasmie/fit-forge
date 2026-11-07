import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../widgets/custom_bottom_navigation.dart';

import 'package:go_router/go_router.dart';

import '../routes/app_router.dart';

const Color progressBg = Color(0xFF080B1B);
const Color progressCard = Color(0xFF10142B);
const Color progressPurple = Color(0xFF7138FF);
const Color progressPink = Color(0xFFED168E);
const Color progressBlue = Color(0xFF168BFF);
const Color progressGreen = Color(0xFF20D6A1);
const Color progressOrange = Color(0xFFFF851B);

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

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
          _buildWorkoutHistoryButton(context, l10n),
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
          _buildStats(l10n),
          const SizedBox(height: 26),
          _buildWeightCard(l10n),
          const SizedBox(height: 26),
          _buildAchievements(l10n),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }

  Widget _buildWorkoutHistoryButton(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return InkWell(
      onTap: () {
        context.push(AppRouter.workoutHistory);
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: progressCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: progressPurple.withValues(alpha: 0.35)),
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
              child: const Icon(Icons.history, color: progressPurple, size: 26),
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

  Widget _buildStats(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: l10n.workoutsLabel,
            value: '24',
            subtitle: l10n.thisMonth,
            icon: Icons.fitness_center,
            color: progressPurple,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: l10n.trainingDaysLabel,
            value: '12',
            subtitle: l10n.thisMonth,
            icon: Icons.calendar_month,
            color: progressPink,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: l10n.hoursLabel,
            value: '18',
            subtitle: l10n.trainingHours,
            icon: Icons.timer_outlined,
            color: progressBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildWeightCard(AppLocalizations l10n) {
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
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.weightProgress,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(Icons.show_chart, color: progressPurple, size: 28),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.last7Weeks,
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '75.0',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  l10n.weightUnit,
                  style: const TextStyle(color: Colors.white60, fontSize: 14),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: progressGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  l10n.currentWeight,
                  style: const TextStyle(color: progressGreen, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _WeightBar(height: 52, label: '1'),
                _WeightBar(height: 64, label: '2'),
                _WeightBar(height: 58, label: '3'),
                _WeightBar(height: 78, label: '4'),
                _WeightBar(height: 88, label: '5'),
                _WeightBar(height: 98, label: '6'),
                _WeightBar(height: 112, label: '7'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              l10n.weekLabel,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.achievementsTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _AchievementCard(
          icon: Icons.local_fire_department,
          title: l10n.strongStart,
          description: l10n.completedTrainingDays,
          color: progressPink,
        ),
        const SizedBox(height: 12),
        _AchievementCard(
          icon: Icons.bolt,
          title: l10n.consistentEnergy,
          description: l10n.completedWorkouts,
          color: progressOrange,
        ),
      ],
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      decoration: BoxDecoration(
        color: progressCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white54, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _WeightBar extends StatelessWidget {
  final double height;
  final String label;

  const _WeightBar({required this.height, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 18,
          height: height,
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
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _AchievementCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: progressCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white60, fontSize: 13),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle, color: color, size: 24),
        ],
      ),
    );
  }
}
