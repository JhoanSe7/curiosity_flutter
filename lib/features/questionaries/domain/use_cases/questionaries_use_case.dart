import 'package:curiosity_flutter/core/network/models/common_error.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/generate_quiz_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/room_model.dart';
import 'package:curiosity_flutter/features/questionaries/domain/repositories/questionaries_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class QuestionariesUseCase {
  final QuestionariesRepository repository;

  QuestionariesUseCase(this.repository);

  Future<Either<CommonError, QuizModel>> createQuiz({required QuizModel data}) async =>
      await repository.createQuiz(data: data);

  Future<Either<CommonError, QuizModel>> generateQuiz({required GenerateQuizModel data}) async =>
      await repository.generateQuiz(data: data);

  Future<Either<CommonError, RoomModel>> createRoom({required RoomModel data}) async =>
      await repository.createRoom(data: data);
}
