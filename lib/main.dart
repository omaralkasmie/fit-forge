import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';
import 'routes/app_router.dart';

import 'services/workout_manager.dart';
import 'services/workout_scope.dart';
import 'services/training_program_manager.dart';
import 'services/training_program_scope.dart';
import 'services/user_manager.dart';
import 'services/user_scope.dart';

import 'data/local/app_database.dart' hide UserProfile;

import 'repositories/workout_repository.dart';
import 'repositories/training_program_repository.dart';
import 'repositories/training_cycle_repository.dart';
import 'repositories/active_workout_repository.dart';
import 'repositories/user_repository.dart';

void main() {
  runApp(const FitForgeApp());
}

class FitForgeApp extends StatefulWidget {
  final AppDatabase? database;

  const FitForgeApp({super.key, this.database});

  @override
  State<FitForgeApp> createState() => _FitForgeAppState();
}

class _FitForgeAppState extends State<FitForgeApp> {
  late final AppDatabase _database;

  late final WorkoutRepository _workoutRepository;
  late final ActiveWorkoutRepository _activeWorkoutRepository;
  late final TrainingProgramRepository _trainingProgramRepository;
  late final TrainingCycleRepository _trainingCycleRepository;
  late final UserRepository _userRepository;

  late final WorkoutManager _workoutManager;
  late final TrainingProgramManager _trainingProgramManager;
  late final UserManager _userManager;

  late final Future<void> _workoutInitialization;
  late final Future<void> _userInitialization;
  late final Future<void> _appInitialization;

  @override
  void initState() {
    super.initState();

    // Database
    _database = widget.database ?? AppDatabase();

    // Repositories
    _workoutRepository = WorkoutRepository(_database);
    _activeWorkoutRepository = ActiveWorkoutRepository(_database);
    _trainingProgramRepository = TrainingProgramRepository(_database);
    _trainingCycleRepository = TrainingCycleRepository(_database);
    _userRepository = UserRepository(_database);
    _userManager = UserManager(_userRepository);

    // Managers
    _workoutManager = WorkoutManager(
      workoutRepository: _workoutRepository,
      trainingCycleRepository: _trainingCycleRepository,
      activeWorkoutRepository: _activeWorkoutRepository,
    );

    _trainingProgramManager = TrainingProgramManager(
      _trainingProgramRepository,
    );

    // Initialization
    _workoutInitialization = _workoutManager.restoreActiveWorkout();

    _userInitialization = _userManager.loadProfile();

    _appInitialization = Future.wait([
      _workoutInitialization,
      _userInitialization,
    ]).then((_) {});

    _trainingProgramManager.loadPrograms();
  }

  @override
  void dispose() {
    _workoutManager.dispose();
    _trainingProgramManager.dispose();
    _userManager.dispose();
    _database.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _appInitialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            home: Scaffold(
              backgroundColor: const Color(0xFF0B0B12),
              body: const Center(
                child: CircularProgressIndicator(color: Color(0xFF9B5CFF)),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              backgroundColor: const Color(0xFF0B0B12),
              body: const Center(
                child: Text(
                  'حدث خطأ أثناء تهيئة التطبيق',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        }

        return UserScope(
          notifier: _userManager,
          child: WorkoutScope(
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
          ),
        );
      },
    );
  }
}
