import 'package:curiosity_flutter/core/network/models/common_error.dart';
import 'package:curiosity_flutter/features/home/data/models/session_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';
import 'package:curiosity_flutter/features/room/data/models/quiz_result_model.dart';
import 'package:dartz/dartz.dart';

abstract class HomeRepository {
  Future<Either<CommonError, List<QuizModel>>> getQuizzes({required String userId});

  Future<Either<CommonError, List<QuizResultModel>>> getResults({required String userId});

  Future<Either<CommonError, List<SessionModel>>> getSessions({required String userId});

  Future<Either<CommonError, QuizResultModel>> getResultSessionUser({required String roomCode, required String userId});
}
