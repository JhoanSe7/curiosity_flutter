import 'dart:convert';

import 'package:curiosity_flutter/core/network/models/http_response.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';

extension HttpExtension on Response {
  HttpResponseModel validate() {
    final log = Logger('HttpExtension->validate');
    try {
      bool status = false;
      dynamic body;
      switch (statusCode) {
        case 200:
        case 201:
        case 202:
          status = true;
          body = utf8.decode(bodyBytes);
          break;
        default:
          status = false;
          break;
      }
      return HttpResponseModel(status: status, body: body);
    } catch (e) {
      log.warning("Error HttpUtils: $e");
      return HttpResponseModel(status: false, body: body);
    }
  }

  void inspect() {
    final log = Logger('HttpExtension->inspect');
    print('---=== START API ===---');
    log.info('Request: ${request?.method} ${request?.url}');
    log.info('Status: $statusCode');
    log.info('Body: $body');
    print('---=== END API ===---');
  }
}
