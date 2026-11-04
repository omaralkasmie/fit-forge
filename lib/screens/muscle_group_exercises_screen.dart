import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/exercise.dart';
import '../l10n/app_localizations.dart';
import '../routes/app_router.dart';
import '../widgets/custom_bottom_navigation.dart';

class MuscleGroupExercisesScreen extends StatelessWidget {
  final String title;
  final String bannerTitle;
  final String bannerSubtitle;
  final List<Exercise> exercises;

  const MuscleGroupExercisesScreen({
    super.key,
    required this.title,
    required this.bannerTitle,
    required this.bannerSubtitle,
    required this.exercises,
  });

  static const Color bgColor = Color(0xFF0B0B16);
  static const Color cardColor = Color(0xFF15182F);
  static const Color purpleColor = Color(0xFF9B5CFF);
  static const Color pinkColor = Color(0xFFE34DFF);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        foregroundColor: Colors.white,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                colors: [purpleColor, Color(0xFF4932C9)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.fitness_center, color: Colors.white, size: 40),
                const SizedBox(height: 16),
                Text(
                  bannerTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  bannerSubtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text(
            l10n.exerciseListTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(exercises.length, (index) {
            final exercise = exercises[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ExerciseTile(
                number: (index + 1).toString().padLeft(2, '0'),
                title: exercise.nameFor(isArabic),
                muscleGroup: exercise.muscleGroupFor(isArabic),
                equipment: exercise.equipmentFor(isArabic),
                difficulty: exercise.difficultyFor(isArabic),
                subtitle: isArabic
                    ? '${exercise.suggestedSets} مجموعات × '
                          '${exercise.suggestedReps} تكرارات'
                    : '${exercise.suggestedSets} sets × '
                          '${exercise.suggestedReps} reps',
                onTap: () {
                  context.push(AppRouter.exerciseDetails, extra: exercise);
                },
              ),
            );
          }),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;
  final String muscleGroup;
  final String equipment;
  final String difficulty;
  final VoidCallback onTap;

  const _ExerciseTile({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.muscleGroup,
    required this.equipment,
    required this.difficulty,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: MuscleGroupExercisesScreen.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: MuscleGroupExercisesScreen.purpleColor.withValues(
              alpha: 0.25,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: MuscleGroupExercisesScreen.purpleColor.withValues(
                      alpha: 0.16,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.fitness_center,
                    color: MuscleGroupExercisesScreen.pinkColor,
                    size: 27,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        muscleGroup,
                        style: const TextStyle(
                          color: MuscleGroupExercisesScreen.purpleColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  number,
                  style: const TextStyle(
                    color: MuscleGroupExercisesScreen.purpleColor,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _ExerciseInfoChip(icon: Icons.fitness_center, label: equipment),
                const SizedBox(width: 8),
                _ExerciseInfoChip(icon: Icons.bar_chart, label: difficulty),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.repeat,
                    color: MuscleGroupExercisesScreen.pinkColor,
                    size: 19,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExerciseInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ExerciseInfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: MuscleGroupExercisesScreen.purpleColor.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: MuscleGroupExercisesScreen.purpleColor, size: 16),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
