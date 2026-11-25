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

  IntColumn get setNumber =>
      integer().customConstraint('NOT NULL CHECK (set_number > 0)')();

  RealColumn get weight =>
      real().customConstraint('NOT NULL CHECK (weight >= 0)')();

  IntColumn get reps =>
      integer().customConstraint('NOT NULL CHECK (reps >= 0)')();

  BoolColumn get isCompleted => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

// ==============================
// Active Workout Tables
// ==============================

class ActiveWorkoutSessions extends Table {
  TextColumn get id => text()();

  TextColumn get type => text()();

  TextColumn get programName => text().nullable()();

  DateTimeColumn get startTime => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class ActiveWorkoutExercises extends Table {
  TextColumn get id => text()();

  TextColumn get sessionId => text().references(
    ActiveWorkoutSessions,
    #id,
    onDelete: KeyAction.cascade,
  )();

  // Complete Exercise data stored as JSON.
  TextColumn get exerciseData => text()();

  IntColumn get exerciseOrder => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class ActiveWorkoutSets extends Table {
  TextColumn get id => text()();

  TextColumn get workoutExerciseId => text().references(
    ActiveWorkoutExercises,
    #id,
    onDelete: KeyAction.cascade,
  )();

  IntColumn get setNumber =>
      integer().customConstraint('NOT NULL CHECK (set_number > 0)')();

  RealColumn get weight =>
      real().customConstraint('NOT NULL CHECK (weight >= 0)')();

  IntColumn get reps =>
      integer().customConstraint('NOT NULL CHECK (reps >= 0)')();

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
  IntColumn get setNumber =>
      integer().customConstraint('NOT NULL CHECK (set_number > 0)')();

  RealColumn get targetWeight =>
      real().customConstraint('NOT NULL CHECK (target_weight >= 0)')();

  IntColumn get targetReps =>
      integer().customConstraint('NOT NULL CHECK (target_reps >= 0)')();

  @override
  Set<Column> get primaryKey => {id};
}
// ==============================
// Training Cycle Table
// ==============================

class TrainingCycle extends Table {
  IntColumn get id => integer()();

  DateTimeColumn get startDate => dateTime()();

  IntColumn get targetDays => integer()
      .customConstraint('NOT NULL DEFAULT 28 CHECK (target_days > 0)')();

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
    TrainingCycle,
    ActiveWorkoutSessions,
ActiveWorkoutExercises,
ActiveWorkoutSets,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 5;

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
      if (from < 3) {
        await m.createTable(trainingCycle);
      }
      if (from < 4) {
        await m.alterTable(TableMigration(workoutSets));
        await m.alterTable(TableMigration(programSets));
        await m.alterTable(TableMigration(trainingCycle));
      }
      if (from < 5){
       if (from < 5) {
  await m.createTable(activeWorkoutSessions);
  await m.createTable(activeWorkoutExercises);
  await m.createTable(activeWorkoutSets);
}
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
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
