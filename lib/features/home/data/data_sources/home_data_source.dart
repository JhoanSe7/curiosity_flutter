import 'package:curiosity_flutter/core/constants/config.dart';
import 'package:curiosity_flutter/core/network/client_http.dart';
import 'package:curiosity_flutter/core/network/models/http_response.dart';
import 'package:injectable/injectable.dart';

abstract class HomeDataSource {
  Future<HttpResponseModel> getQuizzes({required String userId});
}

@Injectable(as: HomeDataSource)
class HomeDataSourceImpl extends HomeDataSource {
  final ClientHttp clientHttp;

  HomeDataSourceImpl(this.clientHttp);

  @override
  Future<HttpResponseModel> getQuizzes({required String userId}) async {
    return await clientHttp.get(endpoint: "${Config.apiUrl}quiz/user/$userId");
  }
}
