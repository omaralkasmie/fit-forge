import 'package:go_router/go_router.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/home_screen.dart';

class AppRouter {
    static const login = '/login';
    static const signup = '/signup';
    static const home = '/home';

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
  ],
);