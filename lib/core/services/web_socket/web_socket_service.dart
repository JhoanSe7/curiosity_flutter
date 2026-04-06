import 'dart:convert';

import 'package:curiosity_flutter/core/constants/config.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

final log = Logger('WebSocketService');

@singleton
class WebSocketService {
  late StompClient _client;
  bool _isConnected = false;

  // Callbacks pendientes que se ejecutan cuando la conexión esté lista
  final List<void Function()> _onConnectCallbacks = [];

  void connect({void Function()? onConnected}) {
    // Si ya está conectado, ejecutar callback inmediatamente
    if (_isConnected) {
      onConnected?.call();
      return;
    }

    // Guardar el callback para ejecutarlo cuando conecte
    if (onConnected != null) _onConnectCallbacks.add(onConnected);

    // Evitar activar múltiples clientes
    if (_onConnectCallbacks.length > 1) return;

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

    // Ejecutar todos los callbacks pendientes
    for (final callback in _onConnectCallbacks) {
      callback();
    }
    _onConnectCallbacks.clear();
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