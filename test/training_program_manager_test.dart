import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';

import 'package:fit_forge/data/local/app_database.dart'
    hide TrainingProgram, ProgramExercise, ProgramSet;
import 'package:fit_forge/models/training_program.dart';
import 'package:fit_forge/repositories/training_program_repository.dart';
import 'package:fit_forge/services/training_program_manager.dart';
import 'package:fit_forge/data/programs/default_programs.dart';
import 'package:fit_forge/models/program_exercise.dart';
import 'package:fit_forge/models/program_set.dart';


class FakeTrainingProgramRepository extends TrainingProgramRepository {
  FakeTrainingProgramRepository(super.database);

  List<TrainingProgram> savedPrograms = [];
  bool shouldFail = false;

  @override
  Future<List<TrainingProgram>> getSavedPrograms() async {
    if (shouldFail) {
      throw Exception('Test loading error');
    }

    return savedPrograms;
  }

  @override
  Future<void> deleteProgram(String id) async {
    savedPrograms.removeWhere((program) => program.id == id);
  }
  @override
Future<void> saveProgram(TrainingProgram program) async {
  savedPrograms.removeWhere(
    (item) => item.id == program.id,
  );

  savedPrograms.add(program);
}
}

void main() {
  late AppDatabase database;
  late FakeTrainingProgramRepository repository;
  late TrainingProgramManager manager;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = FakeTrainingProgramRepository(database);
    manager = TrainingProgramManager(repository);
  });

  tearDown(() async {
    manager.dispose();
    await database.close();
  });

  TrainingProgram createProgram({
    required String id,
    required ProgramType type,
    String? sourceProgramId,
    String nameAr = 'برنامج تجريبي',
  }) {
    return TrainingProgram(
      id: id,
      nameAr: nameAr,
      nameEn: 'Test Program',
      descriptionAr: 'وصف تجريبي',
      descriptionEn: 'Test description',
      durationWeeks: 4,
      levelAr: 'مبتدئ',
      levelEn: 'Beginner',
      category: 1,
      type: type,
      sourceProgramId: sourceProgramId,
    );
  }

  group('TrainingProgramManager', () {
    test('loads all default programs', () async {
      await manager.loadPrograms();

      expect(manager.programs.length, defaultPrograms.length);
      expect(manager.isLoading, false);
      expect(manager.loadError, isNull);
    });

    test('adds custom programs to default programs', () async {
      final customProgram = createProgram(
        id: 'custom_001',
        type: ProgramType.custom,
      );

      repository.savedPrograms = [customProgram];

      await manager.loadPrograms();

      expect(manager.programs.length, defaultPrograms.length + 1);
      expect(
        manager.programs.any((program) => program.id == 'custom_001'),
        isTrue,
      );
    });

    test('replaces default program with modified version', () async {
      final modifiedProgram = createProgram(
        id: 'modified_muscle',
        type: ProgramType.modified,
        sourceProgramId: 'muscle_building',
        nameAr: 'نسخة معدلة',
      );

      repository.savedPrograms = [modifiedProgram];

      await manager.loadPrograms();

      final program = manager.programs.firstWhere(
        (program) => program.id == 'modified_muscle',
      );

      expect(program.nameAr, 'نسخة معدلة');
      expect(
        manager.programs.any((program) => program.id == 'muscle_building'),
        isFalse,
      );
    });

    test('stores loading error and stops loading', () async {
      repository.shouldFail = true;

      await manager.loadPrograms();

      expect(manager.loadError, isA<Exception>());
      expect(manager.isLoading, false);
    });

    test('keeps previous programs when loading fails', () async {
      await manager.loadPrograms();

      final previousPrograms = manager.programs;

      repository.shouldFail = true;

      await manager.loadPrograms();

      expect(manager.programs.length, previousPrograms.length);
      expect(manager.programs.first.id, previousPrograms.first.id);
      expect(manager.loadError, isA<Exception>());
      expect(manager.isLoading, false);
    });
  });
  test('resets modified program to original', () async {
  final modifiedProgram = createProgram(
    id: 'modified_muscle',
    type: ProgramType.modified,
    sourceProgramId: 'muscle_building',
    nameAr: 'نسخة معدلة',
  );

  repository.savedPrograms = [modifiedProgram];

  await manager.loadPrograms();

  await manager.resetToOriginal('muscle_building');

  expect(
    manager.programs.any(
      (program) => program.id == 'modified_muscle',
    ),
    isFalse,
  );

  expect(
    manager.programs.any(
      (program) => program.id == 'muscle_building',
    ),
    isTrue,
  );
});
 test('resets all modified versions of the same original program', () async {
  final firstModified = createProgram(
    id: 'modified_muscle_1',
    type: ProgramType.modified,
    sourceProgramId: 'muscle_building',
  );

  final secondModified = createProgram(
    id: 'modified_muscle_2',
    type: ProgramType.modified,
    sourceProgramId: 'muscle_building',
  );

  repository.savedPrograms = [
    firstModified,
    secondModified,
  ];

  await manager.loadPrograms();
  await manager.resetToOriginal('muscle_building');

  expect(
    manager.programs.where(
      (program) => program.type == ProgramType.modified &&
          program.sourceProgramId == 'muscle_building',
    ),
    isEmpty,
  );

  expect(
    manager.programs.any((program) => program.id == 'muscle_building'),
    isTrue,
  );
});
test('deletes custom program', () async {
  final customProgram = createProgram(
    id: 'custom_001',
    type: ProgramType.custom,
  );

  repository.savedPrograms = [customProgram];

  await manager.loadPrograms();
  await manager.deleteProgram('custom_001');

  expect(
    manager.programs.any((program) => program.id == 'custom_001'),
    isFalse,
  );
});
test('does not delete built-in program', () async {
  await manager.loadPrograms();

  await manager.deleteProgram('muscle_building');

  expect(
    manager.programs.any((program) => program.id == 'muscle_building'),
    isTrue,
  );
});
test('saves custom program and updates program list', () async {
  final customProgram = createProgram(
    id: 'custom_002',
    type: ProgramType.custom,
  );

  final validProgram = TrainingProgram(
    id: customProgram.id,
    nameAr: customProgram.nameAr,
    nameEn: customProgram.nameEn,
    descriptionAr: customProgram.descriptionAr,
    descriptionEn: customProgram.descriptionEn,
    durationWeeks: customProgram.durationWeeks,
    levelAr: customProgram.levelAr,
    levelEn: customProgram.levelEn,
    category: customProgram.category,
    type: customProgram.type,
    exercises: [
      ProgramExercise(
        exerciseId: 'chest_001',
        exerciseOrder: 1,
        sets: [
          ProgramSet(
            setNumber: 1,
            targetReps: 10,
          ),
        ],
      ),
    ],
  );

  await manager.saveProgram(validProgram);

  expect(
    manager.programs.any((program) => program.id == 'custom_002'),
    isTrue,
  );
});
}
