import 'package:curiosity_flutter/core/network/models/common_error.dart';
import 'package:curiosity_flutter/features/home/data/models/session_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';
import 'package:curiosity_flutter/features/room/domain/repositories/room_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class RoomUseCase {
  RoomUseCase(this.repository);

  final RoomRepository repository;

  Future<Either<CommonError, bool>> validateRoom({required String roomCode}) async =>
      repository.validateRoom(roomCode: roomCode);

  Future<Either<CommonError, bool>> startQuiz({required String roomCode, required String userId}) async =>
      repository.startQuiz(roomCode: roomCode, userId: userId);

  Future<Either<CommonError, QuizModel>> getQuizById({required String quizId}) async =>
      repository.getQuizById(quizId: quizId);

  Future<Either<CommonError, bool>> finishQuiz({required String roomCode, required String userId}) async =>
      repository.finishQuiz(roomCode: roomCode, userId: userId);

  Future<Either<CommonError, SessionModel>> getSessionByRoom({required String roomCode}) async =>
      repository.getSessionByRoom(roomCode: roomCode);

  Future<Either<CommonError, bool>> sendMailReport({required String sessionId}) async =>
      repository.sendMailReport(sessionId: sessionId);

  Future<Either<CommonError, dynamic>> downloadReport({required String sessionId}) async =>
      repository.downloadReport(sessionId: sessionId);
}
