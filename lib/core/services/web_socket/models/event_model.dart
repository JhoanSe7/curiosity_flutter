import 'package:curiosity_flutter/core/utils/extensions/text_extension.dart';
import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:curiosity_flutter/features/room/data/models/quiz_result_model.dart';

import 'event_type.dart';

class EventModel {
  EventType event;
  String roomCode;
  String quizId;
  String quizTitle;
  String hostId;
  String hostName;
  int playerCount;
  List<UserModel> user;
  UserModel? userTrigger;
  String message;
  String timestamp;
  QuizResultModel? results;

  EventModel({
    required this.event,
    required this.roomCode,
    required this.quizId,
    required this.quizTitle,
    required this.hostId,
    required this.hostName,
    required this.playerCount,
    required this.user,
    this.userTrigger,
    required this.message,
    required this.timestamp,
    this.results,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      event: (json['event'] as String? ?? '').toEvent(),
      roomCode: json['roomCode'] ?? '',
      quizId: json['quizId'] ?? '',
      quizTitle: json['quizTitle'] ?? '',
      hostId: json['hostId'] ?? '',
      hostName: json['hostName'] ?? '',
      playerCount: json['playerCount'] ?? 0,
      user:
          (json['players'] as List<dynamic>? ?? []).map((p) => UserModel.fromJson(p as Map<String, dynamic>)).toList(),
      userTrigger: json['triggerPlayer'] != null ? UserModel.fromJson(json['triggerPlayer']) : null,
      message: json['message'] ?? '',
      timestamp: json['timestamp'] ?? '',
      results: json['results'] != null ? QuizResultModel.fromJson(json['results']) : null,
    );
  }
}
