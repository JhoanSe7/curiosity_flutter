import 'dart:async';

import 'package:curiosity_flutter/core/utils/extensions/http_extension.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import 'models/http_response.dart';

@injectable
class ClientHttp {
  final log = Logger('ClientHttpClass');
  Client http = Client();

  Future<HttpResponseModel> get({required String endpoint}) async {
    try {
      var response = await http.get(Uri.parse(endpoint));
      response.inspect();
      return response.validate();
    } on TimeoutException catch (e) {
      log.warning("GET Timeout http request to $endpoint: $e");
      return HttpResponseModel(status: false);
    } catch (e) {
      log.warning("GET Error http request to $endpoint: $e");
      return HttpResponseModel(status: false);
    }
  }

  Future<HttpResponseModel> post({required String endpoint, required dynamic body}) async {
    try {
      var response = await http.post(Uri.parse(endpoint), body: body);
      response.inspect();
      return response.validate();
    } on TimeoutException catch (e) {
      log.warning("POST Timeout http request to $endpoint: $e");
      return HttpResponseModel(status: false);
    } catch (e) {
      log.warning("POST Error http request to $endpoint: $e");
      return HttpResponseModel(status: false);
    }
  }
}
