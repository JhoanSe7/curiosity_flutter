import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

  Logger log = Logger('Util');
class UtilPage {
  void autoScroll(BuildContext context) {
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<bool> get isHuawei async {
    if (Platform.isIOS) return false;
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final manufacturer = androidInfo.manufacturer.toLowerCase();
    return manufacturer.contains('huawei');
  }

  Future<void> launchURL(
    String url, {
    LaunchMode mode = LaunchMode.externalApplication,
    bool showWebViewJavaScript = true,
    bool enableDomStorage = true,
    String? webOnlyWindowName,
  }) async {
    try {
      final Uri uri = Uri.parse(url);

      // if (!await canLaunchUrl(uri)) {
      //   throw Exception('No se puede abrir la URL: $url');
      // }

      await launchUrl(
        uri,
        mode: mode,
        webViewConfiguration: WebViewConfiguration(
          enableJavaScript: showWebViewJavaScript,
          enableDomStorage: enableDomStorage,
        ),
        webOnlyWindowName: webOnlyWindowName,
      );
    } catch (e) {
      log.warning("Error al abrir la URL: $e");
    }
  }
}

final view = UtilPage();
