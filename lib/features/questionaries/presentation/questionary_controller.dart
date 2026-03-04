import 'package:curiosity_flutter/core/design/tokens/colors.dart';
import 'package:curiosity_flutter/core/di/injection.dart';
import 'package:curiosity_flutter/core/utils/util_processor.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/generate_quiz_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/question_data_type.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/question_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/question_type.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/room_model.dart';
import 'package:curiosity_flutter/features/questionaries/domain/use_cases/questionaries_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'questionary_state.dart';

class QuestionaryController extends StateNotifier<QuestionaryState> {
  QuestionaryController(this.useCase) : super(QuestionaryState());

  final QuestionariesUseCase useCase;

  List<QuestionDataType> element = [
    QuestionDataType(
      "Selección Múltiple",
      "Varias respuestas correctas",
      colors.gradientPurple,
      Icons.check_box_outlined,
      QuestionType.MULTIPLE_SELECTION,
    ),
    QuestionDataType(
      "Única Selección",
      "Solo una respuesta correcta",
      colors.gradientBlue,
      Icons.circle_outlined,
      QuestionType.SINGLE_SELECTION,
    ),
    QuestionDataType(
      "Rellenar Espacios",
      "Completar la frase",
      colors.gradientYellow,
      Icons.square_outlined,
      QuestionType.FILL_IN_THE_BLANK,
    ),
    QuestionDataType(
      "Verdadero o Falso",
      "Pregunta de si o no",
      colors.gradientPrimary,
      Icons.help_outline_sharp,
      QuestionType.TRUE_FALSE,
    ),
    QuestionDataType(
      "Respuesta Abierta",
      "Respuesta libre",
      colors.gradientMagenta,
      Icons.description_outlined,
      QuestionType.OPEN_ANSWER,
    ),
  ];

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
    final result = await useCase.createQuiz(data: data);
    return result.fold(
      (e) => processError(context, error: e.message) ?? QuizModel(),
      (data) => data,
    );
  }

  /// Genera un quiz con IA
  Future<QuizModel> generateQuiz(BuildContext context, {required GenerateQuizModel data}) async {
    final result = await useCase.generateQuiz(data: data);
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
    final result = await useCase.createRoom(data: data);
    return result.fold(
      (e) => processError(context, error: e.message) ?? RoomModel(),
      (data) => data,
    );
  }
}

final questionaryController =
    StateNotifierProvider<QuestionaryController, QuestionaryState>((ref) => QuestionaryController(
          getIt.get(),
        ));
