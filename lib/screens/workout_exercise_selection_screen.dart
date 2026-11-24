import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/workouts/exercise_library.dart';
import '../l10n/app_localizations.dart';
import '../models/exercise.dart';
import '../constants/exercise_filters.dart';

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

  final ScrollController _scrollController = ScrollController();

  late List<Exercise> _selectedExercises;

  List<Exercise> _allExercises = [];

  bool _isLoading = true;

  int _selectedCategory = 0;

  String? _selectedEquipment;

  String? _selectedDifficulty;

  late List<_ExerciseCategory> _categories;

  @override
  void initState() {
    super.initState();

    _selectedExercises = [...widget.initialSelectedExercises];

    _loadExercises();
  }

  Future<void> _loadExercises() async {
    try {
      final exercises = await loadAllExercises();

      if (!mounted) return;

      setState(() {
        _allExercises = exercises;
        _isLoading = false;
        _updateCategories();
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _allExercises = allExercises;
        _isLoading = false;
        _updateCategories();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateCategories();
  }

  void _updateCategories() {
    final l10n = AppLocalizations.of(context)!;

    final chest = _allExercises
        .where(
          (e) =>
              e.muscleGroup == 'عضلات الصدر' ||
              e.muscleGroup == 'عضلات الصدر العلوية',
        )
        .toList();

    final back = _allExercises.where((e) => e.muscleGroup == 'الظهر').toList();

    final shoulders = _allExercises
        .where((e) => e.muscleGroup == 'الأكتاف')
        .toList();

    final legs = _allExercises.where((e) => e.muscleGroup == 'الأرجل').toList();

    final arms = _allExercises
        .where((e) => e.muscleGroup == 'الذراعين')
        .toList();

    final abs = _allExercises.where((e) => e.muscleGroup == 'البطن').toList();

    _categories = [
      _ExerciseCategory(title: l10n.exercisesTitle, exercises: _allExercises),
      _ExerciseCategory(title: l10n.chestExercises, exercises: chest),
      _ExerciseCategory(title: l10n.backExercises, exercises: back),
      _ExerciseCategory(title: l10n.shoulderExercises, exercises: shoulders),
      _ExerciseCategory(title: l10n.legExercises, exercises: legs),
      _ExerciseCategory(title: l10n.armExercises, exercises: arms),
      _ExerciseCategory(title: l10n.absExercises, exercises: abs),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
List<Exercise> get _filteredExercises {
  final query = _searchController.text.trim().toLowerCase();

  final exercises = _categories[_selectedCategory].exercises;

  return exercises.where((exercise) {
    final matchesSearch =
        query.isEmpty ||
        exercise.name.toLowerCase().contains(query) ||
        (exercise.nameEn?.toLowerCase().contains(query) ?? false) ||
        exercise.muscleGroup.toLowerCase().contains(query) ||
        (exercise.muscleGroupEn?.toLowerCase().contains(query) ?? false);

    final matchesEquipment =
        _selectedEquipment == null ||
        exercise.equipmentIds.contains(_selectedEquipment);

    final matchesDifficulty =
        _selectedDifficulty == null ||
        exercise.difficultyId == _selectedDifficulty;

    return matchesSearch && matchesEquipment && matchesDifficulty;
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
      resizeToAvoidBottomInset: true,
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
            Flexible(
              child: SingleChildScrollView(
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
                        prefixIcon: const Icon(
                          Icons.search,
                          color: _purpleColor,
                        ),
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

                              _scrollController.jumpTo(0);
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
                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.equipmentLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_selectedEquipment != null ||
                            _selectedDifficulty != null)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedEquipment = null;
                                _selectedDifficulty = null;
                              });
                              _scrollController.jumpTo(0);
                            },
                            child: Text(l10n.clearFilters),
                          ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildEquipmentChip(
                            value: ExerciseEquipment.bands,
                            label: l10n.equipmentBands,
                          ),
                          _buildEquipmentChip(
                            value: ExerciseEquipment.barbell,
                            label: l10n.equipmentBarbell,
                          ),
                          _buildEquipmentChip(
                            value: ExerciseEquipment.bodyweight,
                            label: l10n.equipmentBodyOnly,
                          ),
                          _buildEquipmentChip(
                            value: ExerciseEquipment.cable,
                            label: l10n.equipmentCable,
                          ),
                          _buildEquipmentChip(
                            value: ExerciseEquipment.dumbbell,
                            label: l10n.equipmentDumbbell,
                          ),
                          _buildEquipmentChip(
                            value: ExerciseEquipment.barbell,
                            label: l10n.equipmentEzCurlBar,
                          ),
                          _buildEquipmentChip(
                            value: ExerciseEquipment.exerciseBall,
                            label: l10n.equipmentExerciseBall,
                          ),
                          _buildEquipmentChip(
                            value: ExerciseEquipment.foamRoller,
                            label: l10n.equipmentFoamRoll,
                          ),
                          _buildEquipmentChip(
                            value: ExerciseEquipment.kettlebell,
                            label: l10n.equipmentKettlebells,
                          ),
                          _buildEquipmentChip(
                            value: ExerciseEquipment.machine,
                            label: l10n.equipmentMachine,
                          ),
                          _buildEquipmentChip(
                            value: ExerciseEquipment.medicineBall,
                            label: l10n.equipmentMedicineBall,
                          ),
                          _buildEquipmentChip(
                            value: ExerciseEquipment.other,
                            label: l10n.equipmentOther,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        l10n.difficultyLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildDifficultyChip(
                            value: ExerciseDifficulty.beginner,
                            label: l10n.difficultyBeginner,
                          ),
                          _buildDifficultyChip(
                            value: ExerciseDifficulty.intermediate,
                            label: l10n.difficultyIntermediate,
                          ),
                          _buildDifficultyChip(
                            value: ExerciseDifficulty.advanced,
                            label: l10n.difficultyAdvanced,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (!_isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    l10n.exerciseCountLabel(exercises.length),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

            Flexible(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: _purpleColor),
                    )
                  : exercises.isEmpty
                  ? const Center(
                      child: Icon(
                        Icons.search_off,
                        color: Colors.white24,
                        size: 55,
                      ),
                    )
                  : ListView.separated(
                      controller: _scrollController,
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
                  onPressed: _selectedExercises.isEmpty
                      ? null
                      : _confirmSelection,
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

  Widget _buildEquipmentChip({required String value, required String label}) {
    final isActive = _selectedEquipment == value;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isActive,
        onSelected: (_) {
          setState(() {
            _selectedEquipment = isActive ? null : value;
          });
          _scrollController.jumpTo(0);
        },
        selectedColor: _purpleColor,
        backgroundColor: _cardColor,
        labelStyle: TextStyle(
          color: Colors.white,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
        side: BorderSide(color: isActive ? _purpleColor : Colors.white12),
        showCheckmark: false,
      ),
    );
  }

  Widget _buildDifficultyChip({required String value, required String label}) {
    final isActive = _selectedDifficulty == value;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isActive,
        onSelected: (_) {
          setState(() {
            _selectedDifficulty = isActive ? null : value;
          });
          _scrollController.jumpTo(0);
        },
        selectedColor: _purpleColor,
        backgroundColor: _cardColor,
        labelStyle: TextStyle(
          color: Colors.white,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
        side: BorderSide(color: isActive ? _purpleColor : Colors.white12),
        showCheckmark: false,
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
                child: exercise.image.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Image.asset(
                          exercise.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.fitness_center,
                              color: _pinkColor,
                              size: 25,
                            );
                          },
                        ),
                      )
                    : const Icon(
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
