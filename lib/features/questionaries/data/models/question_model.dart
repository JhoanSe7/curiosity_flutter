import 'option_model.dart';

class QuestionModel {
  String? id;
  String? type;
  String? question;
  int? timeLimit;
  List<OptionModel>? options;
  bool? correctAnswer;
  String? correctAnswerText;
  String? sourceUrl;
  String? explanation;

  QuestionModel({
    this.id,
    this.type,
    this.question,
    this.timeLimit,
    this.options,
    this.correctAnswer,
    this.correctAnswerText,
    this.sourceUrl,
    this.explanation,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    List options = json["options"] != null && json["options"] is List ? json["options"] : [];
    return QuestionModel(
      id: json["id"],
      type: json["type"],
      question: json["question"],
      timeLimit: json["timeLimit"],
      options: options.asMap().entries.map((e) => OptionModel.fromJson(e.key, e.value)).toList(),
      correctAnswer: json["correctAnswer"],
      correctAnswerText: json["correctAnswerText"],
      sourceUrl: json["sourceUrl"],
      explanation: json["explanation"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
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
