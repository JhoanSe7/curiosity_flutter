import 'package:curiosity_flutter/core/di/injection.dart';
import 'package:curiosity_flutter/core/utils/util_processor.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/generate_quiz_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/question_data_type.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/question_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/room_model.dart';
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
    state.questions.removeAt(index);
    if (mounted) state = state.copyWith(questions: state.questions);
  }

  /// Elimina todas las preguntas del estado
  void clearAll() {
    if (mounted) state = state.copyWith(questions: [], quiz: QuizModel());
  }

  /// Crea un quiz
  Future<QuizModel> createQuiz(BuildContext context, {required QuizModel data}) async {
    final result = await execute<QuizModel>(context, useCase.createQuiz(data: data));
    return result.fold(
      (e) => processError(context, error: e.message) ?? QuizModel(),
      (data) => data,
    );
  }

  /// Genera un quiz con IA
  Future<QuizModel> generateQuiz(BuildContext context, {required GenerateQuizModel data}) async {
    final result = await execute<QuizModel>(context, useCase.generateQuiz(data: data));
    return result.fold(
      (e) => processError(context, error: e.message) ?? QuizModel(),
      (data) => data,
    );
  }

  /// Setea un quiz
  void setQuiz(QuizModel quiz) {
    if (mounted) state = state.copyWith(quiz: quiz);
  }

  /// Setea las preguntas
  void setQuestions(List<QuestionModel>? questions) {
    if (mounted) state = state.copyWith(questions: questions);
  }

  /// Setea la pregunta actual
  void setQuestion(QuestionModel question) {
    if (mounted) state = state.copyWith(question: question);
  }

  /// Borra los datos de la pregunta actual
  void clearQuestion() {
    if (mounted) state = state.copyWith(question: QuestionModel());
  }

  /// Crea una sala
  Future<RoomModel> createRoom(BuildContext context, {required RoomModel data}) async {
    final result = await execute<RoomModel>(context, useCase.createRoom(data: data));
    return result.fold(
      (e) => processError(context, error: e.message) ?? RoomModel(),
      (data) => data,
    );
  }

  /// Eliminar quiz
  Future<bool> deleteQuiz(BuildContext context, {required String quizId, required String userId}) async {
    final result = await execute<bool>(context, useCase.deleteQuiz(quizId: quizId, userId: userId));
    return result.fold(
      (e) => processError(context, error: e.message) ?? false,
      (data) => data,
    );
  }

  ///
  void addQuestionToQuiz(QuestionModel question) {
    addQuestion(question);
    removeQuestionToQuiz(question);
  }

  ///
  void removeQuestionToQuiz(QuestionModel question) {
    var quiz = state.quiz;
    if (quiz == null) return;
    var success = quiz.suggestQuestions?.remove(question);
    if (success ?? false) state = state.copyWith(quiz: quiz);
  }
}

final questionaryController = StateNotifierProvider<QuestionaryController, QuestionaryState>(
  (ref) => QuestionaryController(getIt.get()),
);
