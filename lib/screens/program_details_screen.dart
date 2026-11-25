import 'package:flutter/material.dart';

import '../models/training_program.dart';
import '../data/workouts/exercise_library.dart';
import '../models/exercise.dart';
import '../models/program_exercise.dart';
import 'package:go_router/go_router.dart';
import '../routes/app_router.dart';
import '../services/workout_scope.dart';

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

  List<ProgramExercise> get _missingExercises {
  return _programExercises.where((programExercise) {
    return _getExercise(programExercise.exerciseId) == null;
  }).toList();
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

  const cardColor = Color(0xFF10142B);

  final metadata = {
    'muscle_building': (
      icon: Icons.fitness_center,
      color: const Color(0xFF7138FF),
      image: 'assets/images/muscle_building.jpg',
    ),
    'fat_burning': (
      icon: Icons.local_fire_department,
      color: const Color(0xFFED168E),
      image: 'assets/images/fat_burning.jpg',
    ),
    'general_fitness': (
      icon: Icons.directions_run,
      color: const Color(0xFF168BFF),
      image: 'assets/images/general_fitness.jpg',
    ),
    'advanced_program': (
      icon: Icons.star,
      color: const Color(0xFFFF851B),
      image: 'assets/images/advanced_program.png',
    ),
  };

  final style =
      metadata[widget.program.sourceProgramId ?? widget.program.id] ??
      (
        icon: Icons.fitness_center,
        color: const Color(0xFF7138FF),
        image: '',
      );

  return Container(
    height: 202,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(
        color: style.color.withValues(alpha: 0.8),
      ),
      gradient: LinearGradient(
        colors: [
          style.color.withValues(alpha: 0.12),
          cardColor,
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
    ),
    child: Row(
      textDirection: TextDirection.ltr,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Opacity(
            opacity: 0.75,
            child: Image.asset(
              style.image,
              width: 166,
              height: 175,
              fit: BoxFit.cover,
              alignment: const Alignment(0, -0.7),
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 70,
                  color: style.color.withValues(alpha: 0.22),
                  child: Icon(
                    style.icon,
                    size: 38,
                    color: style.color,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Directionality(
            textDirection:
                isArabic ? TextDirection.rtl : TextDirection.ltr,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.program.nameFor(isArabic),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    widget.program.descriptionFor(isArabic),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFBFC5E8),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: style.color,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isArabic
                          ? '${widget.program.durationWeeks} أسابيع'
                          : '${widget.program.durationWeeks} weeks',
                      style: const TextStyle(
                        color: Color(0xFFBFC5E8),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.signal_cellular_alt,
                      color: style.color,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.program.levelFor(isArabic),
                        style: const TextStyle(
                          color: Color(0xFFBFC5E8),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
  void _startProgramWorkout() {
  final programExercises = _programExercises;

  final exercises = <Exercise>[];

  for (final programExercise in programExercises) {
    final exercise = _getExercise(programExercise.exerciseId);

    if (exercise != null) {
      exercises.add(exercise);
    }
  }

  if (exercises.isEmpty) return;

  WorkoutScope.of(context).startProgramWorkoutWithSets(
    programName: widget.program.nameFor(
      Localizations.localeOf(context).languageCode == 'ar',
    ),
    exercises: exercises,
    programExercises: programExercises,
  );

  context.push(AppRouter.activeWorkout);
}

 @override
Widget build(BuildContext context) {
  final isArabic =
      Localizations.localeOf(context).languageCode == 'ar';

  return Scaffold(
    backgroundColor: const Color(0xFF080B1B),
    appBar: AppBar(
      backgroundColor: const Color(0xFF080B1B),
      foregroundColor: Colors.white,
      title: Text(isArabic ? 'تفاصيل البرنامج' : 'Program Details'),
    ),
    body: _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildProgramHeader(),
              const SizedBox(height: 16),

              if (_missingExercises.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.redAccent.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          isArabic
                              ? 'هذا البرنامج يحتوي على ${_missingExercises.length} تمرين غير متاح في مكتبة التمارين. لا يمكن بدء البرنامج حتى يتم إصلاحه.'
                              : 'This program contains ${_missingExercises.length} unavailable exercise(s). The program cannot be started until this is fixed.',
                          style: const TextStyle(
                            color: Colors.redAccent,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 24),

              Text(
                isArabic ? 'تمارين البرنامج' : 'Program Exercises',
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

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _missingExercises.isNotEmpty
                      ? null
                      : _startProgramWorkout,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(
                    isArabic ? 'بدء التمرين' : 'Start Workout',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7138FF),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade800,
                    disabledForegroundColor: Colors.white54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
  );
}
}