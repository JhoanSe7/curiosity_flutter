import 'package:curiosity_flutter/features/questionaries/data/models/question_data_type.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/question_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';

class QuestionaryState {
  final List<QuestionModel> questions;
  final QuestionDataType? questionType;
  final QuizModel? quiz;
  final QuestionModel? question;

  QuestionaryState({
    this.questions = const [],
    this.questionType,
    this.quiz,
    this.question,
  });

  QuestionaryState copyWith({
    List<QuestionModel>? questions,
    QuestionDataType? questionType,
    QuizModel? quiz,
    QuestionModel? question,
  }) =>
      QuestionaryState(
        questions: questions ?? this.questions,
        questionType: questionType ?? this.questionType,
        quiz: quiz ?? this.quiz,
        question: question ?? this.question,
      );
}
