import 'package:flutter/material.dart';

import '../models/training_program.dart';
import '../data/workouts/exercise_library.dart';
import '../models/exercise.dart';
import '../models/program_exercise.dart';

class ProgramDetailsScreen extends StatefulWidget {
  final TrainingProgram program;

  const ProgramDetailsScreen({
    super.key,
    required this.program,
  });

  @override
  State<ProgramDetailsScreen> createState() =>
      _ProgramDetailsScreenState();
}

class _ProgramDetailsScreenState
    extends State<ProgramDetailsScreen> {
  bool _isLoading = true;

  List<Exercise> _allExercises = [];

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  // تحميل مكتبة التمارين
  Future<void> _loadExercises() async {
    try {
      final exercises = await loadAllExercises();

      if (!mounted) return;

      setState(() {
        _allExercises = exercises;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      debugPrint('Error loading exercises: $e');
    }
  }

  // البحث عن التمرين باستخدام ID
  Exercise? _getExercise(String exerciseId) {
    for (final exercise in _allExercises) {
      if (exercise.id == exerciseId) {
        return exercise;
      }
    }

    return null;
  }

  // ترتيب تمارين البرنامج
  List<ProgramExercise> get _programExercises {
    final exercises = [...widget.program.exercises];

    exercises.sort(
      (a, b) => a.exerciseOrder.compareTo(b.exerciseOrder),
    );

    return exercises;
  }

  // معلومات البرنامج
  Widget _buildProgramHeader() {
    final isArabic =
        Localizations.localeOf(context).languageCode == 'ar';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF15182F),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF7138FF).withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.program.nameFor(isArabic),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.program.descriptionFor(isArabic),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(
                Icons.calendar_month,
                color: Color(0xFF9B5CFF),
              ),
              const SizedBox(width: 8),
              Text(
                '${widget.program.durationWeeks} ${isArabic ? 'أسابيع' : 'weeks'}',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(width: 20),
              const Icon(
                Icons.signal_cellular_alt,
                color: Color(0xFF9B5CFF),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.program.levelFor(isArabic),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // بطاقة التمرين
  Widget _buildExerciseCard(
    Exercise exercise,
    ProgramExercise programExercise,
  ) {
    final isArabic =
        Localizations.localeOf(context).languageCode == 'ar';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF15182F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  exercise.image,
                  width: 85,
                  height: 85,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 85,
                      height: 85,
                      color: const Color(0xFF252943),
                      child: const Icon(
                        Icons.fitness_center,
                        color: Color(0xFF9B5CFF),
                        size: 32,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.nameFor(isArabic),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      exercise.muscleGroupFor(isArabic),
                      style: const TextStyle(
                        color: Color(0xFF9B5CFF),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white12),
          const SizedBox(height: 8),
          Text(
            isArabic ? 'تفاصيل المجموعات' : 'Set Details',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          ...programExercise.sets.map((set) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${isArabic ? 'المجموعة' : 'Set'} ${set.setNumber}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    '${set.targetReps} ${isArabic ? 'تكرار' : 'reps'}',
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${set.targetWeight} ${isArabic ? 'كغم' : 'kg'}',
                    style: const TextStyle(
                      color: Color(0xFF9B5CFF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080B1B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF080B1B),
        foregroundColor: Colors.white,
        title: const Text('تفاصيل البرنامج'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildProgramHeader(),
                const SizedBox(height: 24),
                Text(
                  Localizations.localeOf(context).languageCode == 'ar'
                      ? 'تمارين البرنامج'
                      : 'Program Exercises',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ..._programExercises.map((programExercise) {
                  final exercise = _getExercise(
                    programExercise.exerciseId,
                  );

                  if (exercise == null) {
                    return const SizedBox.shrink();
                  }

                  return _buildExerciseCard(
                    exercise,
                    programExercise,
                  );
                }),
              ],
            ),
    );
  }
}