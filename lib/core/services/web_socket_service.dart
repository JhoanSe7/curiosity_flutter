import 'dart:async';
import 'dart:convert';

import 'package:curiosity_flutter/core/constants/config.dart';
import 'package:curiosity_flutter/features/lobbie/data/models/lobby_event_model.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';


@singleton
class WebSocketService {
  final log = Logger('WebSocketService');

  StompClient? _client;
  bool _isConnected = false;

  final _lobbyController = StreamController<LobbyEventModel>.broadcast();
  final _errorController = StreamController<String>.broadcast();

  /// Eventos del lobby (jugadores entrando/saliendo, quiz iniciando)
  Stream<LobbyEventModel> get lobbyStream => _lobbyController.stream;

  /// Errores del servidor (sala no existe, ya inició, etc.)
  Stream<String> get errorStream => _errorController.stream;

  bool get isConnected => _isConnected;

  // ─── Conexión ─────────────────────────────────────────────────────────────

  void connect() {
    if (_isConnected) return;

    _client = StompClient(
      config: StompConfig.sockJS(
        url: '${Config.wsBaseUrl}/ws',
        onConnect: _onConnect,
        onDisconnect: _onDisconnect,
        onWebSocketError: (error) => log.warning('WebSocket error: $error'),
        onStompError: (frame) => log.warning('STOMP error: ${frame.body}'),
        reconnectDelay: const Duration(seconds: 5),
      ),
    );

    _client!.activate();
    log.info('WebSocket activado');
  }

  void _onConnect(StompFrame frame) {
    _isConnected = true;
    log.info('WebSocket conectado ✓');
  }

  void _onDisconnect(StompFrame frame) {
    _isConnected = false;
    log.info('WebSocket desconectado');
  }

  // ─── Lobby ────────────────────────────────────────────────────────────────

  StompUnsubscribe? _lobbySub;
  StompUnsubscribe? _errorSub;

  /// Suscribirse al canal del lobby Y al canal de errores privados.
  /// Ambos son necesarios para saber si el join fue exitoso o falló.
  void subscribeLobby(String roomCode) {
    _assertConnected();

    // 1. Canal principal — todos reciben aquí los eventos de la sala
    _lobbySub = _client!.subscribe(
      destination: '/topic/lobby/$roomCode',
      callback: (frame) {
        if (frame.body == null) return;
        try {
          final json = jsonDecode(frame.body!) as Map<String, dynamic>;
          final event = LobbyEventModel.fromJson(json);
          log.info('Evento recibido: ${event.event} — jugadores: ${event.playerCount}');
          _lobbyController.add(event);
        } catch (e) {
          log.warning('Error parseando evento del lobby: $e');
        }
      },
    );

    // 2. Canal de errores privados — solo este usuario recibe aquí
    // El backend manda aquí cuando: sala no existe o el quiz ya inició
    _errorSub = _client!.subscribe(
      destination: '/user/queue/lobby/error',
      callback: (frame) {
        final message = frame.body ?? 'Error desconocido del servidor';
        log.warning('Error recibido del servidor: $message');
        _errorController.add(message);
      },
    );

    log.info('Suscrito a /topic/lobby/$roomCode y /user/queue/lobby/error');
  }

  void unsubscribeLobby() {
    _lobbySub?.call();
    _errorSub?.call();
    _lobbySub = null;
    _errorSub = null;
    log.info('Desuscrito del lobby');
  }

  // ─── Mensajes salientes ───────────────────────────────────────────────────

  void joinLobby({
    required String roomCode,
    required String userId,
    required String firstName,
    String? secondName,
    required String lastName,
    String? secondLastName,
    required String email,
    required String phoneNumber,
    required String role,
  }) {
    _assertConnected();
    _client!.send(
      destination: '/app/lobby.join/$roomCode',
      body: jsonEncode({
        'userId': userId,
        'firstName': firstName,
        'secondName': secondName,
        'lastName': lastName,
        'secondLastName': secondLastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'role': role,
      }),
    );
    log.info('joinLobby enviado → sala: $roomCode');
  }

  void leaveLobby({
    required String roomCode,
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String role,
  }) {
    _assertConnected();
    _client!.send(
      destination: '/app/lobby.leave/$roomCode',
      body: jsonEncode({
        'userId': userId,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'role': role,
      }),
    );
    log.info('leaveLobby enviado → sala: $roomCode');
  }

  // ─── Desconexión ──────────────────────────────────────────────────────────

  void disconnect() {
    unsubscribeLobby();
    _client?.deactivate();
    _isConnected = false;
    log.info('WebSocket desactivado');
  }

  void _assertConnected() {
    if (!_isConnected || _client == null) {
      throw StateError('WebSocket no conectado. Llama connect() primero.');
    }
  }

  void dispose() {
    disconnect();
    _lobbyController.close();
    _errorController.close();
  }
}