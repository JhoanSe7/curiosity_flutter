class GenerateQuizModel {
  String? topic;
  int? numberOfQuestions;
  String? language;
  int? timePerQuestion;
  Map<String, int>? questionDistribution;

  GenerateQuizModel({
    this.topic,
    this.numberOfQuestions,
    this.language,
    this.timePerQuestion,
    this.questionDistribution,
  });

  factory GenerateQuizModel.fromJson(Map<String, dynamic> json) => GenerateQuizModel(
        topic: json["topic"],
        numberOfQuestions: json["numberOfQuestions"],
        language: json["language"],
        timePerQuestion: json["timePerQuestion"],
        questionDistribution: json["questionDistribution"],
      );

  Map<String, dynamic> toJson() => {
        "topic": topic,
        "numberOfQuestions": numberOfQuestions,
        "language": language,
        "timePerQuestion": timePerQuestion,
        "questionDistribution": questionDistribution,
      };

  Map<String, dynamic> toIA() => {
        "quiz": toJson(),
      };
}
