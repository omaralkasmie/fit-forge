import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/exercise.dart';

class ExerciseImporter {
  static Future<List<Exercise>> loadExercises() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/exercises.json',
    );

    final List<dynamic> data = jsonDecode(jsonString);

    return data.map((item) {
      final Map<String, dynamic> json = item as Map<String, dynamic>;

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

      final String muscleGroup = primaryMuscles.isNotEmpty
          ? _translateMuscleGroup(primaryMuscles.first)
          : 'الأرجل';

      final String equipment = _translateEquipment(
        json['equipment'] ?? 'other',
      );

      final String difficulty = _translateDifficulty(
        json['level'] ?? 'beginner',
      );

      return Exercise(
        id: 'external_${json['id']}',
        name: name,
        nameEn: name,
        muscleGroup: muscleGroup,
        muscleGroupEn: primaryMuscles.isNotEmpty
            ? primaryMuscles.first
            : 'General',
        description: instructions.join('\n'),
        descriptionEn: instructions.join('\n'),
        image: images.isNotEmpty ? images.first : '',
        images: images,
        suggestedSets: 3,
        suggestedReps: 10,
        difficulty: difficulty,
        difficultyEn: json['level'] ?? 'beginner',
        equipment: equipment,
        equipmentEn: json['equipment'] ?? 'other',
        targetMuscles: primaryMuscles.map(_translateMuscle).toList(),
        targetMusclesEn: primaryMuscles,
        secondaryMuscles: secondaryMuscles.map(_translateMuscle).toList(),
        secondaryMusclesEn: secondaryMuscles,
        instructions: instructions,
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
