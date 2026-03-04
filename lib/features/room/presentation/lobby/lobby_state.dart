import 'package:curiosity_flutter/features/room/data/models/lobby_player_model.dart';

class LobbyState {
  final bool isConnecting;
  final bool isConnected;
  final String quizTitle;
  final List<LobbyPlayerModel> players;
  final bool quizStarted;
  final String errorMessage;

  LobbyState({
    this.isConnecting = false,
    this.isConnected = false,
    this.quizTitle = "",
    this.players = const [],
    this.quizStarted = false,
    this.errorMessage = "",
  });

  LobbyState copyWith({
    bool? isConnecting,
    bool? isConnected,
    String? quizTitle,
    List<LobbyPlayerModel>? players,
    bool? quizStarted,
    String? errorMessage,
  }) {
    return LobbyState(
      isConnecting: isConnecting ?? this.isConnecting,
      isConnected: isConnected ?? this.isConnected,
      quizTitle: quizTitle ?? this.quizTitle,
      players: players ?? this.players,
      quizStarted: quizStarted ?? this.quizStarted,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
