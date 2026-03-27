import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';
import 'package:curiosity_flutter/features/room/data/models/quiz_result_model.dart';

import 'widgets/bottom_bar_widget.dart';

class HomeState {
  final HomeId menuId;
  final UserModel? user;
  final List<QuizModel> quizzes;
  final List<QuizResultModel> results;
  final bool isLoading;
  final QuizResultModel? resultSelected;

  HomeState({
    this.menuId = HomeId.init,
    this.user,
    this.quizzes = const [],
    this.results = const [],
    this.isLoading = true,
    this.resultSelected,
  });

  HomeState copyWith({
    HomeId? menuId,
    UserModel? user,
    List<QuizModel>? quizzes,
    List<QuizResultModel>? results,
    bool? isLoading,
    QuizResultModel? resultSelected,
  }) =>
      HomeState(
        menuId: menuId ?? this.menuId,
        user: user ?? this.user,
        quizzes: quizzes ?? this.quizzes,
        results: results ?? this.results,
        isLoading: isLoading ?? this.isLoading,
        resultSelected: resultSelected ?? this.resultSelected,
      );
}
