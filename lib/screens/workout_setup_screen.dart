import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../models/exercise.dart';
import '../routes/app_router.dart';
import '../services/workout_scope.dart';

const Color _bgColor = Color(0xFF0B0B16);
const Color _cardColor = Color(0xFF15182F);
const Color _purpleColor = Color(0xFF9B5CFF);
const Color _pinkColor = Color(0xFFE34DFF);

class WorkoutSetupScreen extends StatefulWidget {
  const WorkoutSetupScreen({super.key});

  @override
  State<WorkoutSetupScreen> createState() => _WorkoutSetupScreenState();
}

class _WorkoutSetupScreenState extends State<WorkoutSetupScreen> {
  final List<Exercise> _selectedExercises = [];

  Future<void> _addExercises() async {
    final result = await context.push<List<Exercise>>(
      AppRouter.workoutExerciseSelection,
      extra: _selectedExercises,
    );

    if (!mounted || result == null) return;

    setState(() {
      _selectedExercises
        ..clear()
        ..addAll(result);
    });
  }

  void _removeExercise(Exercise exercise) {
    setState(() {
      _selectedExercises.removeWhere((item) => item.id == exercise.id);
    });
  }

  void _startWorkout() {
    if (_selectedExercises.isEmpty) return;

    WorkoutScope.of(context)
        .startFreeWorkout(List<Exercise>.from(_selectedExercises));

    context.push(AppRouter.activeWorkout);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.workoutSetupTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildWorkoutTypeSection(l10n),

                  const SizedBox(height: 28),

                  _buildSelectedExercisesHeader(l10n),

                  const SizedBox(height: 14),

                  if (_selectedExercises.isEmpty)
                    _buildEmptyState(l10n)
                  else
                    ..._selectedExercises.map(
                      (exercise) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildExerciseCard(exercise, isArabic, l10n),
                      ),
                    ),

                  const SizedBox(height: 12),

                  _buildAddExercisesButton(l10n),
                ],
              ),
            ),

            _buildStartButton(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutTypeSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.workoutSetupTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 14),

        _buildTypeCard(
          title: l10n.freeWorkout,
          icon: Icons.fitness_center,
          selected: true,
        ),

        const SizedBox(height: 12),

        _buildTypeCard(
          title: l10n.programWorkout,
          icon: Icons.assignment,
          selected: false,
          enabled: false,
        ),
      ],
    );
  }

  Widget _buildTypeCard({
    required String title,
    required IconData icon,
    required bool selected,
    bool enabled = true,
  }) {
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? _purpleColor : Colors.white12,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? _pinkColor : Colors.white54, size: 25),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle, color: _purpleColor)
            else if (!enabled)
              const Icon(Icons.lock_outline, color: Colors.white38, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedExercisesHeader(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: Text(
            l10n.selectedExercises,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _purpleColor.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '${_selectedExercises.length}',
            style: const TextStyle(
              color: _pinkColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Icon(
            Icons.fitness_center,
            color: _purpleColor.withValues(alpha: 0.7),
            size: 42,
          ),
          const SizedBox(height: 14),
          Text(
            l10n.noExercisesSelected,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white60, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(
    Exercise exercise,
    bool isArabic,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: _purpleColor.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.fitness_center, color: _pinkColor),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.nameFor(isArabic),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${l10n.setsLabel(exercise.suggestedSets)}  ×  '
                  '${l10n.repsLabel(exercise.suggestedReps)}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),

          IconButton(
            tooltip: l10n.removeExercise,
            onPressed: () => _removeExercise(exercise),
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }

  Widget _buildAddExercisesButton(AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: _addExercises,
        icon: const Icon(Icons.add),
        label: Text(l10n.addExercises),
        style: OutlinedButton.styleFrom(
          foregroundColor: _purpleColor,
          side: const BorderSide(color: _purpleColor, width: 1.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton(AppLocalizations l10n) {
    final canStart = _selectedExercises.isNotEmpty;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: const BoxDecoration(
        color: _bgColor,
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: canStart ? _startWorkout : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _purpleColor,
            disabledBackgroundColor: _cardColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            l10n.startWorkout,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
