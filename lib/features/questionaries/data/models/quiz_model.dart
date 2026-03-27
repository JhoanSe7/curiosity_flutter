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
  List<QuestionModel>? suggestQuestions;

  QuizModel({
    this.id,
    this.userId,
    this.title,
    this.description,
    this.questions,
    this.category,
    this.difficulty,
    this.isPublic,
    this.suggestQuestions,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    List questions = json["questions"] != null && json["questions"] is List ? json["questions"] : [];
    List suggest = json["suggestQuestions"] != null && json["suggestQuestions"] is List ? json["suggestQuestions"] : [];
    return QuizModel(
      id: json["id"],
      userId: json["userId"],
      title: json["title"],
      description: json["description"],
      questions: questions.map((e) => QuestionModel.fromJson(e)).toList(),
      category: json["category"],
      difficulty: json["difficulty"],
      isPublic: json["isPublic"],
      suggestQuestions: suggest.map((e) => QuestionModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "title": title,
        "description": description,
        "questions": questions,
        "category": category,
        "difficulty": difficulty,
        "isPublic": isPublic,
      };
}
