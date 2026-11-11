import 'package:flutter_test/flutter_test.dart';
import 'package:fit_forge/services/exercise_importer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Load all external exercises', () async {
    final exercises = await ExerciseImporter.loadExercises();

    expect(exercises.length, 876);
    expect(exercises.first.source, 'free_exercise_db');
  });
}
