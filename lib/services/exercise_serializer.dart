import 'dart:convert';

import '../models/exercise.dart';

class ExerciseSerializer {
  static String toJson(Exercise exercise) {
    return jsonEncode({
      'id': exercise.id,
      'name': exercise.name,
      'muscleGroup': exercise.muscleGroup,
      'description': exercise.description,
      'difficulty': exercise.difficulty,
      'equipment': exercise.equipment,
      'targetMuscles': exercise.targetMuscles,
      'instructions': exercise.instructions,
      'commonMistakes': exercise.commonMistakes,
      'nameEn': exercise.nameEn,
      'muscleGroupEn': exercise.muscleGroupEn,
      'descriptionEn': exercise.descriptionEn,
      'difficultyEn': exercise.difficultyEn,
      'equipmentEn': exercise.equipmentEn,
      'targetMusclesEn': exercise.targetMusclesEn,
      'instructionsEn': exercise.instructionsEn,
      'commonMistakesEn': exercise.commonMistakesEn,
      'image': exercise.image,
      'suggestedSets': exercise.suggestedSets,
      'suggestedReps': exercise.suggestedReps,
      'isCustom': exercise.isCustom,
      'secondaryMuscles': exercise.secondaryMuscles,
      'secondaryMusclesEn': exercise.secondaryMusclesEn,
      'category': exercise.category,
      'mechanic': exercise.mechanic,
      'force': exercise.force,
      'images': exercise.images,
      'source': exercise.source,
      'equipmentIds': exercise.equipmentIds,
      'difficultyId': exercise.difficultyId,
    });
  }

  static Exercise fromJson(String jsonString) {
    final Map<String, dynamic> json =
        jsonDecode(jsonString) as Map<String, dynamic>;

    return Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      muscleGroup: json['muscleGroup'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      suggestedSets: json['suggestedSets'] as int,
      suggestedReps: json['suggestedReps'] as int,
      difficulty: json['difficulty'] as String,
      equipment: json['equipment'] as String,
      isCustom: json['isCustom'] as bool? ?? false,
      targetMuscles: List<String>.from(
        json['targetMuscles'] ?? const [],
      ),
      instructions: List<String>.from(
        json['instructions'] ?? const [],
      ),
      commonMistakes: List<String>.from(
        json['commonMistakes'] ?? const [],
      ),
      nameEn: json['nameEn'] as String?,
      muscleGroupEn: json['muscleGroupEn'] as String?,
      descriptionEn: json['descriptionEn'] as String?,
      difficultyEn: json['difficultyEn'] as String?,
      equipmentEn: json['equipmentEn'] as String?,
      targetMusclesEn: _stringListOrNull(json['targetMusclesEn']),
      instructionsEn: _stringListOrNull(json['instructionsEn']),
      commonMistakesEn: _stringListOrNull(json['commonMistakesEn']),
      secondaryMuscles: List<String>.from(
        json['secondaryMuscles'] ?? const [],
      ),
      secondaryMusclesEn: _stringListOrNull(
        json['secondaryMusclesEn'],
      ),
      category: json['category'] as String?,
      mechanic: json['mechanic'] as String?,
      force: json['force'] as String?,
      images: List<String>.from(json['images'] ?? const []),
      source: json['source'] as String? ?? 'local',
      equipmentIds: List<String>.from(
        json['equipmentIds'] ?? const [],
      ),
      difficultyId: json['difficultyId'] as String?,
    );
  }

  static List<String>? _stringListOrNull(dynamic value) {
    if (value == null) return null;
    return List<String>.from(value);
  }
}