import 'package:curiosity_flutter/core/di/injection.dart';
import 'package:curiosity_flutter/core/utils/util_processor.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/question_data_type.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/question_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';
import 'package:curiosity_flutter/features/questionaries/domain/use_cases/questionaries_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'questionary_state.dart';

class QuestionaryController extends StateNotifier<QuestionaryState> {
  QuestionaryController(this.useCase) : super(QuestionaryState());

  final QuestionariesUseCase useCase;

  /// Agrega una pregunta al estado
  void addQuestion(QuestionModel question) {
    if (mounted) state = state.copyWith(questions: [...state.questions, question]);
  }

  /// Setea el valor de tipo de pregunta
  void setQuestionType(QuestionDataType type) {
    if (mounted) state = state.copyWith(questionType: type);
  }

  /// Elimina una pregunta del estado
  void deleteQuestion(QuestionModel q) {
    var index = state.questions.indexOf(q);
    if (index < 0) return;
    if (mounted) state = state.copyWith(questions: [...state.questions..removeAt(index)]);
  }

  /// Elimina todas las preguntas del estado
  void deleteAllQuestions() {
    if (mounted) state = state.copyWith(questions: []);
  }

  /// Crea un quiz
  Future<QuizModel> createQuiz(BuildContext context, {required QuizModel data}) async {
    final result = await useCase.createQuiz(data: data);
    return result.fold(
      (e) => processError(context, error: e.message) ?? QuizModel(),
      (data) => data,
    );
  }
}

final questionaryController =
    StateNotifierProvider<QuestionaryController, QuestionaryState>((ref) => QuestionaryController(
          getIt.get(),
        ));
