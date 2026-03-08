import 'dart:convert';

import 'package:curiosity_flutter/core/constants/config.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

final log = Logger('WebSocketService');

@singleton
class WebSocketService {
  late StompClient _client;
  late bool _isConnected = false;

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

    _client.activate();
  }

  StompUnsubscribe subscribe({required String channel, required void Function(StompFrame) callback}) {
    _assertConnected();
    return _client.subscribe(
      destination: channel,
      callback: callback,
    );
  }

  void emit({required String channel, required Map<String, dynamic> data}) {
    _assertConnected();
    _client.send(
      destination: channel,
      body: jsonEncode(data),
    );
  }

  ///
  /// ─── Conexión ──────────────────
  ///
  void _onConnect(StompFrame frame) {
    _isConnected = true;
    log.info('WebSocket status connected ✓');
  }

  void _onDisconnect(StompFrame frame) {
    _isConnected = false;
    log.info('WebSocket desconectado');
  }

  void _assertConnected() {
    if (!_isConnected) {
      throw StateError('WebSocket no conectado.');
    }
  }
}
