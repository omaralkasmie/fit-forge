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
  ],
);
