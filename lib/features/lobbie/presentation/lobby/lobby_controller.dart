import 'dart:async';

import 'package:curiosity_flutter/core/di/injection.dart';
import 'package:curiosity_flutter/core/services/web_socket_service.dart';
import 'package:curiosity_flutter/features/lobbie/data/models/lobby_event_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'lobby_state.dart';

class LobbyController extends StateNotifier<LobbyState> {
  LobbyController(this._wsService) : super(LobbyState());

  final WebSocketService _wsService;
  StreamSubscription<LobbyEventModel>? _lobbySub;

  Future<void> joinLobby({
    required String roomCode,
    required String userId,
    required String firstName,
    String? secondName,
    required String lastName,
    String? secondLastName,
    required String email,
    required String phoneNumber,
    required String role,
  }) async {
    if (mounted) state = state.copyWith(isConnecting: true);

    try {
      _wsService.connect();
      await Future.delayed(const Duration(milliseconds: 500));

      _wsService.subscribeLobby(roomCode);

      // Un solo stream maneja todo: éxito y error
      _lobbySub = _wsService.lobbyStream.listen(_handleEvent);

      _wsService.joinLobby(
        roomCode: roomCode,
        userId: userId,
        firstName: firstName,
        secondName: secondName,
        lastName: lastName,
        secondLastName: secondLastName,
        email: email,
        phoneNumber: phoneNumber,
        role: role,
      );

      if (mounted) state = state.copyWith(roomCode: roomCode);

    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          isConnecting: false,
          errorMessage: 'Error de conexión: $e',
        );
      }
    }
  }

  void _handleEvent(LobbyEventModel event) {
    if (!mounted) return;

    switch (event.event) {
      case LobbyEventType.playerJoined:
      case LobbyEventType.playerLeft:
        state = state.copyWith(
          isConnecting: false,
          isConnected: true,
          players: event.players,
          quizTitle: event.quizTitle,
        );

      case LobbyEventType.lobbyError:
        state = state.copyWith(
          isConnecting: false,
          isConnected: false,
          errorMessage: event.message,
        );

      case LobbyEventType.quizStarted:
        state = state.copyWith(quizStarted: true);

      case LobbyEventType.lobbyClosed:
        state = state.copyWith(
          isConnected: false,
          errorMessage: 'El lobby fue cerrado por el profesor',
        );

      case LobbyEventType.unknown:
        break;
    }
  }

  void leaveLobby({
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String role,
  }) {
    final roomCode = state.roomCode;
    if (roomCode == null) return;

    _wsService.leaveLobby(
      roomCode: roomCode,
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      role: role,
    );

    _cleanup();
    if (mounted) state = LobbyState();
  }

  void _cleanup() {
    _lobbySub?.cancel();
    _wsService.unsubscribeLobby();
    _lobbySub = null;
  }

  @override
  void dispose() {
    _cleanup();
    super.dispose();
  }
}

final lobbyController =
StateNotifierProvider<LobbyController, LobbyState>(
      (ref) => LobbyController(getIt.get()),
);