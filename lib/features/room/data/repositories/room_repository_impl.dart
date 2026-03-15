import 'package:curiosity_flutter/core/network/models/common_error.dart';
import 'package:curiosity_flutter/core/network/models/response/error_response_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';
import 'package:curiosity_flutter/features/room/data/data_sources/room_data_source.dart';
import 'package:curiosity_flutter/features/room/domain/repositories/room_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: RoomRepository)
class RoomRepositoryImpl extends RoomRepository {
  RoomDataSource dataSource;

  RoomRepositoryImpl(this.dataSource);

  @override
  Future<Either<CommonError, bool>> validateRoom({required String roomCode}) async {
    try {
      final result = await dataSource.validateRoom(roomCode: roomCode);
      if (result.success) {
        return right(true);
      } else if (!result.success && result.body is Map<String, dynamic>) {
        final error = ErrorResponseModel.fromJson(result.body);
        return left(CommonError(message: "${error.message}(${error.errorCode})"));
      }
      throw (result.message ?? "No se pudo procesar los datos");
    } catch (e) {
      return left(CommonError(message: "Error validateRoom: $e"));
    }
  }

  @override
  Future<Either<CommonError, bool>> startQuiz({required String roomCode, required String userId}) async {
    try {
      final result = await dataSource.startQuiz(roomCode: roomCode, userId: userId);
      if (result.success) {
        return right(true);
      } else if (!result.success && result.body is Map<String, dynamic>) {
        final error = ErrorResponseModel.fromJson(result.body);
        return left(CommonError(message: "${error.message}(${error.errorCode})"));
      }
      throw (result.message ?? "No se pudo procesar los datos");
    } catch (e) {
      return left(CommonError(message: "Error startQuiz: $e"));
    }
  }

  @override
  Future<Either<CommonError, QuizModel>> getQuizById({required String quizId}) async {
    try {
      final result = await dataSource.getQuizById(quizId: quizId);
      if (result.success) {
        return right(QuizModel.fromJson(result.body));
      } else if (!result.success && result.body is Map<String, dynamic>) {
        final error = ErrorResponseModel.fromJson(result.body);
        return left(CommonError(message: "${error.message}(${error.errorCode})"));
      }
      throw (result.message ?? "No se pudo procesar los datos");
    } catch (e) {
      return left(CommonError(message: "Error startQuiz: $e"));
    }
  }

  @override
  Future<Either<CommonError, bool>> finishQuiz({required String roomCode, required String userId}) async {
    try {
      final result = await dataSource.finishQuiz(roomCode: roomCode, userId: userId);
      if (result.success) {
        return right(true);
      } else if (!result.success && result.body is Map<String, dynamic>) {
        final error = ErrorResponseModel.fromJson(result.body);
        return left(CommonError(message: "${error.message}(${error.errorCode})"));
      }
      throw (result.message ?? "No se pudo procesar los datos");
    } catch (e) {
      return left(CommonError(message: "Error finishQuiz: $e"));
    }
  }
}
