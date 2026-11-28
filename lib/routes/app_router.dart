import 'package:go_router/go_router.dart';

import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/home_screen.dart';
import '../screens/exercises_screen.dart';
import '../screens/chest_exercises_screen.dart';
import '../screens/programs_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/exercise_details_screen.dart';
import '../models/exercise.dart';
import '../screens/muscle_group_exercises_screen.dart';
import '../data/exercises/back_exercises.dart';
import '../l10n/app_localizations.dart';
import '../data/exercises/shoulder_exercises.dart';
import '../data/exercises/leg_exercises.dart';
import '../data/exercises/arms_exercises.dart';
import '../data/exercises/abs_exercises.dart';
import '../screens/workout_exercise_selection_screen.dart';
import '../screens/workout_setup_screen.dart';
import '../screens/active_workout_screen.dart';
import '../screens/workout_summary_screen.dart';
import '../screens/workout_history_screen.dart';
import '../screens/workout_details_screen.dart';
import '../models/training_program.dart';
import '../screens/program_details_screen.dart';
import '../screens/edit_profile_screen.dart';

class AppRouter {
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const exercises = '/exercises';
  static const chestExercises = '/chest-exercises';
  static const programs = '/programs';
  static const progress = '/progress';
  static const profile = '/profile';
  static const exerciseDetails = '/exercise-details';
  static const backExercises = '/back_exercises';
  static const shoulderExercises = '/shoulder-exercises';
  static const legExercises = '/leg_exercises';
  static const armsExercises = '/arms-exercises';
  static const absExercises = '/abs_exercises';
  static const workoutExerciseSelection = '/workout-exercise-selection';
  static const workoutSetup = '/workout-setup';
  static const activeWorkout = '/active-workout';
  static const workoutSummary = '/workout-summary';
  static const workoutHistory = '/workout-history';
  static const workoutDetails ='/workout-details';
  static const programDetails = '/program-details';
  static const editProfile = '/edit-profile';
  
}

final appRouter = GoRouter(
  initialLocation: AppRouter.login,
  routes: [
    GoRoute(
      path: AppRouter.login,
      builder: (context, state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: AppRouter.signup,
      builder: (context, state) {
        return const SignupScreen();
      },
    ),

    GoRoute(
      path: AppRouter.home,
      builder: (context, state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: AppRouter.exercises,
      builder: (context, state) => const ExercisesScreen(),
    ),
    GoRoute(
      path: AppRouter.chestExercises,
      builder: (context, state) => const ChestExercisesScreen(),
    ),
    GoRoute(
      path: AppRouter.programs,
      builder: (context, state) => const ProgramsScreen(),
    ),
    GoRoute(
  path: AppRouter.programDetails,
  builder: (context, state) {
    final program = state.extra as TrainingProgram;

    return ProgramDetailsScreen(
      program: program,
    );
  },
),
    GoRoute(
      path: AppRouter.progress,
      builder: (context, state) => const ProgressScreen(),
    ),
    GoRoute(
      path: AppRouter.profile,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: AppRouter.exerciseDetails,
      builder: (context, state) {
        final exercise = state.extra as Exercise;
        return ExerciseDetailsScreen(exercise: exercise);
      },
    ),
    GoRoute(
      path: AppRouter.backExercises,
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;

        return MuscleGroupExercisesScreen(
          title: l10n.backExercises,
          bannerTitle: l10n.backExercises,
          bannerSubtitle: l10n.backExercises,
          exercises: backExercises,
        );
      },
    ),
    GoRoute(
      path: AppRouter.shoulderExercises,
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;

        return MuscleGroupExercisesScreen(
          title: l10n.shoulderExercises,
          bannerTitle: l10n.shoulderExercises,
          bannerSubtitle: l10n.shoulderExercises,
          exercises: shoulderExercises,
        );
      },
    ),
    GoRoute(
      path: AppRouter.legExercises,
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;

        return MuscleGroupExercisesScreen(
          title: l10n.legExercises,
          bannerTitle: l10n.legExercises,
          bannerSubtitle: l10n.legExercises,
          exercises: legExercises,
        );
      },
    ),
    GoRoute(
      path: AppRouter.armsExercises,
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;

        return MuscleGroupExercisesScreen(
          title: l10n.armExercises,
          bannerTitle: l10n.armExercises,
          bannerSubtitle: l10n.armExercises,
          exercises: armsExercises,
        );
      },
    ),
    GoRoute(
      path: AppRouter.absExercises,
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;

        return MuscleGroupExercisesScreen(
          title: l10n.absExercises,
          bannerTitle: l10n.absExercises,
          bannerSubtitle: l10n.absExercises,
          exercises: absExercises,
        );
      },
    ),
    GoRoute(
      path: AppRouter.workoutExerciseSelection,
      builder: (context, state) {
        final selectedExercises =
            state.extra as List<Exercise>? ?? const <Exercise>[];

        return WorkoutExerciseSelectionScreen(
          initialSelectedExercises: selectedExercises,
        );
      },
    ),
    GoRoute(
      path: AppRouter.workoutSetup,
      builder: (context, state) => const WorkoutSetupScreen(),
    ),
    GoRoute(
      path: AppRouter.activeWorkout,
      builder: (context, state) => const ActiveWorkoutScreen(),
    ),
    GoRoute(
      path: AppRouter.workoutSummary,
      builder: (context, state) => const WorkoutSummaryScreen(),
    ),
    GoRoute(
      path: AppRouter.workoutHistory,
      builder: (context, state) => const WorkoutHistoryScreen(),
    ),
    GoRoute(
      path: AppRouter.workoutDetails,
      builder: (context, state) {
        final sessionId = state.extra as String;
        return WorkoutDetailsScreen(sessionId: sessionId);
      },
    ),
    GoRoute(
      path: AppRouter.editProfile,
      builder: (context, state) => const EditProfileScreen(),
    ),
  ],
);
