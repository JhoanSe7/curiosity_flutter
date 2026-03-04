import 'lobby_player_model.dart';

enum LobbyEventType {
  playerJoined,
  playerLeft,
  quizStarted,
  lobbyClosed,
  lobbyError,
  unknown,
}

extension LobbyEventTypeX on String {
  LobbyEventType toLobbyEventType() {
    switch (this) {
      case 'PLAYER_JOINED':  return LobbyEventType.playerJoined;
      case 'PLAYER_LEFT':    return LobbyEventType.playerLeft;
      case 'QUIZ_STARTED':   return LobbyEventType.quizStarted;
      case 'LOBBY_CLOSED':   return LobbyEventType.lobbyClosed;
      case 'LOBBY_ERROR':    return LobbyEventType.lobbyError;
      default:               return LobbyEventType.unknown;
    }
  }
}

class LobbyEventModel {
  final LobbyEventType event;
  final String roomCode;
  final String quizId;
  final String quizTitle;
  final String hostId;
  final String hostName;
  final int playerCount;
  final List<LobbyPlayerModel> players;
  final LobbyPlayerModel? triggerPlayer;
  final String message;
  final String timestamp;

  LobbyEventModel({
    required this.event,
    required this.roomCode,
    required this.quizId,
    required this.quizTitle,
    required this.hostId,
    required this.hostName,
    required this.playerCount,
    required this.players,
    this.triggerPlayer,
    required this.message,
    required this.timestamp,
  });

  factory LobbyEventModel.fromJson(Map<String, dynamic> json) {
    return LobbyEventModel(
      event: (json['event'] as String? ?? '').toLobbyEventType(),
      roomCode: json['roomCode'] ?? '',
      quizId: json['quizId'] ?? '',
      quizTitle: json['quizTitle'] ?? '',
      hostId: json['hostId'] ?? '',
      hostName: json['hostName'] ?? '',
      playerCount: json['playerCount'] ?? 0,
      players: (json['players'] as List<dynamic>? ?? [])
          .map((p) => LobbyPlayerModel.fromJson(p as Map<String, dynamic>))
          .toList(),
      triggerPlayer: json['triggerPlayer'] != null
          ? LobbyPlayerModel.fromJson(json['triggerPlayer'])
          : null,
      message: json['message'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }
}