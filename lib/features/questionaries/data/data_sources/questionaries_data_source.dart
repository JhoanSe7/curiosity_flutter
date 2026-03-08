import 'package:curiosity_flutter/core/constants/config.dart';
import 'package:curiosity_flutter/core/network/client_http.dart';
import 'package:curiosity_flutter/core/network/models/http_response.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/generate_quiz_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/room_model.dart';
import 'package:injectable/injectable.dart';

abstract class QuestionariesDataSource {
  Future<HttpResponseModel> createQuiz({required QuizModel data});

  Future<HttpResponseModel> generateQuiz({required GenerateQuizModel data});

  Future<HttpResponseModel> createRoom({required RoomModel data});

  Future<HttpResponseModel> deleteQuiz({required String quizId, required String userId});
}

@Injectable(as: QuestionariesDataSource)
class QuestionariesDataSourceImpl extends QuestionariesDataSource {
  final ClientHttp clientHttp;

  QuestionariesDataSourceImpl(this.clientHttp);

  @override
  Future<HttpResponseModel> createQuiz({required QuizModel data}) async {
    return await clientHttp.post(
      endpoint: "${Config.apiUrl}quiz/create",
      body: data.toJson(),
    );
  }

  @override
  Future<HttpResponseModel> generateQuiz({required GenerateQuizModel data}) async {
    return await clientHttp.post(
      endpoint: "${Config.apiUrl}groq/generate-quiz",
      body: data.toJson(),
    );
  }

  @override
  Future<HttpResponseModel> createRoom({required RoomModel data}) async {
    return await clientHttp.post(
      endpoint: "${Config.apiUrl}lobby/create",
      body: data.toJson(),
    );
  }

  @override
  Future<HttpResponseModel> deleteQuiz({required String quizId, required String userId}) async {
    return await clientHttp.post(
      endpoint: "${Config.apiUrl}quiz/delete",
      body: {
        "quizId": quizId,
        "userId": userId,
      },
    );
  }
}
