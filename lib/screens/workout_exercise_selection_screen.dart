import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/workouts/exercise_library.dart';
import '../l10n/app_localizations.dart';
import '../models/exercise.dart';

const Color _bgColor = Color(0xFF0B0B16);
const Color _cardColor = Color(0xFF15182F);
const Color _purpleColor = Color(0xFF9B5CFF);
const Color _pinkColor = Color(0xFFE34DFF);

class WorkoutExerciseSelectionScreen extends StatefulWidget {
  final List<Exercise> initialSelectedExercises;

  const WorkoutExerciseSelectionScreen({
    super.key,
    this.initialSelectedExercises = const [],
  });

  @override
  State<WorkoutExerciseSelectionScreen> createState() =>
      _WorkoutExerciseSelectionScreenState();
}

class _WorkoutExerciseSelectionScreenState
    extends State<WorkoutExerciseSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();

  late List<Exercise> _selectedExercises;

  int _selectedCategory = 0;

  late List<_ExerciseCategory> _categories;

  @override
  void initState() {
    super.initState();

    _selectedExercises = [...widget.initialSelectedExercises];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final l10n = AppLocalizations.of(context)!;

    _categories = [
      _ExerciseCategory(
        title: l10n.exercisesTitle,
        exercises: [
          ...chestExercises,
          ...backExercises,
          ...shoulderExercises,
          ...legExercises,
          ...armsExercises,
          ...absExercises,
        ],
      ),
      _ExerciseCategory(title: l10n.chestExercises, exercises: chestExercises),
      _ExerciseCategory(title: l10n.backExercises, exercises: backExercises),
      _ExerciseCategory(
        title: l10n.shoulderExercises,
        exercises: shoulderExercises,
      ),
      _ExerciseCategory(title: l10n.legExercises, exercises: legExercises),
      _ExerciseCategory(title: l10n.armExercises, exercises: armsExercises),
      _ExerciseCategory(title: l10n.absExercises, exercises: absExercises),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Exercise> get _filteredExercises {
    final query = _searchController.text.trim().toLowerCase();

    final exercises = _categories[_selectedCategory].exercises;

    if (query.isEmpty) {
      return exercises;
    }

    return exercises.where((exercise) {
      return exercise.name.toLowerCase().contains(query) ||
          (exercise.nameEn?.toLowerCase().contains(query) ?? false) ||
          exercise.muscleGroup.toLowerCase().contains(query) ||
          (exercise.muscleGroupEn?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  bool _isSelected(Exercise exercise) {
    return _selectedExercises.any((item) => item.id == exercise.id);
  }

  void _toggleExercise(Exercise exercise) {
    setState(() {
      if (_isSelected(exercise)) {
        _selectedExercises.removeWhere((item) => item.id == exercise.id);
      } else {
        _selectedExercises.add(exercise);
      }
    });
  }

  void _confirmSelection() {
    context.pop(_selectedExercises);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final exercises = _filteredExercises;

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          l10n.selectExercises,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [_purpleColor, Color(0xFF4932C9)],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.fitness_center,
                          color: Colors.white,
                          size: 30,
                        ),
                        const SizedBox(width: 14),
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_selectedExercises.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: l10n.searchExercises,
                      hintStyle: const TextStyle(color: Colors.white38),
                      prefixIcon: const Icon(Icons.search, color: _purpleColor),
                      filled: true,
                      fillColor: _cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white54,
                              ),
                            )
                          : null,
                    ),
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    height: 42,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final isActive = _selectedCategory == index;

                        return ChoiceChip(
                          label: Text(_categories[index].title),
                          selected: isActive,
                          onSelected: (_) {
                            setState(() {
                              _selectedCategory = index;
                            });
                          },
                          selectedColor: _purpleColor,
                          backgroundColor: _cardColor,
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: isActive
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          side: BorderSide(
                            color: isActive ? _purpleColor : Colors.white12,
                          ),
                          showCheckmark: false,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: exercises.isEmpty
                  ? Center(
                      child: Icon(
                        Icons.search_off,
                        color: Colors.white24,
                        size: 55,
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                      itemCount: exercises.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final exercise = exercises[index];
                        final selected = _isSelected(exercise);

                        return _ExerciseSelectionCard(
                          exercise: exercise,
                          isArabic: isArabic,
                          isSelected: selected,
                          onTap: () => _toggleExercise(exercise),
                        );
                      },
                    ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: const BoxDecoration(
                color: _bgColor,
                border: Border(top: BorderSide(color: Colors.white10)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _confirmSelection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _purpleColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    '${l10n.selectExercises} (${_selectedExercises.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExerciseCategory {
  final String title;
  final List<Exercise> exercises;

  const _ExerciseCategory({required this.title, required this.exercises});
}

class _ExerciseSelectionCard extends StatelessWidget {
  final Exercise exercise;
  final bool isArabic;
  final bool isSelected;
  final VoidCallback onTap;

  const _ExerciseSelectionCard({
    required this.exercise,
    required this.isArabic,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _cardColor,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: isSelected ? _purpleColor : Colors.white10,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _purpleColor.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  color: _pinkColor,
                  size: 25,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.nameFor(isArabic),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${exercise.suggestedSets} × ${exercise.suggestedReps}',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 27,
                height: 27,
                decoration: BoxDecoration(
                  color: isSelected ? _purpleColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? _purpleColor : Colors.white38,
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 19)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
