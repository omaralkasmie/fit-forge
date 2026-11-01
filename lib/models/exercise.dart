class Exercise {
  final String id;
  final String name;
  final String muscleGroup;
  final String description;
  final String image;
  final int suggestedSets;
  final int suggestedReps;
  final String difficulty;
  final String equipment;
  final bool isCustom;

  final List<String> targetMuscles;
  final List<String> instructions;
  final List<String> commonMistakes;

  const Exercise({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.description,
    required this.image,
    required this.suggestedSets,
    required this.suggestedReps,
    required this.difficulty,
    required this.equipment,
    this.isCustom = false,
    this.targetMuscles = const [],
    this.instructions = const [],
    this.commonMistakes = const [],
  });
}