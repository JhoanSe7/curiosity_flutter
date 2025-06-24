import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_page.dart';

class Route {
  static String root = "/";
  static String home = "/home";
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: Route.home,
      builder: (context, state) => const HomePage(),
    ),
  ],
);
