import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';

class SessionModel {
  String? id;
  String? roomCode;
  String? quizId;
  String? quizTitle;
  String? hostId;
  List<UserModel>? players;
  String? submittedAt;

  SessionModel({
    this.id,
    this.roomCode,
    this.quizId,
    this.quizTitle,
    this.hostId,
    this.players,
    this.submittedAt,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    List players = json["players"] != null && json["players"] is List ? json["players"] : [];
    return SessionModel(
      id: json["id"],
      roomCode: json["roomCode"],
      quizId: json["quizId"],
      quizTitle: json["quizTitle"],
      hostId: json["hostId"],
      players: players.map((x) => UserModel.fromJson(x)).toList(),
      submittedAt: json["submittedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "roomCode": roomCode,
        "quizId": quizId,
        "quizTitle": quizTitle,
        "hostId": hostId,
        "players": players,
        "submittedAt": submittedAt,
      };
}
