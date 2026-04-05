import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:curiosity_flutter/features/home/data/models/session_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';
import 'package:curiosity_flutter/features/room/data/models/quiz_result_model.dart';

import 'widgets/bottom_bar_widget.dart';

class HomeState {
  final HomeId menuId;
  final UserModel? user;
  final List<QuizModel> quizzes;
  final List<QuizResultModel> results;
  final List<SessionModel> sessions;
  final bool isLoading;
  final QuizResultModel? resultSelected;
  final SessionModel? sessionSelected;
  final bool enableScroll;

  HomeState({
    this.menuId = HomeId.init,
    this.user,
    this.quizzes = const [],
    this.results = const [],
    this.sessions = const [],
    this.isLoading = true,
    this.resultSelected,
    this.sessionSelected,
    this.enableScroll = true,
  });

  HomeState copyWith({
    HomeId? menuId,
    UserModel? user,
    List<QuizModel>? quizzes,
    List<QuizResultModel>? results,
    List<SessionModel>? sessions,
    bool? isLoading,
    QuizResultModel? resultSelected,
    SessionModel? sessionSelected,
    bool? enableScroll,
  }) =>
      HomeState(
        menuId: menuId ?? this.menuId,
        user: user ?? this.user,
        quizzes: quizzes ?? this.quizzes,
        results: results ?? this.results,
        sessions: sessions ?? this.sessions,
        isLoading: isLoading ?? this.isLoading,
        resultSelected: resultSelected ?? this.resultSelected,
        sessionSelected: sessionSelected ?? this.sessionSelected,
        enableScroll: enableScroll ?? this.enableScroll,
      );
}
