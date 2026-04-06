import 'package:curiosity_flutter/core/constants/config.dart';
import 'package:curiosity_flutter/core/network/client_http.dart';
import 'package:curiosity_flutter/core/network/models/http_response.dart';
import 'package:injectable/injectable.dart';

abstract class HomeDataSource {
  Future<HttpResponseModel> getQuizzes({required String userId});

  Future<HttpResponseModel> getResults({required String userId});

  Future<HttpResponseModel> getSessions({required String userId});

  Future<HttpResponseModel> getResultSessionUser({required String roomCode, required String userId});
}

@Injectable(as: HomeDataSource)
class HomeDataSourceImpl extends HomeDataSource {
  final ClientHttp clientHttp;

  HomeDataSourceImpl(this.clientHttp);

  @override
  Future<HttpResponseModel> getQuizzes({required String userId}) async {
    return await clientHttp.get(endpoint: "${Config.apiUrl}quiz/user/$userId");
  }

  @override
  Future<HttpResponseModel> getResults({required String userId}) async {
    return await clientHttp.get(endpoint: "${Config.apiUrl}results/user/$userId");
  }

  @override
  Future<HttpResponseModel> getSessions({required String userId}) async {
    return await clientHttp.get(endpoint: "${Config.apiUrl}sessions/user/$userId");
  }

  @override
  Future<HttpResponseModel> getResultSessionUser({required String roomCode, required String userId}) async {
    return await clientHttp.get(endpoint: "${Config.apiUrl}results/roomCode/$roomCode/user/$userId");
  }
}
