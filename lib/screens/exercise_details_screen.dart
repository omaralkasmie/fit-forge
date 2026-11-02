import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../l10n/app_localizations.dart';

class ExerciseDetailsScreen extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailsScreen({
    super.key,
    required this.exercise,
  });

  static const Color bgColor = Color(0xFF0B0B16);
  static const Color cardColor = Color(0xFF15182F);
  static const Color purpleColor = Color(0xFF9B5CFF);
  static const Color pinkColor = Color(0xFFE34DFF);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic =
        Localizations.localeOf(context).languageCode == 'ar';

    final targetMuscles = exercise.targetMusclesFor(isArabic);
    final instructions = exercise.instructionsFor(isArabic);
    final commonMistakes = exercise.commonMistakesFor(isArabic);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        foregroundColor: Colors.white,
        title: Text(
          l10n.exerciseDetailsTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 210,
              width: double.infinity,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: purpleColor.withValues(alpha: 0.3),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.asset(
                  exercise.image,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.fitness_center,
                        color: pinkColor,
                        size: 75,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              exercise.nameFor(isArabic),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            Text(
              exercise.muscleGroupFor(isArabic),
              style: const TextStyle(
                color: purpleColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),

            _DetailCard(
              title: l10n.exerciseDescriptionTitle,
              child: Text(
                exercise.descriptionFor(isArabic),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.8,
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (targetMuscles.isNotEmpty) ...[
              _DetailCard(
                title: l10n.targetMusclesTitle,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: targetMuscles.map((muscle) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: purpleColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: purpleColor.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        muscle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
            ],

            _DetailCard(
              title: l10n.exerciseInformationTitle,
              child: Column(
                children: [
                  _InfoRow(
                    label: l10n.equipmentLabel,
                    value: exercise.equipmentFor(isArabic),
                    icon: Icons.fitness_center,
                  ),
                  _InfoRow(
                    label: l10n.difficultyLabel,
                    value: exercise.difficultyFor(isArabic),
                    icon: Icons.bar_chart,
                  ),
                  _InfoRow(
                    label: l10n.setsCountLabel,
                    value: '${exercise.suggestedSets}',
                    icon: Icons.repeat,
                  ),
                  _InfoRow(
                    label: l10n.repsCountLabel,
                    value: '${exercise.suggestedReps}',
                    icon: Icons.format_list_numbered,
                  ),
                ],
              ),
            ),

            if (instructions.isNotEmpty) ...[
              const SizedBox(height: 16),
              _DetailCard(
                title: l10n.exerciseInstructionsTitle,
                child: Column(
                  children: List.generate(
                    instructions.length,
                    (index) => _InstructionRow(
                      number: index + 1,
                      instruction: instructions[index],
                    ),
                  ),
                ),
              ),
            ],

            if (commonMistakes.isNotEmpty) ...[
              const SizedBox(height: 16),
              _DetailCard(
                title: l10n.commonMistakesTitle,
                child: Column(
                  children: commonMistakes.map((mistake) {
                    return _MistakeRow(mistake: mistake);
                  }).toList(),
                ),
              ),
            ],

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _DetailCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ExerciseDetailsScreen.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: ExerciseDetailsScreen.purpleColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(
            icon,
            color: ExerciseDetailsScreen.purpleColor,
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
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _InstructionRow extends StatelessWidget {
  final int number;
  final String instruction;

  const _InstructionRow({
    required this.number,
    required this.instruction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ExerciseDetailsScreen.purpleColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$number',
              style: const TextStyle(
                color: ExerciseDetailsScreen.pinkColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              instruction,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MistakeRow extends StatelessWidget {
  final String mistake;

  const _MistakeRow({
    required this.mistake,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: ExerciseDetailsScreen.pinkColor,
            size: 21,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              mistake,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}