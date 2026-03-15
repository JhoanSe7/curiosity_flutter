import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/utils/extensions/dimension_extension.dart';
import 'package:curiosity_flutter/features/qr_scanner/data/models/qr_scanner_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'qr_scan_area_overlay_widget.dart';

class QrScannerWidget extends StatefulWidget {
  const QrScannerWidget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.showFlash,
  });

  final String title;
  final String subTitle;
  final bool showFlash;

  @override
  State<QrScannerWidget> createState() => _QrScannerWidgetState();
}

class _QrScannerWidgetState extends State<QrScannerWidget> with WidgetsBindingObserver {
  late MobileScannerController controller;
  bool codeDetected = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      formats: [BarcodeFormat.qrCode],
      cameraResolution: const Size(1600, 1200),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        controller.start();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        controller.stop();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageBuilder(
      enableScrollable: false,
      title: widget.title,
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
              controller: controller,
              onDetect: onQrDetect,
              overlayBuilder: (context, constraints) {
                return QrScanAreaOverlayWidget(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  scanAreaSize: context.isTablet ? 0.50 : 0.70,
                );
              }),
          Positioned(
              top: 72,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: colors.white.withValues(alpha: .1),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIcon(
                        Icons.qr_code_2,
                        size: 52,
                        color: colors.white,
                      )),
                  height.m,
                  CustomText(
                    widget.subTitle,
                    textAlign: TextAlign.center,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: colors.white,
                  ),
                ],
              )),
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: (widget.showFlash)
                ? ValueListenableBuilder(
                    valueListenable: controller,
                    builder: (context, value, child) {
                      final isTorchOn = value.torchState == TorchState.on;
                      return buildButton(
                        icon: isTorchOn ? Icons.flashlight_on : Icons.flashlight_off,
                        label: 'Linterna',
                        onTap: onToggleFlash,
                      );
                    },
                  )
                : width.xl,
          ),
        ],
      ),
    );
  }

  Widget buildButton({required IconData icon, required String label, VoidCallback? onTap, double size = 48.0}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: colors.black.withValues(alpha: 0.40),
            shape: BoxShape.circle,
            border: Border.all(color: colors.white, width: 1),
          ),
          child: IconButton(
            icon: CustomIcon(icon, color: colors.white),
            iconSize: size / 2,
            onPressed: () => onTap?.call(),
          ),
        ),
        height.s,
        Stack(
          children: [
            CustomText(
              label,
              textAlign: TextAlign.center,
              fontSize: 14,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2.0
                ..color = colors.black.withValues(alpha: 0.40),
            ),
            CustomText(
              label,
              textAlign: TextAlign.center,
              fontSize: 14,
              color: colors.white,
            ),
          ],
        ),
      ],
    );
  }

  void onQrDetect(BarcodeCapture capture) {
    if (codeDetected) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? code = barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;

    if (mounted) setState(() => codeDetected = true);
    HapticFeedback.mediumImpact();
    handleComplete(code: QrScanStatus.success, rawValue: code);
  }

  Future<void> onToggleFlash() async {
    try {
      await controller.toggleTorch();
    } catch (e) {
      debugPrint('Error al alternar el flash: $e');
    }
  }

  void handleComplete({required QrScanStatus code, String? rawValue}) {
    QrScannerModel data = QrScannerModel(code: code, rawValue: rawValue ?? '');
    Navigator.pop<QrScannerModel>(context, data);
  }
}
