import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:fit_forge/data/local/app_database.dart';

import 'dart:io';

import 'package:drift/drift.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('enables foreign key constraints', () async {
    final result = await database
        .customSelect('PRAGMA foreign_keys')
        .getSingle();

    expect(result.data['foreign_keys'], 1);
  });
  test('deletes program exercises and sets when program is deleted', () async {
    // 1. إنشاء برنامج تجريبي.
    await database
        .into(database.trainingPrograms)
        .insert(
          TrainingProgramsCompanion.insert(
            id: 'test_program',
            nameAr: 'برنامج تجريبي',
            nameEn: 'Test Program',
            descriptionAr: 'وصف تجريبي',
            descriptionEn: 'Test Description',
            levelAr: 'مبتدئ',
            levelEn: 'Beginner',
            durationWeeks: 4,
            category: 0,
            type: 'custom',
          ),
        );

    // 2. إضافة تمرين تابع للبرنامج.
    await database
        .into(database.programExercises)
        .insert(
          ProgramExercisesCompanion.insert(
            id: 'test_exercise',
            programId: 'test_program',
            exerciseId: 'bench_press',
            exerciseOrder: 1,
          ),
        );

    // 3. إضافة مجموعة تابعة للتمرين.
    await database
        .into(database.programSets)
        .insert(
          ProgramSetsCompanion.insert(
            id: 'test_set',
            programExerciseId: 'test_exercise',
            setNumber: 1,
            targetWeight: 20,
            targetReps: 10,
          ),
        );

    // 4. التأكد من وجود البيانات قبل الحذف.
    expect(
      await database.select(database.trainingPrograms).get(),
      hasLength(1),
    );
    expect(
      await database.select(database.programExercises).get(),
      hasLength(1),
    );
    expect(await database.select(database.programSets).get(), hasLength(1));

    // 5. حذف البرنامج.
    await (database.delete(
      database.trainingPrograms,
    )..where((table) => table.id.equals('test_program'))).go();

    // 6. التأكد من حذف جميع البيانات التابعة تلقائياً.
    expect(await database.select(database.trainingPrograms).get(), isEmpty);
    expect(await database.select(database.programExercises).get(), isEmpty);
    expect(await database.select(database.programSets).get(), isEmpty);
  });
  test('deletes workout exercises and sets when session is deleted', () async {
    // 1. إنشاء جلسة تمرين.
    await database
        .into(database.workoutSessions)
        .insert(
          WorkoutSessionsCompanion.insert(
            id: 'test_session',
            type: 'free',
            startTime: DateTime(2026, 1, 1, 10),
            endTime: DateTime(2026, 1, 1, 11),
          ),
        );

    // 2. إضافة تمرين تابع للجلسة.
    await database
        .into(database.workoutExercises)
        .insert(
          WorkoutExercisesCompanion.insert(
            id: 'test_workout_exercise',
            sessionId: 'test_session',
            exerciseId: 'bench_press',
            exerciseName: 'ضغط الصدر',
            muscleGroup: 'الصدر',
            exerciseOrder: 1,
          ),
        );

    // 3. إضافة مجموعة تابعة للتمرين.
    await database
        .into(database.workoutSets)
        .insert(
          WorkoutSetsCompanion.insert(
            id: 'test_workout_set',
            workoutExerciseId: 'test_workout_exercise',
            setNumber: 1,
            weight: 20,
            reps: 10,
            isCompleted: true,
          ),
        );

    // 4. التأكد من وجود البيانات.
    expect(await database.select(database.workoutSessions).get(), hasLength(1));
    expect(
      await database.select(database.workoutExercises).get(),
      hasLength(1),
    );
    expect(await database.select(database.workoutSets).get(), hasLength(1));

    // 5. حذف الجلسة.
    await (database.delete(
      database.workoutSessions,
    )..where((table) => table.id.equals('test_session'))).go();

    // 6. التأكد من حذف التمارين والمجموعات التابعة.
    expect(await database.select(database.workoutSessions).get(), isEmpty);
    expect(await database.select(database.workoutExercises).get(), isEmpty);
    expect(await database.select(database.workoutSets).get(), isEmpty);
  });
  test(
    'migrates database from version 2 to 3 without losing programs',
    () async {
      final tempDirectory = await Directory.systemTemp.createTemp(
        'fitforge_migration_test_',
      );

      final databaseFile = File(
        '${tempDirectory.path}${Platform.pathSeparator}test.sqlite',
      );

      AppDatabase? upgradeDatabase;

      try {
        // 1. إنشاء قاعدة بيانات بالإصدار الحالي.
        upgradeDatabase = AppDatabase(NativeDatabase(databaseFile));

        // 2. إضافة برنامج تدريبي.
        await upgradeDatabase
            .into(upgradeDatabase.trainingPrograms)
            .insert(
              TrainingProgramsCompanion.insert(
                id: 'migration_program',
                nameAr: 'برنامج الترقية',
                nameEn: 'Migration Program',
                descriptionAr: 'اختبار الترقية',
                descriptionEn: 'Migration Test',
                levelAr: 'مبتدئ',
                levelEn: 'Beginner',
                durationWeeks: 4,
                category: 0,
                type: 'custom',
              ),
            );

        // 3. محاكاة قاعدة بيانات الإصدار الثاني.
        await upgradeDatabase.customStatement('DROP TABLE training_cycle');

        await upgradeDatabase.customStatement('PRAGMA user_version = 2');

        // 4. إغلاق قاعدة البيانات القديمة.
        await upgradeDatabase.close();
        upgradeDatabase = null;

        // 5. فتح قاعدة البيانات باستخدام الإصدار الثالث.
        final upgradedDatabase = AppDatabase(NativeDatabase(databaseFile));

        upgradeDatabase = upgradedDatabase;

        // 6. التأكد من بقاء البرنامج القديم.
        final programs = await upgradedDatabase
            .select(upgradedDatabase.trainingPrograms)
            .get();

        expect(programs, hasLength(1));
        expect(programs.first.id, 'migration_program');

        // 7. التأكد من إنشاء جدول دورة التدريب.
        final cycleTable = await upgradedDatabase
            .customSelect(
              "SELECT name FROM sqlite_master "
              "WHERE type = 'table' AND name = 'training_cycle'",
            )
            .get();

        expect(cycleTable, hasLength(1));

        // 8. التأكد من إمكانية استخدام الجدول الجديد.
        await upgradedDatabase
            .into(upgradedDatabase.trainingCycle)
            .insert(
              TrainingCycleCompanion.insert(
                id: const Value(1),
                startDate: DateTime(2026, 1, 1),
              ),
            );

        final cycles = await upgradedDatabase
            .select(upgradedDatabase.trainingCycle)
            .get();

        expect(cycles, hasLength(1));
        expect(cycles.first.targetDays, 28);
      } finally {
        await upgradeDatabase?.close();
        await tempDirectory.delete(recursive: true);
      }
    },
  );
  test('migrates database from version 1 to 3', () async {
    final tempDirectory = await Directory.systemTemp.createTemp(
      'fitforge_v1_migration_',
    );

    final databaseFile = File(
      '${tempDirectory.path}${Platform.pathSeparator}test.sqlite',
    );

    AppDatabase? testDatabase;

    try {
      testDatabase = AppDatabase(NativeDatabase(databaseFile));

      // محاكاة قاعدة بيانات الإصدار الأول.
      await testDatabase.customStatement('DROP TABLE program_sets');
      await testDatabase.customStatement('DROP TABLE program_exercises');
      await testDatabase.customStatement('DROP TABLE training_programs');
      await testDatabase.customStatement('DROP TABLE training_cycle');

      await testDatabase.customStatement('PRAGMA user_version = 1');

      await testDatabase.close();
      testDatabase = null;

      // فتح قاعدة البيانات لتشغيل الترحيلات.
      testDatabase = AppDatabase(NativeDatabase(databaseFile));

      final tables = await testDatabase
          .customSelect("SELECT name FROM sqlite_master WHERE type = 'table'")
          .get();

      final tableNames = tables
          .map((row) => row.data['name'] as String)
          .toSet();

      expect(tableNames, contains('training_programs'));
      expect(tableNames, contains('program_exercises'));
      expect(tableNames, contains('program_sets'));
      expect(tableNames, contains('training_cycle'));
    } finally {
      await testDatabase?.close();
      await tempDirectory.delete(recursive: true);
    }
  });
  test('migrates version 3 data to version 4 without data loss', () async {
    final tempDirectory = await Directory.systemTemp.createTemp(
      'fitforge_v3_migration_',
    );

    final databaseFile = File(
      '${tempDirectory.path}${Platform.pathSeparator}test.sqlite',
    );

    AppDatabase? testDatabase;

    try {
      // إنشاء قاعدة البيانات وتجهيز السجلات الأساسية.
      testDatabase = AppDatabase(NativeDatabase(databaseFile));

      await testDatabase
          .into(testDatabase.workoutSessions)
          .insert(
            WorkoutSessionsCompanion.insert(
              id: 'legacy_session',
              type: 'free',
              startTime: DateTime(2026, 1, 1, 10),
              endTime: DateTime(2026, 1, 1, 11),
            ),
          );

      await testDatabase
          .into(testDatabase.workoutExercises)
          .insert(
            WorkoutExercisesCompanion.insert(
              id: 'legacy_workout_exercise',
              sessionId: 'legacy_session',
              exerciseId: 'bench_press',
              exerciseName: 'ضغط الصدر',
              muscleGroup: 'الصدر',
              exerciseOrder: 1,
            ),
          );

      await testDatabase
          .into(testDatabase.trainingPrograms)
          .insert(
            TrainingProgramsCompanion.insert(
              id: 'legacy_program',
              nameAr: 'برنامج قديم',
              nameEn: 'Legacy Program',
              descriptionAr: 'وصف',
              descriptionEn: 'Description',
              levelAr: 'مبتدئ',
              levelEn: 'Beginner',
              durationWeeks: 4,
              category: 0,
              type: 'custom',
            ),
          );

      await testDatabase
          .into(testDatabase.programExercises)
          .insert(
            ProgramExercisesCompanion.insert(
              id: 'legacy_program_exercise',
              programId: 'legacy_program',
              exerciseId: 'bench_press',
              exerciseOrder: 1,
            ),
          );

      // حذف الجداول الجديدة وإعادة إنشائها دون قيود CHECK
      // لمحاكاة مخطط الإصدار الثالث.
      await testDatabase.customStatement('DROP TABLE workout_sets');
      await testDatabase.customStatement('DROP TABLE program_sets');
      await testDatabase.customStatement('DROP TABLE training_cycle');

      await testDatabase.customStatement('''
      CREATE TABLE workout_sets (
        id TEXT NOT NULL PRIMARY KEY,
        workout_exercise_id TEXT NOT NULL
          REFERENCES workout_exercises(id) ON DELETE CASCADE,
        set_number INTEGER NOT NULL,
        weight REAL NOT NULL,
        reps INTEGER NOT NULL,
        is_completed INTEGER NOT NULL
      )
    ''');

      await testDatabase.customStatement('''
      CREATE TABLE program_sets (
        id TEXT NOT NULL PRIMARY KEY,
        program_exercise_id TEXT NOT NULL
          REFERENCES program_exercises(id) ON DELETE CASCADE,
        set_number INTEGER NOT NULL,
        target_weight REAL NOT NULL,
        target_reps INTEGER NOT NULL
      )
    ''');

      await testDatabase.customStatement('''
      CREATE TABLE training_cycle (
        id INTEGER NOT NULL PRIMARY KEY,
        start_date INTEGER NOT NULL,
        target_days INTEGER NOT NULL DEFAULT 28
      )
    ''');

      // إدخال بيانات قديمة في الجداول الثلاثة.
      await testDatabase.customStatement('''
      INSERT INTO workout_sets VALUES (
        'legacy_workout_set',
        'legacy_workout_exercise',
        1, 25.5, 8, 1
      )
    ''');

      await testDatabase.customStatement('''
      INSERT INTO program_sets VALUES (
        'legacy_program_set',
        'legacy_program_exercise',
        1, 30.0, 10
      )
    ''');

      await testDatabase.customStatement(
        'INSERT INTO training_cycle VALUES (1, ${DateTime(2026, 1, 1).millisecondsSinceEpoch}, 28)',
      );

      // محاكاة الإصدار الثالث.
      await testDatabase.customStatement('PRAGMA user_version = 3');

      await testDatabase.close();
      testDatabase = null;

      // فتح قاعدة البيانات وتشغيل الترحيل إلى الإصدار الرابع.
      testDatabase = AppDatabase(NativeDatabase(databaseFile));

      final workoutSets = await testDatabase
          .select(testDatabase.workoutSets)
          .get();

      final programSets = await testDatabase
          .select(testDatabase.programSets)
          .get();

      final cycles = await testDatabase
          .select(testDatabase.trainingCycle)
          .get();

      // التأكد من الحفاظ على البيانات.
      expect(workoutSets, hasLength(1));
      expect(workoutSets.first.id, 'legacy_workout_set');
      expect(workoutSets.first.weight, 25.5);
      expect(workoutSets.first.reps, 8);

      expect(programSets, hasLength(1));
      expect(programSets.first.id, 'legacy_program_set');
      expect(programSets.first.targetWeight, 30.0);
      expect(programSets.first.targetReps, 10);

      expect(cycles, hasLength(1));
      expect(cycles.first.id, 1);
      expect(cycles.first.targetDays, 28);

      // التأكد من بقاء الجداول الأساسية.
      expect(
        await testDatabase.select(testDatabase.workoutExercises).get(),
        hasLength(1),
      );

      expect(
        await testDatabase.select(testDatabase.programExercises).get(),
        hasLength(1),
      );
    } finally {
      await testDatabase?.close();
      await tempDirectory.delete(recursive: true);
    }
  });
  test('rejects invalid values using database CHECK constraints', () async {
    // إنشاء جلسة وتمرين لاستخدامهما في اختبار WorkoutSets.
    await database
        .into(database.workoutSessions)
        .insert(
          WorkoutSessionsCompanion.insert(
            id: 'check_session',
            type: 'free',
            startTime: DateTime(2026, 1, 1, 10),
            endTime: DateTime(2026, 1, 1, 11),
          ),
        );

    await database
        .into(database.workoutExercises)
        .insert(
          WorkoutExercisesCompanion.insert(
            id: 'check_workout_exercise',
            sessionId: 'check_session',
            exerciseId: 'bench_press',
            exerciseName: 'ضغط الصدر',
            muscleGroup: 'الصدر',
            exerciseOrder: 1,
          ),
        );

    // إنشاء برنامج وتمرين لاستخدامهما في اختبار ProgramSets.
    await database
        .into(database.trainingPrograms)
        .insert(
          TrainingProgramsCompanion.insert(
            id: 'check_program',
            nameAr: 'برنامج اختبار',
            nameEn: 'Test Program',
            descriptionAr: 'وصف',
            descriptionEn: 'Description',
            levelAr: 'مبتدئ',
            levelEn: 'Beginner',
            durationWeeks: 4,
            category: 0,
            type: 'custom',
          ),
        );

    await database
        .into(database.programExercises)
        .insert(
          ProgramExercisesCompanion.insert(
            id: 'check_program_exercise',
            programId: 'check_program',
            exerciseId: 'bench_press',
            exerciseOrder: 1,
          ),
        );

    // WorkoutSets: رقم المجموعة لا يمكن أن يكون صفرًا.
    await expectLater(
      database
          .into(database.workoutSets)
          .insert(
            WorkoutSetsCompanion.insert(
              id: 'invalid_set_number',
              workoutExerciseId: 'check_workout_exercise',
              setNumber: 0,
              weight: 20,
              reps: 10,
              isCompleted: false,
            ),
          ),
      throwsA(anything),
    );

    // WorkoutSets: الوزن لا يمكن أن يكون سالبًا.
    await expectLater(
      database
          .into(database.workoutSets)
          .insert(
            WorkoutSetsCompanion.insert(
              id: 'invalid_weight',
              workoutExerciseId: 'check_workout_exercise',
              setNumber: 1,
              weight: -5,
              reps: 10,
              isCompleted: false,
            ),
          ),
      throwsA(anything),
    );

    // WorkoutSets: التكرارات لا يمكن أن تكون سالبة.
    await expectLater(
      database
          .into(database.workoutSets)
          .insert(
            WorkoutSetsCompanion.insert(
              id: 'invalid_reps',
              workoutExerciseId: 'check_workout_exercise',
              setNumber: 1,
              weight: 20,
              reps: -5,
              isCompleted: false,
            ),
          ),
      throwsA(anything),
    );

    // ProgramSets: رقم المجموعة لا يمكن أن يكون صفرًا.
    await expectLater(
      database
          .into(database.programSets)
          .insert(
            ProgramSetsCompanion.insert(
              id: 'invalid_program_set_number',
              programExerciseId: 'check_program_exercise',
              setNumber: 0,
              targetWeight: 20,
              targetReps: 10,
            ),
          ),
      throwsA(anything),
    );

    // ProgramSets: الوزن المستهدف لا يمكن أن يكون سالبًا.
    await expectLater(
      database
          .into(database.programSets)
          .insert(
            ProgramSetsCompanion.insert(
              id: 'invalid_target_weight',
              programExerciseId: 'check_program_exercise',
              setNumber: 1,
              targetWeight: -5,
              targetReps: 10,
            ),
          ),
      throwsA(anything),
    );

    // ProgramSets: التكرارات المستهدفة لا يمكن أن تكون سالبة.
    await expectLater(
      database
          .into(database.programSets)
          .insert(
            ProgramSetsCompanion.insert(
              id: 'invalid_target_reps',
              programExerciseId: 'check_program_exercise',
              setNumber: 1,
              targetWeight: 20,
              targetReps: -5,
            ),
          ),
      throwsA(anything),
    );

    // TrainingCycle: مدة الدورة يجب أن تكون أكبر من صفر.
    await expectLater(
      database
          .into(database.trainingCycle)
          .insert(
            TrainingCycleCompanion.insert(
              id: const Value(10),
              startDate: DateTime(2026, 1, 1),
              targetDays: const Value(0),
            ),
          ),
      throwsA(anything),
    );
  });
}
