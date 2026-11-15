import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

// ==============================
// Workout History Tables
// ==============================

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

// ==============================
// Training Programs Tables
// ==============================

class TrainingPrograms extends Table {
  TextColumn get id => text()();

  TextColumn get nameAr => text()();

TextColumn get nameEn => text()();

TextColumn get descriptionAr => text()();

TextColumn get descriptionEn => text()();

TextColumn get levelAr => text()();

TextColumn get levelEn => text()();

  

  IntColumn get durationWeeks => integer()();

  

  IntColumn get category => integer()();

  TextColumn get type => text()();

  TextColumn get sourceProgramId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ProgramExercises extends Table {
  TextColumn get id => text()();

  TextColumn get programId =>
      text().references(TrainingPrograms, #id, onDelete: KeyAction.cascade)();

  TextColumn get exerciseId => text()();

  IntColumn get exerciseOrder => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class ProgramSets extends Table {
  TextColumn get id => text()();

  TextColumn get programExerciseId =>
      text().references(ProgramExercises, #id, onDelete: KeyAction.cascade)();

  IntColumn get setNumber => integer()();

  RealColumn get targetWeight => real()();

  IntColumn get targetReps => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

// ==============================
// Database
// ==============================

@DriftDatabase(
  tables: [
    WorkoutSessions,
    WorkoutExercises,
    WorkoutSets,
    TrainingPrograms,
    ProgramExercises,
    ProgramSets,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(trainingPrograms);
            await m.createTable(programExercises);
            await m.createTable(programSets);
          }
        },
      );
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