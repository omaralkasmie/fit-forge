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
  ],
);
