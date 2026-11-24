import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/exercise.dart';
import '../constants/exercise_filters.dart';

class ExerciseImporter {
  static Future<List<Exercise>> loadExercises() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/exercises.json',
    );
    final translationsString = await rootBundle.loadString(
      'assets/data/exercise_translations_ar.json',
    );

    final Map<String, dynamic> translations = jsonDecode(translationsString);

    final List<dynamic> data = jsonDecode(jsonString);

    return data.map((item) {
      final Map<String, dynamic> json = item as Map<String, dynamic>;
      final String exerciseId = 'external_${json['id']}';

      final Map<String, dynamic> translation =
          translations[exerciseId] as Map<String, dynamic>? ?? {};

      final List<String> primaryMuscles = List<String>.from(
        json['primaryMuscles'] ?? [],
      );

      final List<String> secondaryMuscles = List<String>.from(
        json['secondaryMuscles'] ?? [],
      );

      final List<String> instructions = List<String>.from(
        json['instructions'] ?? [],
      );

      final List<String> images = List<String>.from(json['images'] ?? []);

      final String name = json['name'] ?? 'Unknown Exercise';

      final String nameAr = translation['name'] as String? ?? name;

      final String descriptionAr =
          translation['description'] as String? ?? instructions.join('\n');

      final List<String> instructionsAr = translation['instructions'] != null
          ? List<String>.from(translation['instructions'])
          : instructions;

      final String muscleGroup = primaryMuscles.isNotEmpty
          ? _translateMuscleGroup(primaryMuscles.first)
          : 'الأرجل';

      final String equipment = _translateEquipment(
        json['equipment'] ?? 'other',
      );

      final String difficulty = _translateDifficulty(
        json['level'] ?? 'beginner',
      );
      final List<String> equipmentIds = _mapEquipmentIds(json['equipment']);

      final String difficultyId = _mapDifficultyId(json['level']);

      return Exercise(
        id: exerciseId,
        name: nameAr,
        nameEn: name,
        muscleGroup: muscleGroup,
        muscleGroupEn: primaryMuscles.isNotEmpty
            ? primaryMuscles.first
            : 'General',
        description: descriptionAr,
        descriptionEn: instructions.join('\n'),
        image: images.isNotEmpty
            ? 'assets/images/external_exercises/${images.first}'
            : '',
        images: images,
        suggestedSets: 3,
        suggestedReps: 10,
        difficulty: difficulty,
        equipmentIds: equipmentIds,
        difficultyId: difficultyId,
        difficultyEn: json['level'] ?? 'beginner',
        equipment: equipment,
        equipmentEn: json['equipment'] ?? 'other',
        targetMuscles: primaryMuscles.map(_translateMuscle).toList(),
        targetMusclesEn: primaryMuscles,
        secondaryMuscles: secondaryMuscles.map(_translateMuscle).toList(),
        secondaryMusclesEn: secondaryMuscles,
        instructions: instructionsAr,
        instructionsEn: instructions,
        category: json['category'],
        mechanic: json['mechanic'],
        force: json['force'],
        source: 'free_exercise_db',
      );
    }).toList();
  }

  static String _translateMuscle(String muscle) {
    const translations = {
      'abdominals': 'عضلات البطن',
      'abductors': 'العضلات المُبعِدة',
      'adductors': 'العضلات المُقرِبة',
      'biceps': 'العضلة ذات الرأسين',
      'calves': 'عضلات الساق',
      'chest': 'الصدر',
      'forearms': 'الساعد',
      'glutes': 'الأرداف',
      'hamstrings': 'عضلات الفخذ الخلفية',
      'lats': 'العضلات الظهرية العريضة',
      'lower back': 'أسفل الظهر',
      'middle back': 'منتصف الظهر',
      'neck': 'الرقبة',
      'quadriceps': 'عضلات الفخذ الأمامية',
      'shoulders': 'الأكتاف',
      'traps': 'العضلة شبه المنحرفة',
      'triceps': 'العضلة ثلاثية الرؤوس',
    };

    return translations[muscle] ?? muscle;
  }

  static String _translateDifficulty(String level) {
    const translations = {
      'beginner': 'مبتدئ',
      'intermediate': 'متوسط',
      'expert': 'متقدم',
    };

    return translations[level] ?? level;
  }

  static String _translateEquipment(String equipment) {
    const translations = {
      'bands': 'أشرطة المقاومة',
      'barbell': 'بار',
      'body only': 'وزن الجسم',
      'cable': 'كيبل',
      'dumbbell': 'دمبل',
      'e-z curl bar': 'بار EZ',
      'exercise ball': 'كرة التمارين',
      'foam roll': 'أسطوانة التدليك',
      'kettlebells': 'كرة حديدية',
      'machine': 'جهاز',
      'medicine ball': 'كرة طبية',
      'other': 'أخرى',
    };

    return translations[equipment] ?? equipment;
  }

  static List<String> _mapEquipmentIds(dynamic equipment) {
  if (equipment == null || equipment is! String || equipment.isEmpty) {
    return [];
  }
  const equipmentMap = {
    'bands': ExerciseEquipment.bands,
    'barbell': ExerciseEquipment.barbell,
    'body only': ExerciseEquipment.bodyweight,
    'cable': ExerciseEquipment.cable,
    'dumbbell': ExerciseEquipment.dumbbell,
    'e-z curl bar': ExerciseEquipment.barbell,
    'exercise ball': ExerciseEquipment.exerciseBall,
    'foam roll': ExerciseEquipment.foamRoller,
    'kettlebells': ExerciseEquipment.kettlebell,
    'machine': ExerciseEquipment.machine,
    'medicine ball': ExerciseEquipment.medicineBall,
    'other': ExerciseEquipment.other,
  };

  final String? equipmentId = equipmentMap[equipment.trim().toLowerCase()];

  return equipmentId == null ? [] : [equipmentId];
}

static String _mapDifficultyId(dynamic level) {
  if (level is! String || level.isEmpty) {
    return ExerciseDifficulty.beginner;
  }

  const difficultyMap = {
    'beginner': ExerciseDifficulty.beginner,
    'intermediate': ExerciseDifficulty.intermediate,
    'expert': ExerciseDifficulty.advanced,
  };

  return difficultyMap[level.trim().toLowerCase()] ??
      ExerciseDifficulty.beginner;
}

  static String _translateMuscleGroup(String muscle) {
    const groups = {
      'chest': 'عضلات الصدر',
      'abdominals': 'البطن',

      'biceps': 'الذراعين',
      'triceps': 'الذراعين',
      'forearms': 'الذراعين',

      'shoulders': 'الأكتاف',

      'lats': 'الظهر',
      'lower back': 'الظهر',
      'middle back': 'الظهر',
      'traps': 'الظهر',
      'neck': 'الظهر',

      'abductors': 'الأرجل',
      'adductors': 'الأرجل',
      'calves': 'الأرجل',
      'glutes': 'الأرجل',
      'hamstrings': 'الأرجل',
      'quadriceps': 'الأرجل',
    };

    return groups[muscle] ?? 'الأرجل';
  }
}
