import 'package:curiosity_flutter/core/network/models/common_error.dart';
import 'package:curiosity_flutter/features/home/domain/repositories/home_repository.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeUseCase {
  final HomeRepository repository;

  HomeUseCase(this.repository);

  Future<Either<CommonError, List<QuizModel>>> getQuizzes({required String userId}) =>
      repository.getQuizzes(userId: userId);
}
