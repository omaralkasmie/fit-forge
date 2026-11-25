import 'package:flutter_test/flutter_test.dart';
import 'package:fit_forge/models/exercise.dart';
import 'package:fit_forge/services/exercise_serializer.dart';

void main() {
  group('ExerciseSerializer', () {
    test('preserves all exercise data after JSON round trip', () {
      const exercise = Exercise(
        id: 'test_001',
        name: 'ضغط الصدر بالبار',
        muscleGroup: 'الصدر',
        description: 'تمرين لتقوية عضلات الصدر',
        image: 'assets/images/bench_press.jpg',
        suggestedSets: 4,
        suggestedReps: 12,
        difficulty: 'متوسط',
        equipment: 'بار',
        targetMuscles: ['الصدر'],
        instructions: ['استلقِ على المقعد', 'ادفع البار للأعلى'],
        commonMistakes: ['تقويس الظهر'],
        nameEn: 'Barbell Bench Press',
        muscleGroupEn: 'Chest',
        descriptionEn: 'A chest strengthening exercise',
        difficultyEn: 'Intermediate',
        equipmentEn: 'Barbell',
        targetMusclesEn: ['Pectoralis Major'],
        instructionsEn: ['Lie on the bench', 'Push the bar upward'],
        commonMistakesEn: ['Arching the back'],
        isCustom: true,
        secondaryMuscles: ['triceps', 'shoulders'],
        secondaryMusclesEn: ['Triceps', 'Shoulders'],
        category: 'strength',
        mechanic: 'compound',
        force: 'push',
        images: ['image_1.jpg', 'image_2.jpg'],
        source: 'external',
        equipmentIds: ['barbell', 'bench'],
        difficultyId: 'intermediate',
      );

      final json = ExerciseSerializer.toJson(exercise);
      final restored = ExerciseSerializer.fromJson(json);

      expect(restored.id, exercise.id);
      expect(restored.name, exercise.name);
      expect(restored.muscleGroup, exercise.muscleGroup);
      expect(restored.description, exercise.description);
      expect(restored.image, exercise.image);
      expect(restored.suggestedSets, exercise.suggestedSets);
      expect(restored.suggestedReps, exercise.suggestedReps);
      expect(restored.difficulty, exercise.difficulty);
      expect(restored.equipment, exercise.equipment);

      expect(restored.targetMuscles, exercise.targetMuscles);
      expect(restored.instructions, exercise.instructions);
      expect(restored.commonMistakes, exercise.commonMistakes);

      expect(restored.nameEn, exercise.nameEn);
      expect(restored.muscleGroupEn, exercise.muscleGroupEn);
      expect(restored.descriptionEn, exercise.descriptionEn);
      expect(restored.difficultyEn, exercise.difficultyEn);
      expect(restored.equipmentEn, exercise.equipmentEn);

      expect(restored.targetMusclesEn, exercise.targetMusclesEn);
      expect(restored.instructionsEn, exercise.instructionsEn);
      expect(restored.commonMistakesEn, exercise.commonMistakesEn);

      expect(restored.isCustom, exercise.isCustom);
      expect(restored.secondaryMuscles, exercise.secondaryMuscles);
      expect(restored.secondaryMusclesEn, exercise.secondaryMusclesEn);
      expect(restored.category, exercise.category);
      expect(restored.mechanic, exercise.mechanic);
      expect(restored.force, exercise.force);
      expect(restored.images, exercise.images);
      expect(restored.source, exercise.source);
      expect(restored.equipmentIds, exercise.equipmentIds);
      expect(restored.difficultyId, exercise.difficultyId);
    });

    test('handles optional fields and empty lists correctly', () {
      const exercise = Exercise(
        id: 'test_002',
        name: 'Push Ups',
        muscleGroup: 'Chest',
        description: 'Bodyweight exercise',
        image: 'push_up.jpg',
        suggestedSets: 3,
        suggestedReps: 10,
        difficulty: 'Beginner',
        equipment: 'Bodyweight',
      );

      final json = ExerciseSerializer.toJson(exercise);
      final restored = ExerciseSerializer.fromJson(json);

      expect(restored.id, exercise.id);
      expect(restored.nameEn, isNull);
      expect(restored.category, isNull);
      expect(restored.difficultyId, isNull);
      expect(restored.targetMuscles, isEmpty);
      expect(restored.instructions, isEmpty);
      expect(restored.commonMistakes, isEmpty);
      expect(restored.secondaryMuscles, isEmpty);
      expect(restored.images, isEmpty);
      expect(restored.equipmentIds, isEmpty);
      expect(restored.isCustom, isFalse);
      expect(restored.source, 'local');
    });

    test('preserves null English lists as null', () {
      const exercise = Exercise(
        id: 'test_003',
        name: 'Squat',
        muscleGroup: 'Legs',
        description: 'Leg exercise',
        image: 'squat.jpg',
        suggestedSets: 3,
        suggestedReps: 12,
        difficulty: 'Beginner',
        equipment: 'Bodyweight',
      );

      final restored = ExerciseSerializer.fromJson(
        ExerciseSerializer.toJson(exercise),
      );

      expect(restored.targetMusclesEn, isNull);
      expect(restored.instructionsEn, isNull);
      expect(restored.commonMistakesEn, isNull);
      expect(restored.secondaryMusclesEn, isNull);
    });
  });
}