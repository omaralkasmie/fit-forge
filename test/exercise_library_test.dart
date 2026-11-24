import 'package:flutter_test/flutter_test.dart';

import 'package:fit_forge/constants/exercise_filters.dart';
import 'package:fit_forge/data/workouts/exercise_library.dart';

void main() {
  group('Exercise Library Filters', () {
    final validEquipmentIds = {
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

    final validDifficultyIds = {
      ExerciseDifficulty.beginner,
      ExerciseDifficulty.intermediate,
      ExerciseDifficulty.advanced,
    };

    test('All internal exercises have equipment IDs', () {
      for (final exercise in allExercises) {
        expect(
          exercise.equipmentIds,
          isNotEmpty,
          reason: 'Exercise ${exercise.id} has no equipment IDs',
        );
      }
    });

    test('All equipment IDs are valid', () {
      for (final exercise in allExercises) {
        for (final equipmentId in exercise.equipmentIds) {
          expect(
            validEquipmentIds,
            contains(equipmentId),
            reason:
                'Invalid equipment ID "$equipmentId" in ${exercise.id}',
          );
        }
      }
    });

    test('All internal exercises have a difficulty ID', () {
      for (final exercise in allExercises) {
        expect(
          exercise.difficultyId,
          isNotNull,
          reason: 'Exercise ${exercise.id} has no difficulty ID',
        );
      }
    });

    test('All difficulty IDs are valid', () {
      for (final exercise in allExercises) {
        expect(
          validDifficultyIds,
          contains(exercise.difficultyId),
          reason:
              'Invalid difficulty ID in ${exercise.id}',
        );
      }
    });
  });
  test('All internal exercise IDs are unique', () {
  final exerciseIds = allExercises.map((exercise) => exercise.id).toList();

  expect(
    exerciseIds.toSet().length,
    exerciseIds.length,
    reason: 'Duplicate exercise IDs found',
  );
});
}