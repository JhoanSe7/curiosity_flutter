import 'package:curiosity_flutter/core/network/models/common_error.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';
import 'package:dartz/dartz.dart';

abstract class RoomRepository {
  Future<Either<CommonError, bool>> validateRoom({required String roomCode});

  Future<Either<CommonError, bool>> startQuiz({required String roomCode, required String userId});

  Future<Either<CommonError, QuizModel>> getQuizById({required String quizId});

  Future<Either<CommonError, bool>> finishQuiz({required String roomCode, required String userId});
}
