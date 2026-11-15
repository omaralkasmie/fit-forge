import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:fit_forge/data/local/app_database.dart';
import 'package:fit_forge/repositories/training_cycle_repository.dart';

void main() {
  late AppDatabase database;
  late TrainingCycleRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = TrainingCycleRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('TrainingCycleRepository', () {
    test('creates a new cycle with 28 training days', () async {
      final cycle = await repository.getOrCreateCycle();

      expect(cycle.id, 1);
      expect(cycle.targetDays, 28);
      expect(cycle.startDate, isNotNull);
    });

    test(
      'returns the existing cycle without resetting its start date',
      () async {
        final firstCycle = await repository.getOrCreateCycle();

        final secondCycle = await repository.getOrCreateCycle();

        expect(secondCycle.id, firstCycle.id);
        expect(secondCycle.startDate, firstCycle.startDate);
        expect(secondCycle.targetDays, firstCycle.targetDays);
      },
    );
    test('persists cycle after closing and reopening database', () async {
      final directory = await Directory.systemTemp.createTemp();
      final file = File('${directory.path}/training_cycle.sqlite');

      final firstDatabase = AppDatabase(NativeDatabase(file));
      final firstRepository = TrainingCycleRepository(firstDatabase);

      final firstCycle = await firstRepository.getOrCreateCycle();

      await firstDatabase.close();

      final reopenedDatabase = AppDatabase(NativeDatabase(file));

      try {
        final reopenedRepository = TrainingCycleRepository(reopenedDatabase);

        final reopenedCycle = await reopenedRepository.getOrCreateCycle();

        expect(reopenedCycle.id, firstCycle.id);
        expect(reopenedCycle.startDate, firstCycle.startDate);
        expect(reopenedCycle.targetDays, 28);
      } finally {
        await reopenedDatabase.close();
        await directory.delete(recursive: true);
      }
    });
  });
}
