class Exercise {
  final String id;

  // Arabic content
  final String name;
  final String muscleGroup;
  final String description;
  final String difficulty;
  final String equipment;

  final List<String> targetMuscles;
  final List<String> instructions;
  final List<String> commonMistakes;

  // English content (optional)
  final String? nameEn;
  final String? muscleGroupEn;
  final String? descriptionEn;
  final String? difficultyEn;
  final String? equipmentEn;

  final List<String>? targetMusclesEn;
  final List<String>? instructionsEn;
  final List<String>? commonMistakesEn;

  // Other data
  final String image;
  final int suggestedSets;
  final int suggestedReps;
  final bool isCustom;

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
    this.nameEn,
    this.muscleGroupEn,
    this.descriptionEn,
    this.difficultyEn,
    this.equipmentEn,
    this.targetMusclesEn,
    this.instructionsEn,
    this.commonMistakesEn,
  });

  // Localized content helpers
  String nameFor(bool isArabic) =>
      isArabic ? name : (nameEn ?? name);

  String muscleGroupFor(bool isArabic) =>
      isArabic ? muscleGroup : (muscleGroupEn ?? muscleGroup);

  String descriptionFor(bool isArabic) =>
      isArabic ? description : (descriptionEn ?? description);

  String difficultyFor(bool isArabic) =>
      isArabic ? difficulty : (difficultyEn ?? difficulty);

  String equipmentFor(bool isArabic) =>
      isArabic ? equipment : (equipmentEn ?? equipment);

  List<String> targetMusclesFor(bool isArabic) =>
      isArabic ? targetMuscles : (targetMusclesEn ?? targetMuscles);

  List<String> instructionsFor(bool isArabic) =>
      isArabic ? instructions : (instructionsEn ?? instructions);

  List<String> commonMistakesFor(bool isArabic) =>
      isArabic ? commonMistakes : (commonMistakesEn ?? commonMistakes);
}