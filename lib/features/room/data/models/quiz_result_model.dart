import 'result_detail_model.dart';

class QuizResultModel {
  String? id;
  String? roomCode;
  String? quizId;
  String? quizTitle;
  String? userId;

  List<ResultDetailModel>? details;

  double? totalScore;
  double? maxPossibleScore;
  double? percentage;
  int? totalQuestions;
  int? correctAnswers;
  int? incorrectAnswers;
  String? submittedAt;

  QuizResultModel({
    this.id,
    this.roomCode,
    this.quizId,
    this.quizTitle,
    this.userId,
    this.details,
    this.totalScore,
    this.maxPossibleScore,
    this.percentage,
    this.totalQuestions,
    this.correctAnswers,
    this.incorrectAnswers,
    this.submittedAt,
  });

  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    List details = json["details"] != null && json["details"] is List ? json["details"] : [];
    return QuizResultModel(
      id: json["id"],
      roomCode: json["roomCode"],
      quizId: json["quizId"],
      quizTitle: json["quizTitle"],
      userId: json["userId"],
      details: details.map((e) => ResultDetailModel.fromJson(e)).toList(),
      totalScore: json["totalScore"],
      maxPossibleScore: json["maxPossibleScore"],
      percentage: json["percentage"],
      totalQuestions: json["totalQuestions"],
      correctAnswers: json["correctAnswers"],
      incorrectAnswers: json["incorrectAnswers"],
      submittedAt: json["submittedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "roomCode": roomCode,
        "quizId": quizId,
        "quizTitle": quizTitle,
        "userId": userId,
        "details": details,
        "totalScore": totalScore,
        "maxPossibleScore": maxPossibleScore,
        "percentage": percentage,
        "totalQuestions": totalQuestions,
        "correctAnswers": correctAnswers,
        "incorrectAnswers": incorrectAnswers,
        "submittedAt": submittedAt,
      };
}
