import 'dart:convert';

import 'package:curiosity_flutter/core/network/models/http_response.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';

extension HttpExtension on Response {
  HttpResponseModel validate() {
    final log = Logger('HttpExtension->validate');
    try {
      return HttpResponseModel.fromJson(jsonDecode(body));
    } catch (e) {
      log.warning("Error HttpUtils: $e");
      return HttpResponseModel(success: false, body: body);
    }
  }

  void inspect(dynamic data) {
    final log = Logger('HttpExtension->inspect');
    log.info('---=== START API ===---');
    log.info('Request: ${request?.method} ${request?.url}');
    log.info('Status: $statusCode');
    log.info('Body: $data');
    log.info('Response: ${utf8.decode(bodyBytes)}');
    log.info('---=== END API ===---');
  }
}
