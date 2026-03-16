import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';

class RoomState {
  final bool isConnecting;
  final bool isConnected;
  final String quizTitle;
  final List<UserModel> users;
  final bool quizStarted;
  final String errorMessage;
  final String roomCode;
  final String quizId;
  final QuizModel? quiz;
  final bool forceFinish;

  RoomState({
    this.isConnecting = false,
    this.isConnected = false,
    this.quizTitle = "",
    this.users = const [],
    this.quizStarted = false,
    this.errorMessage = "",
    this.roomCode = "",
    this.quizId = "",
    this.quiz,
    this.forceFinish = false,
  });

  RoomState copyWith({
    bool? isConnecting,
    bool? isConnected,
    String? quizTitle,
    List<UserModel>? users,
    bool? quizStarted,
    String? errorMessage,
    String? roomCode,
    String? quizId,
    QuizModel? quiz,
    bool? forceFinish,
  }) =>
      RoomState(
        isConnecting: isConnecting ?? this.isConnecting,
        isConnected: isConnected ?? this.isConnected,
        quizTitle: quizTitle ?? this.quizTitle,
        users: users ?? this.users,
        quizStarted: quizStarted ?? this.quizStarted,
        errorMessage: errorMessage ?? this.errorMessage,
        roomCode: roomCode ?? this.roomCode,
        quizId: quizId ?? this.quizId,
        quiz: quiz ?? this.quiz,
        forceFinish: forceFinish ?? this.forceFinish,
      );
}
