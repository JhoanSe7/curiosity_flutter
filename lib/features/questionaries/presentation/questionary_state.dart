import 'package:curiosity_flutter/features/questionaries/data/models/question_data_type.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/question_model.dart';

class QuestionaryState {
  final List<QuestionModel> questions;
  final QuestionDataType? questionType;


  QuestionaryState({
    this.questions = const [],
    this.questionType,
  });

  QuestionaryState copyWith({
    List<QuestionModel>? questions,
    QuestionDataType? questionType,
  }) =>
      QuestionaryState(
        questions: questions ?? this.questions,
        questionType: questionType ?? this.questionType,
      );
}
