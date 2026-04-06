import 'package:curiosity_flutter/core/network/models/common_error.dart';
import 'package:curiosity_flutter/core/network/models/response/error_response_model.dart';
import 'package:curiosity_flutter/features/home/data/data_sources/home_data_source.dart';
import 'package:curiosity_flutter/features/home/data/models/session_model.dart';
import 'package:curiosity_flutter/features/home/domain/repositories/home_repository.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';
import 'package:curiosity_flutter/features/room/data/models/quiz_result_model.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: HomeRepository)
class HomeRepositoryImpl extends HomeRepository {
  final HomeDataSource dataSource;

  HomeRepositoryImpl(this.dataSource);

  @override
  Future<Either<CommonError, List<QuizModel>>> getQuizzes({required String userId}) async {
    try {
      final result = await dataSource.getQuizzes(userId: userId);
      if (result.success) {
        List tempList = result.body;
        return right(tempList.map((e) => QuizModel.fromJson(e)).toList());
      } else if (!result.success && result.body is Map<String, dynamic>) {
        final error = ErrorResponseModel.fromJson(result.body);
        return left(CommonError(message: "${error.message}(${error.errorCode})"));
      }
      throw (result.message ?? "No se pudo procesar los datos");
    } catch (e) {
      return left(CommonError(message: "Error getQuizzes: $e"));
    }
  }

  @override
  Future<Either<CommonError, List<QuizResultModel>>> getResults({required String userId}) async {
    try {
      final result = await dataSource.getResults(userId: userId);
      if (result.success) {
        List tempList = result.body;
        return right(tempList.map((e) => QuizResultModel.fromJson(e)).toList());
      } else if (!result.success && result.body is Map<String, dynamic>) {
        final error = ErrorResponseModel.fromJson(result.body);
        return left(CommonError(message: "${error.message}(${error.errorCode})"));
      }
      throw (result.message ?? "No se pudo procesar los datos");
    } catch (e) {
      return left(CommonError(message: "Error getResults: $e"));
    }
  }

  @override
  Future<Either<CommonError, List<SessionModel>>> getSessions({required String userId}) async {
    try {
      final result = await dataSource.getSessions(userId: userId);
      if (result.success) {
        List tempList = result.body;
        return right(tempList.map((e) => SessionModel.fromJson(e)).toList());
      } else if (!result.success && result.body is Map<String, dynamic>) {
        final error = ErrorResponseModel.fromJson(result.body);
        return left(CommonError(message: "${error.message}(${error.errorCode})"));
      }
      throw (result.message ?? "No se pudo procesar los datos");
    } catch (e) {
      return left(CommonError(message: "Error getSessions: $e"));
    }
  }

  @override
  Future<Either<CommonError, QuizResultModel>> getResultSessionUser(
      {required String roomCode, required String userId}) async {
    try {
      final result = await dataSource.getResultSessionUser(roomCode: roomCode, userId: userId);
      if (result.success) {
        return right(QuizResultModel.fromJson(result.body));
      } else if (!result.success && result.body is Map<String, dynamic>) {
        final error = ErrorResponseModel.fromJson(result.body);
        return left(CommonError(message: "${error.message}(${error.errorCode})"));
      }
      throw (result.message ?? "No se pudo procesar los datos");
    } catch (e) {
      return left(CommonError(message: "Error getResultSessionUser: $e"));
    }
  }
}
