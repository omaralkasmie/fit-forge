import 'package:drift/drift.dart';

import '../data/local/app_database.dart' as db;

class TrainingCycleRepository {
  final db.AppDatabase database;

  TrainingCycleRepository(this.database);

  Future<db.TrainingCycleData> getOrCreateCycle() async {
    final existingCycle = await (database.select(
      database.trainingCycle,
    )..where((table) => table.id.equals(1)))
        .getSingleOrNull();

    if (existingCycle != null) {
      return existingCycle;
    }

    final newCycle = db.TrainingCycleCompanion.insert(
      id: const Value(1),
      startDate: DateTime.now(),
    );

    await database.into(database.trainingCycle).insert(newCycle);

    return (await (database.select(
      database.trainingCycle,
    )..where((table) => table.id.equals(1)))
        .getSingle());
  }
}