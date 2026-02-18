import 'package:curiosity_flutter/core/network/models/common_error.dart';
import 'package:curiosity_flutter/core/network/models/response/error_response_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/data_sources/questionaries_data_source.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';
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
      }else if (!result.success) {
        final error = ErrorResponseModel.fromJson(result.body);
        return left(CommonError(message: "${error.message}(${error.errorCode})"));
      }
      throw ("No se pudo procesar los datos");
    } catch (e) {
      return left(CommonError(message: "Error createQuiz: $e"));
    }
  }
}
