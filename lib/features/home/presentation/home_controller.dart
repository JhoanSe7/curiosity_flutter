import 'package:curiosity_flutter/core/di/injection.dart';
import 'package:curiosity_flutter/core/utils/util_processor.dart';
import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:curiosity_flutter/features/home/data/models/support_model.dart';
import 'package:curiosity_flutter/features/home/domain/use_cases/home_use_case.dart';
import 'package:curiosity_flutter/features/home/presentation/home_state.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/bottom_bar_widget.dart';

class HomeController extends StateNotifier<HomeState> {
  HomeController(this.useCase) : super(HomeState());

  final HomeUseCase useCase;

  ///
  void setMenuIndex(HomeId id) {
    state = state.copyWith(menuId: id);
  }

  ///
  void setUser({required UserModel? data}) {
    if (mounted) state = state.copyWith(user: data);
  }

  ///
  Future<List<QuizModel>> getQuizzes(BuildContext context, {required String userId}) async {
    final result = await execute<List<QuizModel>>(context, useCase.getQuizzes(userId: userId));
    return result.fold(
      (e) => processError(context, error: e.message) ?? [],
      (res) => res,
    );
  }

  ///
  Future<void> loadQuizzes(BuildContext context) async {
    var userId = state.user?.id ?? "";
    final res = await getQuizzes(context, userId: userId);
    if (mounted) state = state.copyWith(quizzes: res);
  }

  ///
  void setLoading(bool value) {
    if (mounted) state = state.copyWith(isLoading: value);
  }

  ///
  void sendReport({required SupportModel data}) {
    //TODO: Implementar envio de reporte
  }

  ///
  void addQuiz(QuizModel quiz) {
    if (mounted) state = state.copyWith(quizzes: [...state.quizzes, quiz]);
  }

  ///
  void deleteQuiz(QuizModel q) {
    state.quizzes.removeWhere((e) => e.id == q.id);
    if (mounted) state = state.copyWith(quizzes: state.quizzes);
  }
}

final homeController = StateNotifierProvider<HomeController, HomeState>((ref) => HomeController(
      getIt.get(),
    ));
