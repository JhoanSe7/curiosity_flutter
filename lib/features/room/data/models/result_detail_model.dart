class ResultDetailModel {
  String? questionId;
  String? question;
  String? questionType;
  double? maxScore;
  double? score;
  bool? isCorrect;

  String? answer;
  String? answerIncorrect;
  String? answerCorrect;
  String? explanation;

  ResultDetailModel({
    this.questionId,
    this.question,
    this.questionType,
    this.maxScore,
    this.score,
    this.isCorrect,
    this.answer,
    this.answerIncorrect,
    this.answerCorrect,
    this.explanation,
  });

  factory ResultDetailModel.fromJson(Map<String, dynamic> json) => ResultDetailModel(
        questionId: json["questionId"],
        question: json["question"],
        questionType: json["questionType"],
        maxScore: json["maxScore"],
        score: json["score"],
        isCorrect: json["isCorrect"],
        answer: json["answer"],
        answerIncorrect: json["answerIncorrect"],
        answerCorrect: json["answerCorrect"],
        explanation: json["explanation"],
      );

  Map<String, dynamic> toJson() => {
        "questionId": questionId,
        "question": question,
        "questionType": questionType,
        "maxScore": maxScore,
        "score": score,
        "isCorrect": isCorrect,
        "answer": answer,
        "answerIncorrect": answerIncorrect,
        "answerCorrect": answerCorrect,
        "explanation": explanation,
      };
}
