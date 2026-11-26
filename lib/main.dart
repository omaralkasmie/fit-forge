import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';
import 'routes/app_router.dart';

import 'services/workout_manager.dart';
import 'services/workout_scope.dart';
import 'services/training_program_manager.dart';
import 'services/training_program_scope.dart';

import 'data/local/app_database.dart';

import 'repositories/workout_repository.dart';
import 'repositories/training_program_repository.dart';
import 'repositories/training_cycle_repository.dart';
import 'repositories/active_workout_repository.dart';


void main() {
  runApp(const FitForgeApp());
}
class FitForgeApp extends StatefulWidget {
  final AppDatabase? database;

  const FitForgeApp({
    super.key,
    this.database,
  });

  @override
  State<FitForgeApp> createState() => _FitForgeAppState();
}

class _FitForgeAppState extends State<FitForgeApp> {
  late final AppDatabase _database;

  late final WorkoutRepository _workoutRepository;
  late ActiveWorkoutRepository _activeWorkoutRepository;
  late final TrainingProgramRepository _trainingProgramRepository;

  late final WorkoutManager _workoutManager;
  late final TrainingProgramManager _trainingProgramManager;
  late TrainingCycleRepository _trainingCycleRepository;
  late Future<void> _workoutInitialization;

@override
void initState() {
  super.initState();

  _database = widget.database ?? AppDatabase();

  _workoutRepository = WorkoutRepository(_database);
  _activeWorkoutRepository = ActiveWorkoutRepository(_database);
  _trainingProgramRepository = TrainingProgramRepository(_database);
  _trainingCycleRepository = TrainingCycleRepository(_database);


  _workoutManager = WorkoutManager(
  workoutRepository: _workoutRepository,
  trainingCycleRepository: _trainingCycleRepository,
  activeWorkoutRepository: _activeWorkoutRepository,
);

_workoutInitialization = _workoutManager.restoreActiveWorkout();

  _trainingProgramManager = TrainingProgramManager(
    _trainingProgramRepository,
  );

  _trainingProgramManager.loadPrograms();
}

  @override
  void dispose() {
    _workoutManager.dispose();
    _trainingProgramManager.dispose();
    _database.close();

    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return FutureBuilder<void>(
    future: _workoutInitialization,
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return MaterialApp(
          home: Scaffold(
            backgroundColor: const Color(0xFF0B0B12),
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF9B5CFF),
              ),
            ),
          ),
        );
      }

      if (snapshot.hasError) {
        return MaterialApp(
          home: Scaffold(
            backgroundColor: const Color(0xFF0B0B12),
            body: Center(
              child: Text(
                'حدث خطأ أثناء استعادة جلسة التمرين',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      }

      return WorkoutScope(
        notifier: _workoutManager,
        child: TrainingProgramScope(
          notifier: _trainingProgramManager,
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            onGenerateTitle: (context) =>
                AppLocalizations.of(context)!.appName,
            theme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xFF0B0B12),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF9B5CFF),
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: const Locale('ar'),
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: appRouter,
          ),
        ),
      );
    },
  );
}
}