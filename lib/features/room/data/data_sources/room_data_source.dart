import 'package:curiosity_flutter/core/constants/config.dart';
import 'package:curiosity_flutter/core/network/client_http.dart';
import 'package:curiosity_flutter/core/network/models/http_response.dart';
import 'package:injectable/injectable.dart';

abstract class RoomDataSource {
  Future<HttpResponseModel> validateRoom({required String roomCode});
}

@Injectable(as: RoomDataSource)
class RoomDataSourceImpl implements RoomDataSource {
  RoomDataSourceImpl(this.clientHttp);

  ClientHttp clientHttp;

  @override
  Future<HttpResponseModel> validateRoom({required String roomCode}) async {
    return await clientHttp.get(endpoint: "${Config.apiUrl}lobby/exists/$roomCode");
  }
}
