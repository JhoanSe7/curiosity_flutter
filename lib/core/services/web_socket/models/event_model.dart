import 'package:curiosity_flutter/core/utils/extensions/text_extension.dart';
import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';

import 'event_type.dart';

class EventModel {
  final EventType event;
  final String roomCode;
  final String quizId;
  final String quizTitle;
  final String hostId;
  final String hostName;
  final int playerCount;
  final List<UserModel> user;
  final UserModel? userTrigger;
  final String message;
  final String timestamp;

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
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      event: (json['event'] as String? ?? '').toEventType,
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
    );
  }
}
