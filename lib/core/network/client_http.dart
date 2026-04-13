import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:curiosity_flutter/core/utils/extensions/http_extension.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../constants/config.dart';
import 'models/http_response.dart';

@injectable
class ClientHttp {
  final log = Logger('ClientHttpClass');
  Client http = Client();

  Future<HttpResponseModel> get({required String endpoint, bool getFile = false}) async {
    try {
      var response = await http.get(Uri.parse(endpoint), headers: Config.headers);
      if (!getFile) response.inspect("");
      if (getFile) return response.parseFile();
      return response.validate();
    } on TimeoutException catch (e) {
      log.warning("GET Timeout http request to $endpoint: $e");
      return HttpResponseModel(success: false, message: "Problemas de conexion");
    } on SocketException catch (e) {
      log.warning("GET SocketException http request to $endpoint: $e");
      return HttpResponseModel(success: false, message: "Sin conexion a internet");
    } catch (e) {
      log.warning("GET Error http request to $endpoint: $e");
      return HttpResponseModel(success: false, message: "Problemas tecnicos");
    }
  }

  Future<HttpResponseModel> post({required String endpoint, required dynamic body}) async {
    try {
      var response = await http.post(Uri.parse(endpoint), body: jsonEncode(body), headers: Config.headers);
      response.inspect(body);
      return response.validate();
    } on TimeoutException catch (e) {
      log.warning("POST Timeout http request to $endpoint: $e");
      return HttpResponseModel(success: false, message: "Problemas de conexion");
    } on SocketException catch (e) {
      log.warning("POST SocketException http request to $endpoint: $e");
      return HttpResponseModel(success: false, message: "Sin conexion a internet");
    } catch (e) {
      log.warning("POST Error http request to $endpoint: $e");
      return HttpResponseModel(success: false, message: "Problemas tecnicos");
    }
  }
}
