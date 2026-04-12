import 'dart:async';
import 'dart:convert';

import 'package:curiosity_flutter/core/di/injection.dart';
import 'package:curiosity_flutter/core/services/web_socket/models/event_model.dart';
import 'package:curiosity_flutter/core/services/web_socket/models/event_type.dart';
import 'package:curiosity_flutter/core/services/web_socket/web_socket_service.dart';
import 'package:curiosity_flutter/core/utils/util_processor.dart';
import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:curiosity_flutter/features/home/data/models/session_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';
import 'package:curiosity_flutter/features/room/data/models/quiz_result_model.dart';
import 'package:curiosity_flutter/features/room/domain/use_cases/room_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import 'room_state.dart';

class RoomController extends StateNotifier<RoomState> {
  RoomController(this.useCase, this.wsService) : super(RoomState());

  final RoomUseCase useCase;
  final WebSocketService wsService;

  final _eventController = StreamController<EventModel>.broadcast();

  ///
  Future<void> connect(UserModel user, String roomCode, {bool isOwner = false}) async {
    if (mounted) state = state.copyWith(isConnecting: true);

    try {
      final action = isOwner ? 'host' : 'join';
      final channelSub = '/topic/lobby/${isOwner ? '$roomCode/host' : roomCode}';
      final channelEmit = '/app/lobby.$action/$roomCode';

      // Conectar y ejecutar suscripción + emit solo cuando esté listo
      wsService.connect(onConnected: () {
        onSubscribe(channelSub, channelEmit, user);
        if (!isOwner) subscribeResult(roomCode, user.id ?? "");
      });
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          isConnecting: false,
          errorMessage: 'Error de conexión: $e',
        );
      }
    }
  }

  ///
  void onSubscribe(String channelSub, String channelEmit, UserModel user) {
    wsService.subscribe(channel: channelSub, callback: callbackSub);
    _eventController.stream.listen(_eventReceived);
    wsService.emit(channel: channelEmit, data: user.toMap());
  }

  ///
  void subscribeResult(String roomCode, String userId) {
    wsService.subscribe(channel: "/topic/lobby/$roomCode/student/$userId", callback: callbackSub);
  }

  ///
  void callbackSub(StompFrame frame) {
    if (frame.body == null) return;
    try {
      final json = jsonDecode(frame.body ?? "");
      log.info('callback body: $json');
      final event = EventModel.fromJson(json);
      log.info('Evento recibido: ${event.event}');
      _eventController.add(event);
    } catch (e) {
      log.warning('Error parseando evento del lobby: $e');
    }
  }

  ///
  void _eventReceived(EventModel event) {
    if (!mounted) return;

    switch (event.event) {
      case EventType.userJoined:
      case EventType.userLeft:
        state = state.copyWith(
          isConnecting: false,
          isConnected: true,
          users: event.user,
          quizTitle: event.quizTitle,
          errorMessage: "",
        );
      case EventType.error:
        state = state.copyWith(
          isConnecting: false,
          isConnected: false,
          errorMessage: event.message,
        );
      case EventType.start:
        state = state.copyWith(quizStarted: true, quizId: event.quizId);
      case EventType.close:
        state = state.copyWith(
          isConnected: false,
          errorMessage: 'El lobby fue cerrado por el organizador',
        );
      case EventType.userUpdate:
        state = state.copyWith(users: event.user);
      case EventType.forceFinish:
        state = state.copyWith(forceFinish: true, results: QuizResultModel());
      case EventType.quizResult:
        state = state.copyWith(results: event.results, waiting: false);
      case EventType.unknown:
        break;
    }
  }

  ///
  void emitMsg(String channel, Map<String, dynamic> data) {
    wsService.emit(channel: channel, data: data);
  }

  ///
  void clearState() {
    if (mounted) {
      state = state.copyWith(
        isConnecting: true,
        isConnected: false,
        errorMessage: "",
        quizStarted: false,
        forceFinish: false,
        waiting: true,
        quizTitle: "",
        roomCode: "",
        users: [],
      );
    }
  }

  /// Setter para el código del room
  void setRoomCode(String roomCode) {
    if (mounted) state = state.copyWith(roomCode: roomCode);
  }

  ///
  Future<bool> validateRoom(BuildContext context, {required String roomCode}) async {
    final result = await execute<bool>(context, useCase.validateRoom(roomCode: roomCode));
    return result.fold(
      (e) => processError(context, error: e.message) ?? false,
      (data) => data,
    );
  }

  ///
  Future<bool> startQuiz(BuildContext context, {required String roomCode, required String userId}) async {
    final result = await execute<bool>(context, useCase.startQuiz(roomCode: roomCode, userId: userId));
    return result.fold(
      (e) => processError(context, error: e.message) ?? false,
      (data) => data,
    );
  }

  ///
  Future<QuizModel> getQuizById(BuildContext context, {required String quizId}) async {
    final result = await execute<QuizModel>(context, useCase.getQuizById(quizId: quizId));
    return result.fold(
      (e) => processError(context, error: e.message) ?? QuizModel(),
      (data) => data,
    );
  }

  ///
  Future<void> loadQuiz(BuildContext context, {required String quizId}) async {
    var res = await getQuizById(context, quizId: quizId);
    if (mounted) state = state.copyWith(quiz: res);
  }

  ///
  Future<bool> finishQuiz(BuildContext context, {required String roomCode, required String userId}) async {
    final result = await execute<bool>(context, useCase.finishQuiz(roomCode: roomCode, userId: userId));
    return result.fold(
      (e) => processError(context, error: e.message) ?? false,
      (data) => data,
    );
  }

  ///
  void setWaiting(bool waiting) {
    if (mounted) state = state.copyWith(waiting: waiting);
  }

  ///
  Future<SessionModel> getSessionByRoom(BuildContext context, {required String roomCode}) async {
    final result = await execute<SessionModel>(context, useCase.getSessionByRoom(roomCode: roomCode));
    return result.fold(
      (e) => processError(context, error: e.message) ?? SessionModel(),
      (data) => data,
    );
  }

  ///
  Future<bool> sendMailReport(BuildContext context, {required String sessionId}) async {
    final result = await execute<bool>(context, useCase.sendMailReport(sessionId: sessionId));
    return result.fold(
      (e) => processError(context, error: e.message) ?? false,
      (data) => data,
    );
  }
}

final roomController = StateNotifierProvider<RoomController, RoomState>(
  (ref) => RoomController(
    getIt.get(),
    getIt.get(),
  ),
);
