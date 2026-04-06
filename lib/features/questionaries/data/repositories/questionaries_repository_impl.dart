import 'package:curiosity_flutter/core/network/models/common_error.dart';
import 'package:curiosity_flutter/core/network/models/response/error_response_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/data_sources/questionaries_data_source.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/generate_quiz_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/room_model.dart';
import 'package:curiosity_flutter/features/questionaries/domain/repositories/questionaries_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: QuestionariesRepository)
class QuestionariesRepositoryImpl extends QuestionariesRepository {
  final QuestionariesDataSource dataSource;

  QuestionariesRepositoryImpl(this.dataSource);

  @override
  Future<Either<CommonError, QuizModel>> createQuiz({required QuizModel data}) async {
    try {
      final result = await dataSource.createQuiz(data: data);
      if (result.success) {
        return right(QuizModel.fromJson(result.body));
      } else if (!result.success && result.body is Map<String, dynamic>) {
        final error = ErrorResponseModel.fromJson(result.body);
        return left(CommonError(message: "${error.message}(${error.errorCode})"));
      }
      throw (result.message ?? "No se pudo procesar los datos");
    } catch (e) {
      return left(CommonError(message: "Error createQuiz: $e"));
    }
  }

  @override
  Future<Either<CommonError, QuizModel>> generateQuiz({required GenerateQuizModel data}) async {
    try {
      final result = await dataSource.generateQuiz(data: data);
      if (result.success) {
        var data = result.body["quiz"];
        return right(QuizModel.fromJson(data));
      } else if (!result.success && result.body is Map<String, dynamic>) {
        final error = ErrorResponseModel.fromJson(result.body);
        return left(CommonError(message: "${error.message}(${error.errorCode})"));
      }
      throw (result.message ?? "No se pudo procesar los datos");
    } catch (e) {
      return left(CommonError(message: "Error generateQuiz: $e"));
    }
  }

  @override
  Future<Either<CommonError, RoomModel>> createRoom({required RoomModel data}) async {
    try {
      final result = await dataSource.createRoom(data: data);
      if (result.success) {
        return right(RoomModel.fromJson(result.body));
      } else if (!result.success && result.body is Map<String, dynamic>) {
        final error = ErrorResponseModel.fromJson(result.body);
        return left(CommonError(message: "${error.message}(${error.errorCode})"));
      }
      throw (result.message ?? "No se pudo procesar los datos");
    } catch (e) {
      return left(CommonError(message: "Error generateQuiz: $e"));
    }
  }

  @override
  Future<Either<CommonError, bool>> deleteQuiz({required String quizId, required String userId}) async {
    try {
      final result = await dataSource.deleteQuiz(quizId: quizId, userId: userId);
      if (result.success) {
        return right(true);
      } else if (!result.success && result.body is Map<String, dynamic>) {
        final error = ErrorResponseModel.fromJson(result.body);
        return left(CommonError(message: "${error.message}(${error.errorCode})"));
      }
      throw (result.message ?? "No se pudo procesar los datos");
    } catch (e) {
      return left(CommonError(message: "Error deleteQuiz: $e"));
    }
  }
}
