import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:curiosity_flutter/core/network/token_storage.dart';
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
      var response = await http.get(Uri.parse(endpoint), headers: Config.headers).timeout(Duration(seconds: 60));
      if (!getFile) response.inspect("");
      if (response.statusCode == 401) {
        return await _handleUnauthorized(isGet: true, endpoint: endpoint);
      }
      if (getFile) return response.parseFile();
      return response.validate();
    } on TimeoutException catch (e) {
      log.warning("GET Timeout http request to $endpoint: $e");
      return HttpResponseModel(success: false, message: ClientStatus.highLatency.message);
    } on SocketException catch (e) {
      log.warning("GET SocketException http request to $endpoint: $e");
      return HttpResponseModel(success: false, message: ClientStatus.noConnection.message);
    } catch (e) {
      log.warning("GET Error http request to $endpoint: $e");
      return HttpResponseModel(success: false, message: ClientStatus.technicalIssues.message);
    }
  }

  Future<HttpResponseModel> post({required String endpoint, required dynamic body}) async {
    try {
      var response = await http.post(Uri.parse(endpoint), body: jsonEncode(body), headers: Config.headers);
      response.inspect(body);
      if (response.statusCode == 401) {
        return await _handleUnauthorized(isGet: false, endpoint: endpoint, body: body);
      }
      return response.validate();
    } on TimeoutException catch (e) {
      log.warning("POST Timeout http request to $endpoint: $e");
      return HttpResponseModel(success: false, message: ClientStatus.highLatency.message);
    } on SocketException catch (e) {
      log.warning("POST SocketException http request to $endpoint: $e");
      return HttpResponseModel(success: false, message: ClientStatus.noConnection.message);
    } catch (e) {
      log.warning("POST Error http request to $endpoint: $e");
      return HttpResponseModel(success: false, message: ClientStatus.technicalIssues.message);
    }
  }

  Future<HttpResponseModel> _handleUnauthorized({
    required bool isGet,
    required String endpoint,
    dynamic body,
  }) async {
    log.warning("401 detected — intentando renovar token");
    try {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        log.warning("No hay refresh token disponible");
        return HttpResponseModel(success: false, message: ClientStatus.expiredToken.message);
      }

      final refreshResponse = await http.post(
        Uri.parse("${Config.apiUrl}auth/refresh"),
        body: jsonEncode({"refreshToken": refreshToken}),
        headers: {"Content-Type": "application/json"},
      );

      if (refreshResponse.statusCode != 200) {
        log.warning("Refresh fallido: ${refreshResponse.statusCode}");
        await TokenStorage.clearTokens();
        Config.clearToken();
        return HttpResponseModel(success: false, message: ClientStatus.expiredToken.message);
      }

      final refreshData = jsonDecode(refreshResponse.body);
      final newAccessToken = refreshData['body']['accessToken'] as String;

      await TokenStorage.saveTokens(
        accessToken: newAccessToken,
        refreshToken: refreshToken,
      );
      Config.setToken(newAccessToken);
      log.info("Token renovado exitosamente");

      // reintentar petición original
      if (isGet) {
        final retry = await http.get(Uri.parse(endpoint), headers: Config.headers);
        return retry.validate();
      } else {
        final retry = await http.post(
          Uri.parse(endpoint),
          body: jsonEncode(body),
          headers: Config.headers,
        );
        return retry.validate();
      }
    } catch (e) {
      log.warning("Error renovando token: $e");
      return HttpResponseModel(success: false, message: ClientStatus.expiredToken.message);
    }
  }
}

enum ClientStatus {
  noConnection,
  technicalIssues,
  expiredToken,
  highLatency;

  String get message {
    switch (this) {
      case ClientStatus.noConnection:
        return 'Sin conexión a internet';
      case ClientStatus.technicalIssues:
        return 'Problemas técnicos';
      case ClientStatus.expiredToken:
        return 'Sesion expirada';
      case ClientStatus.highLatency:
        return 'Problemas de conexion';
    }
  }
}
