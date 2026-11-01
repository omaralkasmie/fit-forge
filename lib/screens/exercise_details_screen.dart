import 'package:flutter/material.dart';
import '../models/exercise.dart';

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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          foregroundColor: Colors.white,
          title: const Text(
            'تفاصيل التمرين',
            style: TextStyle(fontWeight: FontWeight.bold),
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
                      return  Center(
                        child: Icon(
                          Icons.fitness_center,
                          color: ExerciseDetailsScreen.pinkColor,
                          size: 75,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                exercise.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              Text(
                exercise.muscleGroup,
                style: const TextStyle(
                  color: purpleColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),

              _DetailCard(
                title: 'وصف التمرين',
                child: Text(
                  exercise.description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.8,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              if (exercise.targetMuscles.isNotEmpty) ...[
                _DetailCard(
                  title: 'العضلات المستهدفة',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 10,
                    children: exercise.targetMuscles.map((muscle) {
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
                title: 'معلومات التمرين',
                child: Column(
                  children: [
                    _InfoRow(
                      label: 'المعدات',
                      value: exercise.equipment,
                      icon: Icons.fitness_center,
                    ),
                    _InfoRow(
                      label: 'مستوى الصعوبة',
                      value: exercise.difficulty,
                      icon: Icons.bar_chart,
                    ),
                    _InfoRow(
                      label: 'عدد المجموعات',
                      value: '${exercise.suggestedSets}',
                      icon: Icons.repeat,
                    ),
                    _InfoRow(
                      label: 'عدد التكرارات',
                      value: '${exercise.suggestedReps}',
                      icon: Icons.format_list_numbered,
                    ),
                  ],
                ),
              ),

              if (exercise.instructions.isNotEmpty) ...[
                const SizedBox(height: 16),
                _DetailCard(
                  title: 'طريقة أداء التمرين',
                  child: Column(
                    children: List.generate(
                      exercise.instructions.length,
                      (index) => _InstructionRow(
                        number: index + 1,
                        instruction: exercise.instructions[index],
                      ),
                    ),
                  ),
                ),
              ],

              if (exercise.commonMistakes.isNotEmpty) ...[
                const SizedBox(height: 16),
                _DetailCard(
                  title: 'أخطاء شائعة',
                  child: Column(
                    children: exercise.commonMistakes.map((mistake) {
                      return _MistakeRow(mistake: mistake);
                    }).toList(),
                  ),
                ),
              ],

              const SizedBox(height: 20),
            ],
          ),
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