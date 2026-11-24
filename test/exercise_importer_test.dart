import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:fit_forge/services/exercise_importer.dart';
import 'package:flutter/services.dart';
import 'package:fit_forge/constants/exercise_filters.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Load all external exercises', () async {
    final exercises = await ExerciseImporter.loadExercises();

    expect(exercises.length, 876);
    expect(exercises.first.source, 'free_exercise_db');

    expect(exercises.first.image, isNotEmpty);

final imageData = await rootBundle.load(exercises.first.image);

expect(imageData.lengthInBytes, greaterThan(0));

  });

  test('All external exercises have valid filter IDs', () async {
  final exercises = await ExerciseImporter.loadExercises();

  const validEquipmentIds = {
    ExerciseEquipment.barbell,
    ExerciseEquipment.dumbbell,
    ExerciseEquipment.cable,
    ExerciseEquipment.machine,
    ExerciseEquipment.bodyweight,
    ExerciseEquipment.pullUpBar,
    ExerciseEquipment.bench,
    ExerciseEquipment.bands,
    ExerciseEquipment.kettlebell,
    ExerciseEquipment.medicineBall,
    ExerciseEquipment.exerciseBall,
    ExerciseEquipment.foamRoller,
    ExerciseEquipment.other,
  };

  const validDifficultyIds = {
    ExerciseDifficulty.beginner,
    ExerciseDifficulty.intermediate,
    ExerciseDifficulty.advanced,
  };

  for (final exercise in exercises) {
    expect(
      exercise.equipmentIds,
      everyElement(isIn(validEquipmentIds)),
      reason: 'Invalid equipment ID in ${exercise.id}',
    );

    expect(
      validDifficultyIds,
      contains(exercise.difficultyId),
      reason: 'Invalid difficulty ID in ${exercise.id}',
    );
  }
});
test('Expert difficulty is mapped to advanced', () async {
  final exercises = await ExerciseImporter.loadExercises();

  final expertExercises = exercises
      .where((exercise) => exercise.difficultyEn == 'expert')
      .toList();

  expect(expertExercises, isNotEmpty);

  for (final exercise in expertExercises) {
    expect(
      exercise.difficultyId,
      ExerciseDifficulty.advanced,
      reason: 'Incorrect difficulty mapping for ${exercise.id}',
    );
  }
});
test('Exercises with unspecified equipment have empty equipment IDs', () async {
  final jsonString = await rootBundle.loadString(
    'assets/data/exercises.json',
  );

  final List<dynamic> data = jsonDecode(jsonString);
  final exercises = await ExerciseImporter.loadExercises();

  for (final item in data) {
    final equipment = item['equipment'];

    if (equipment == null ||
        (equipment is String && equipment.trim().isEmpty)) {
      final exerciseId = 'external_${item['id']}';

      final exercise = exercises.firstWhere(
        (exercise) => exercise.id == exerciseId,
      );

      expect(
        exercise.equipmentIds,
        isEmpty,
        reason: 'Unspecified equipment should remain empty: $exerciseId',
      );
    }
  }
});
}
