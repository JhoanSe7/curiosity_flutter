import 'package:curiosity_flutter/core/network/models/common_error.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';
import 'package:dartz/dartz.dart';

abstract class QuestionariesRepository {
  Future<Either<CommonError, QuizModel>> createQuiz({required QuizModel data});

}
