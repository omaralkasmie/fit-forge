import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class WorkoutSessions extends Table {
  TextColumn get id => text()();

  TextColumn get type => text()();

  TextColumn get programName => text().nullable()();

  DateTimeColumn get startTime => dateTime()();

  DateTimeColumn get endTime => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class WorkoutExercises extends Table {
  TextColumn get id => text()();

  TextColumn get sessionId =>
      text().references(WorkoutSessions, #id, onDelete: KeyAction.cascade)();

  TextColumn get exerciseId => text()();
  TextColumn get exerciseName => text()();

  TextColumn get exerciseNameEn => text().nullable()();

  TextColumn get muscleGroup => text()();

  TextColumn get muscleGroupEn => text().nullable()();

  IntColumn get exerciseOrder => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class WorkoutSets extends Table {
  TextColumn get id => text()();

  TextColumn get workoutExerciseId =>
      text().references(WorkoutExercises, #id, onDelete: KeyAction.cascade)();

  IntColumn get setNumber => integer()();

  RealColumn get weight => real()();

  IntColumn get reps => integer()();

  BoolColumn get isCompleted => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [WorkoutSessions, WorkoutExercises, WorkoutSets])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'fitforge_database',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.dart.js'),
    ),
  );
}
