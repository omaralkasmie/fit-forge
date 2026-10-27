import 'package:go_router/go_router.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/home_screen.dart';
import '../screens/exercises_screen.dart';
import '../screens/chest_exercises_screen.dart';

class AppRouter {
    static const login = '/login';
    static const signup = '/signup';
    static const home = '/home';
    static const exercises = '/exercises';
    static const chestExercises = '/chest-exercises';

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
        builder: (context, state){
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
  ],
);