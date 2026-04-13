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
  bool _isConnecting = false;

  // Callbacks pendientes que se ejecutan cuando la conexión esté lista
  final List<void Function()> _onConnectCallbacks = [];

  final Map<String, void Function(StompFrame)> _subscriptions = {};
  final Map<String, StompUnsubscribe> _activeSubscriptions = {};

  final List<Map<String, dynamic>> _messageQueue = [];

  void connect({void Function()? onConnected}) {
    // Si ya está conectado, ejecutar callback inmediatamente
    if (_isConnected) {
      onConnected?.call();
      return;
    }

    // Guardar el callback para ejecutarlo cuando conecte
    if (onConnected != null) _onConnectCallbacks.add(onConnected);

    if (_isConnecting) return;
    _isConnecting = true;

    _client = StompClient(
      config: StompConfig.sockJS(
        url: '${Config.wsBaseUrl}/ws',
        onConnect: _onConnect,
        onDisconnect: _onDisconnect,
        onWebSocketError: (error) {
          log.warning('WebSocket error: $error');
          _handleDisconnect();
        },
        onStompError: (frame) {
          log.warning('STOMP error: ${frame.body}');
        },
        reconnectDelay: const Duration(seconds: 5),
        pingInterval: const Duration(seconds: 3),
      ),
    );

    _client.activate();
  }

  StompUnsubscribe? subscribe({required String channel, required void Function(StompFrame) callback}) {
    _subscriptions[channel] = callback;
    if (_isConnected) {
      final unsubscribe = _client.subscribe(
        destination: channel,
        callback: callback,
      );
      _activeSubscriptions[channel] = unsubscribe;
    }
    return null;
  }

  void emit({required String channel, required Map<String, dynamic> data}) {
    if (!_isConnected) {
      if (_messageQueue.length >= 100) {
        _messageQueue.removeAt(0);
      }
      _messageQueue.add({
        'channel': channel,
        'data': data,
      });
      log.info('Mensaje encolado: $channel');
      return;
    }
    _client.send(
      destination: channel,
      body: jsonEncode(data),
    );
  }

  void _onConnect(StompFrame frame) {
    _isConnected = true;
    _isConnecting = false;

    log.info('WebSocket conectado ✓');

    for (final unsubscribe in _activeSubscriptions.values) {
      unsubscribe();
    }
    _activeSubscriptions.clear();

    _subscriptions.forEach((channel, callback) {
      final unsubscribe = _client.subscribe(
        destination: channel,
        callback: callback,
      );
      _activeSubscriptions[channel] = unsubscribe;
    });

    for (final callback in _onConnectCallbacks) {
      callback();
    }
    _onConnectCallbacks.clear();

    for (final message in _messageQueue) {
      _client.send(
        destination: message['channel'],
        body: jsonEncode(message['data']),
      );
    }
    _messageQueue.clear();
  }

  void _onDisconnect(StompFrame frame) {
    log.warning('WebSocket desconectado');
    _handleDisconnect();
  }

  void _handleDisconnect() {
    _isConnected = false;
    _isConnecting = false;
  }

  void disconnect() {
    if (_isConnected || _isConnecting) {
      _client.deactivate();
    }

    _handleDisconnect();

    for (final unsubscribe in _activeSubscriptions.values) {
      unsubscribe();
    }
    _activeSubscriptions.clear();
  }
}
