import 'package:curiosity_flutter/features/questionaries/data/models/question_model.dart';

class QuizModel {
  String? id;
  String? userId;
  String? title;
  String? description;
  List<QuestionModel>? questions;
  String? category;
  String? difficulty;
  bool? isPublic;

  QuizModel({
    this.id,
    this.userId,
    this.title,
    this.description,
    this.questions,
    this.category,
    this.difficulty,
    this.isPublic,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    List questions = json["questions"] != null && json["questions"] is List ? json["questions"] : [];
    return QuizModel(
      id: json["id"],
      userId: json["userId"],
      title: json["title"],
      description: json["description"],
      questions: questions.map((e) => QuestionModel.fromJson(e)).toList(),
      category: json["category"],
      difficulty: json["difficulty"],
      isPublic: json["isPublic"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "title": title,
        "description": description,
        "questions": questions?.map((e) => e.toJson()),
        "category": category,
        "difficulty": difficulty,
        "isPublic": isPublic,
      };
}
