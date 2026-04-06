import 'package:curiosity_flutter/core/constants/config.dart';
import 'package:curiosity_flutter/core/network/client_http.dart';
import 'package:curiosity_flutter/core/network/models/http_response.dart';
import 'package:injectable/injectable.dart';

abstract class RoomDataSource {
  Future<HttpResponseModel> validateRoom({required String roomCode});

  Future<HttpResponseModel> startQuiz({required String roomCode, required String userId});

  Future<HttpResponseModel> getQuizById({required String quizId});

  Future<HttpResponseModel> finishQuiz({required String roomCode, required String userId});

  Future<HttpResponseModel> getSessionByRoom({required String roomCode});
}

@Injectable(as: RoomDataSource)
class RoomDataSourceImpl implements RoomDataSource {
  RoomDataSourceImpl(this.clientHttp);

  ClientHttp clientHttp;

  @override
  Future<HttpResponseModel> validateRoom({required String roomCode}) async {
    return await clientHttp.get(
      endpoint: "${Config.apiUrl}lobby/exists/$roomCode",
    );
  }

  @override
  Future<HttpResponseModel> startQuiz({required String roomCode, required String userId}) async {
    return await clientHttp.post(
      endpoint: "${Config.apiUrl}game/start",
      body: {
        "roomCode": roomCode,
        "userId": userId,
      },
    );
  }

  @override
  Future<HttpResponseModel> getQuizById({required String quizId}) async {
    return await clientHttp.get(
      endpoint: "${Config.apiUrl}quiz/$quizId",
    );
  }

  @override
  Future<HttpResponseModel> finishQuiz({required String roomCode, required String userId}) async {
    return await clientHttp.post(
      endpoint: "${Config.apiUrl}game/finish",
      body: {
        "roomCode": roomCode,
        "userId": userId,
      },
    );
  }

  @override
  Future<HttpResponseModel> getSessionByRoom({required String roomCode}) async {
    return await clientHttp.get(endpoint: "${Config.apiUrl}sessions/room/$roomCode");
  }
}
