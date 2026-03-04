import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';

import 'widgets/bottom_bar_widget.dart';

class HomeState {
  final HomeId menuId;
  final UserModel? user;
  final List<QuizModel> quizzes;
  final bool isLoading;

  HomeState({
    this.menuId = HomeId.init,
    this.user,
    this.quizzes = const [],
    this.isLoading = true,
  });

  HomeState copyWith({
    HomeId? menuId,
    UserModel? user,
    List<QuizModel>? quizzes,
    bool? isLoading,
  }) =>
      HomeState(
        menuId: menuId ?? this.menuId,
        user: user ?? this.user,
        quizzes: quizzes ?? this.quizzes,
        isLoading: isLoading ?? this.isLoading,
      );
}
