import 'package:curiosity_flutter/features/auth/presentation/sign_in/sign_in_page.dart';
import 'package:curiosity_flutter/features/auth/presentation/sign_up/sign_up_page.dart';
import 'package:curiosity_flutter/features/home/presentation/home_page.dart';
import 'package:curiosity_flutter/features/main/presentation/splash_page.dart';
import 'package:curiosity_flutter/features/questionaries/presentation/questionary_page.dart';
import 'package:curiosity_flutter/features/questionaries/presentation/widgets/create_question_view.dart';
import 'package:curiosity_flutter/features/questionaries/presentation/widgets/create_quiz_view.dart';
import 'package:curiosity_flutter/features/questionaries/presentation/widgets/generate_quiz_view.dart';
import 'package:curiosity_flutter/features/questionaries/presentation/widgets/quizzes_list_view.dart';
import 'package:curiosity_flutter/features/room/presentation/lobby/lobby_page.dart';
import 'package:curiosity_flutter/features/room/presentation/room/room_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Routes {
  static String root = "/";
  static String signIn = "/sign-in";
  static String signUp = "/sign-up";
  static String home = "/home";
  static String questionary = "/questionary";
  static String createQuiz = "/create-quiz";
  static String createQuestion = "/create-question";
  static String generateQuiz = "/generate-quiz";
  static String lobby = "/lobby";
  static String quizzesList = "/quizzes-list";
  static String room = "/room";
}

final router = GoRouter(
  navigatorKey: navigatorKey,
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
      path: Routes.signUp,
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: Routes.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: Routes.questionary,
      builder: (context, state) => const QuestionaryPage(),
    ),
    GoRoute(
      path: Routes.createQuiz,
      builder: (context, state) => const CreateQuizView(),
    ),
    GoRoute(
      path: Routes.createQuestion,
      builder: (context, state) => const CreateQuestionView(),
    ),
    GoRoute(
      path: Routes.generateQuiz,
      builder: (context, state) => const GenerateQuizView(),
    ),
    GoRoute(
      path: Routes.lobby,
      builder: (context, state) => const LobbyScreen(),
    ),
    GoRoute(
      path: Routes.quizzesList,
      builder: (context, state) => const QuizzesListView(),
    ),
    GoRoute(
      path: Routes.room,
      builder: (context, state) => const RoomPage(),
    ),
  ],
);
