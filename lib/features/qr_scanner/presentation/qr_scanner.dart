import 'package:curiosity_flutter/core/design/tokens/colors.dart';
import 'package:curiosity_flutter/features/qr_scanner/data/models/qr_scanner_model.dart';
import 'package:flutter/material.dart';

import 'widgets/qr_scanner_widget.dart';

class QrScanner {
  QrScanner._();

  static Future<QrScannerModel> scan(BuildContext context,
      {String? title, String? subTitle, bool? showFlash, bool? showGallery}) async {
    final QrScannerModel? result = await Navigator.push<QrScannerModel>(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: false,
        barrierColor: colors.black,
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (context, animation, secondaryAnimation) {
          return QrScannerWidget(
            title: title ?? 'Escanear QR',
            subTitle: subTitle ?? 'Centra el QR en el recuadro',
            showFlash: showFlash ?? true,
            showGallery: showGallery ?? true,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const beginOffset = Offset(0.2, 0.0);
          const endOffset = Offset.zero;
          final slideTween = Tween(begin: beginOffset, end: endOffset).chain(CurveTween(curve: Curves.easeOutCubic));
          final fadeTween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeInOut));
          final scaleTween = Tween(begin: 0.98, end: 1.0).chain(CurveTween(curve: Curves.easeOut));

          return FadeTransition(
            opacity: animation.drive(fadeTween),
            child: SlideTransition(
              position: animation.drive(slideTween),
              child: ScaleTransition(
                scale: animation.drive(scaleTween),
                child: child,
              ),
            ),
          );
        },
      ),
    );

    return result ?? QrScannerModel(code: QrScanStatus.failed, rawValue: '');
  }
}
