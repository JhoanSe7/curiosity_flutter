import 'package:curiosity_flutter/core/constants/config.dart';
import 'package:curiosity_flutter/core/network/client_http.dart';
import 'package:curiosity_flutter/core/network/models/http_response.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';
import 'package:injectable/injectable.dart';

abstract class QuestionariesDataSource {
  Future<HttpResponseModel> createQuiz({required QuizModel data});

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

}
