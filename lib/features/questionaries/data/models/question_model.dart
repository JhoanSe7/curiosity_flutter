import 'option_model.dart';

class QuestionModel {
  String? type;
  String? question;
  int? timeLimit;
  List<OptionModel>? options;
  bool? correctAnswer;
  String? correctAnswerText;
  String? sourceUrl;
  String? explanation;

  QuestionModel({
    this.type,
    this.question,
    this.timeLimit,
    this.options,
    this.correctAnswer,
    this.correctAnswerText,
    this.sourceUrl,
    this.explanation,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
        type: json["type"],
        question: json["question"],
        timeLimit: json["timeLimit"],
        options: json["options"],
        correctAnswer: json["correctAnswer"],
        correctAnswerText: json["correctAnswerText"],
        sourceUrl: json["sourceUrl"],
        explanation: json["explanation"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "question": question,
        "timeLimit": timeLimit,
        "options": options,
        "correctAnswer": correctAnswer,
        "correctAnswerText": correctAnswerText,
        "sourceUrl": sourceUrl,
        "explanation": explanation,
      };
}
