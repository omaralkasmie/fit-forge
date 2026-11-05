import '../../models/exercise.dart';

import '../exercises/chest_exercises.dart';
import '../exercises/back_exercises.dart';
import '../exercises/shoulder_exercises.dart';
import '../exercises/leg_exercises.dart';
import '../exercises/arms_exercises.dart';
import '../exercises/abs_exercises.dart';

final List<Exercise> allExercises = [
  ...chestExercises,
  ...backExercises,
  ...shoulderExercises,
  ...legExercises,
  ...armsExercises,
  ...absExercises,
];
