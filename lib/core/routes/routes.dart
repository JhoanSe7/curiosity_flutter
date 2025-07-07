import 'package:curiosity_flutter/features/auth/presentation/sign_in/sign_in_page.dart';
import 'package:curiosity_flutter/features/home/presentation/home_page.dart';
import 'package:curiosity_flutter/features/main/presentation/splash_page.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static String root = "/";
  static String signIn = "/sign-in";
  static String home = "/home";
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: Routes.root,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: Routes.signIn,
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: Routes.home,
      builder: (context, state) => const HomePage(),
    ),
  ],
);
