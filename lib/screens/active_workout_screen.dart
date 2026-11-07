import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../models/workout_exercise.dart';
import '../models/workout_set.dart';
import '../routes/app_router.dart';
import '../services/workout_manager.dart';
import '../services/workout_scope.dart';

const Color _bgColor = Color(0xFF0B0B16);
const Color _cardColor = Color(0xFF15182F);
const Color _purpleColor = Color(0xFF9B5CFF);
const Color _pinkColor = Color(0xFFE34DFF);
const Color _greenColor = Color(0xFF20C997);

class ActiveWorkoutScreen extends StatelessWidget {
  const ActiveWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = WorkoutScope.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final session = manager.session;

    if (session == null) {
      return Scaffold(
        backgroundColor: _bgColor,
        appBar: AppBar(
          backgroundColor: _bgColor,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text(
            'No active workout',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    final progress = manager.totalExercises == 0
        ? 0.0
        : manager.completedExercises / manager.totalExercises;

    final canFinishWorkout = manager.isWorkoutCompleted;

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.activeWorkoutTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
              child: _buildProgressCard(
                l10n: l10n,
                manager: manager,
                progress: progress,
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount: session.exercises.length,
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return _ExerciseWorkoutCard(
                    workoutExercise: session.exercises[index],
                    exerciseIndex: index,
                    manager: manager,
                    isArabic: isArabic,
                    l10n: l10n,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: canFinishWorkout
                      ? () async {
                          final success = await manager.finishWorkout();

                          if (!context.mounted) return;

                          if (success) {
                            context.go(AppRouter.workoutSummary);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Failed to save workout. Please try again.',
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _purpleColor,
                    disabledBackgroundColor: _purpleColor.withValues(
                      alpha: 0.25,
                    ),
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Colors.white38,
                    elevation: canFinishWorkout ? 8 : 0,
                    shadowColor: _purpleColor.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.flag_rounded),
                      const SizedBox(width: 10),
                      Text(
                        l10n.finishWorkout,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard({
    required AppLocalizations l10n,
    required WorkoutManager manager,
    required double progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_purpleColor, Color(0xFF4932C9)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.workoutProgress,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.completedExercisesCount(
              manager.completedExercises,
              manager.totalExercises,
            ),
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseWorkoutCard extends StatelessWidget {
  final WorkoutExercise workoutExercise;
  final int exerciseIndex;
  final WorkoutManager manager;
  final bool isArabic;
  final AppLocalizations l10n;

  const _ExerciseWorkoutCard({
    required this.workoutExercise,
    required this.exerciseIndex,
    required this.manager,
    required this.isArabic,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final exercise = workoutExercise.exercise;
    final isCompleted = workoutExercise.isCompleted;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCompleted ? _greenColor.withValues(alpha: 0.10) : _cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isCompleted ? _greenColor : Colors.white12,
          width: isCompleted ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  exercise.nameFor(isArabic),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(
                isCompleted ? Icons.check_circle : Icons.fitness_center,
                color: isCompleted ? _greenColor : _pinkColor,
                size: 25,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.completedExercisesCount(
              workoutExercise.completedSets,
              workoutExercise.sets.length,
            ),
            style: TextStyle(
              color: isCompleted ? _greenColor : Colors.white54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          ...workoutExercise.sets.map(
            (set) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _WorkoutSetRow(
                workoutSet: set,
                exerciseIndex: exerciseIndex,
                manager: manager,
                l10n: l10n,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutSetRow extends StatelessWidget {
  final WorkoutSet workoutSet;
  final int exerciseIndex;
  final WorkoutManager manager;
  final AppLocalizations l10n;

  const _WorkoutSetRow({
    required this.workoutSet,
    required this.exerciseIndex,
    required this.manager,
    required this.l10n,
  });

  void _updateWeight(String value) {
    manager.updateSet(
      exerciseIndex: exerciseIndex,
      setIndex: workoutSet.setNumber - 1,
      weight: double.tryParse(value) ?? 0,
      reps: workoutSet.reps,
    );
  }

  void _updateReps(String value) {
    manager.updateSet(
      exerciseIndex: exerciseIndex,
      setIndex: workoutSet.setNumber - 1,
      weight: workoutSet.weight,
      reps: int.tryParse(value) ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = workoutSet.isCompleted;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCompleted
            ? _greenColor.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isCompleted ? _greenColor : Colors.white10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '#${workoutSet.setNumber}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (isCompleted)
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: _greenColor,
                      size: 17,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      l10n.setCompleted,
                      style: const TextStyle(
                        color: _greenColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  key: ValueKey(
                    'weight_${exerciseIndex}_${workoutSet.setNumber}',
                  ),
                  initialValue: workoutSet.weight == 0
                      ? ''
                      : workoutSet.weight.toString(),
                  enabled: !isCompleted,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: _updateWeight,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.weightLabel,
                    suffixText: l10n.kgUnit,
                    labelStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: _cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  key: ValueKey(
                    'reps_${exerciseIndex}_${workoutSet.setNumber}',
                  ),
                  initialValue: workoutSet.reps == 0
                      ? ''
                      : workoutSet.reps.toString(),
                  enabled: !isCompleted,
                  keyboardType: TextInputType.number,
                  onChanged: _updateReps,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.repsInputLabel,
                    labelStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: _cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 43,
            child: ElevatedButton(
              onPressed: isCompleted
                  ? null
                  : () {
                      final success = manager.completeSet(
                        exerciseIndex: exerciseIndex,
                        setIndex: workoutSet.setNumber - 1,
                      );

                      if (!success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${l10n.weightLabel} / '
                              '${l10n.repsInputLabel}',
                            ),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: isCompleted
                    ? _greenColor.withValues(alpha: 0.25)
                    : _purpleColor,
                disabledBackgroundColor: _greenColor.withValues(alpha: 0.25),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
              child: Text(
                isCompleted ? l10n.setCompleted : l10n.completeSet,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
