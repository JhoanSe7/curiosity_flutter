import 'package:curiosity_flutter/features/auth/presentation/sign_in/sign_in_page.dart';
import 'package:curiosity_flutter/features/auth/presentation/sign_up/sign_up_page.dart';
import 'package:curiosity_flutter/features/home/presentation/home_page.dart';
import 'package:curiosity_flutter/features/home/presentation/widgets/profile/about_view.dart';
import 'package:curiosity_flutter/features/home/presentation/widgets/profile/info_profile_view.dart';
import 'package:curiosity_flutter/features/home/presentation/widgets/profile/notifications_view.dart';
import 'package:curiosity_flutter/features/home/presentation/widgets/profile/support_view.dart';
import 'package:curiosity_flutter/features/main/presentation/splash_page.dart';
import 'package:curiosity_flutter/features/questionaries/presentation/questionary_page.dart';
import 'package:curiosity_flutter/features/questionaries/presentation/widgets/create_question_view.dart';
import 'package:curiosity_flutter/features/questionaries/presentation/widgets/create_quiz_view.dart';
import 'package:curiosity_flutter/features/questionaries/presentation/widgets/generate_quiz_view.dart';
import 'package:curiosity_flutter/features/questionaries/presentation/widgets/quizzes_list_view.dart';
import 'package:curiosity_flutter/features/room/presentation/room_page.dart';
import 'package:curiosity_flutter/features/room/presentation/widgets/join_room_view.dart';
import 'package:curiosity_flutter/features/room/presentation/widgets/lobby_view.dart';
import 'package:curiosity_flutter/features/room/presentation/widgets/quiz_flow_view.dart';
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
  static String quizFlow = "/quiz-flow";
  static String infoProfile = "/info-profile";
  static String support = "/support";
  static String about = "/about";
  static String notifications = "/notifications";
  static String joinRoom = "/join-room";
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
      builder: (context, state) => const LobbyView(),
    ),
    GoRoute(
      path: Routes.quizzesList,
      builder: (context, state) => const QuizzesListView(),
    ),
    GoRoute(
      path: Routes.room,
      builder: (context, state) => const RoomPage(),
    ),
    GoRoute(
      path: Routes.quizFlow,
      builder: (context, state) => const QuizFlowView(),
    ),
    GoRoute(
      path: Routes.infoProfile,
      builder: (context, state) => const InfoProfileView(),
    ),
    GoRoute(
      path: Routes.support,
      builder: (context, state) => const SupportView(),
    ),
    GoRoute(
      path: Routes.about,
      builder: (context, state) => const AboutView(),
    ),
    GoRoute(
      path: Routes.notifications,
      builder: (context, state) => const NotificationsView(),
    ),
    GoRoute(
      path: Routes.joinRoom,
      builder: (context, state) => const JoinRoomView(),
    ),
  ],
);
