import 'package:curiosity_flutter/core/design/tokens/colors.dart';
import 'package:flutter/material.dart';

class QrScanAreaOverlayWidget extends StatelessWidget {
  const QrScanAreaOverlayWidget({
    super.key,
    required this.width,
    required this.height,
    required this.scanAreaSize,
  });

  final double width;
  final double height;
  final double scanAreaSize;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _QrScanAreaOverlayPainter(scanAreaSize: scanAreaSize),
      size: Size(width, height),
    );
  }
}

class _QrScanAreaOverlayPainter extends CustomPainter {
  _QrScanAreaOverlayPainter({
    required this.scanAreaSize,
  });

  final double scanAreaSize;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  @override
  void paint(Canvas canvas, Size size) {
    final scanSize = size.width * scanAreaSize;
    final scanRect = Rect.fromCenter(
      center: Offset(size.width / 2.0, size.height / 2.1),
      width: scanSize,
      height: scanSize,
    );

    final overlayPaint = Paint()
      ..color = colors.primary.withValues(alpha: 0.50)
      ..style = PaintingStyle.fill;

    final overlayPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(scanRect, const Radius.circular(12.0)))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(overlayPath, overlayPaint);

    drawCorners(canvas, scanRect);
  }

  void drawCorners(Canvas canvas, Rect rect) {
    final cornerPaint = Paint()
      ..color = colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    const size = 80.0;
    const padding = 12.0;
    const radius = 24.0;

    // Superior izquierda
    final pathTL = Path()
      ..moveTo(rect.left - padding, rect.top - padding + size)
      ..lineTo(rect.left - padding, rect.top - padding + radius)
      ..arcToPoint(
        Offset(rect.left - padding + radius, rect.top - padding),
        radius: const Radius.circular(radius),
      )
      ..lineTo(rect.left - padding + size, rect.top - padding);
    canvas.drawPath(pathTL, cornerPaint);

    // Superior derecha
    final pathTR = Path()
      ..moveTo(rect.right + padding - size, rect.top - padding)
      ..lineTo(rect.right + padding - radius, rect.top - padding)
      ..arcToPoint(
        Offset(rect.right + padding, rect.top - padding + radius),
        radius: const Radius.circular(radius),
      )
      ..lineTo(rect.right + padding, rect.top - padding + size);
    canvas.drawPath(pathTR, cornerPaint);

    // Inferior izquierda
    final pathBL = Path()
      ..moveTo(rect.left - padding + size, rect.bottom + padding)
      ..lineTo(rect.left - padding + radius, rect.bottom + padding)
      ..arcToPoint(
        Offset(rect.left - padding, rect.bottom + padding - radius),
        radius: const Radius.circular(radius),
      )
      ..lineTo(rect.left - padding, rect.bottom + padding - size);
    canvas.drawPath(pathBL, cornerPaint);

    // Inferior derecha
    final pathBR = Path()
      ..moveTo(rect.right + padding, rect.bottom + padding - size)
      ..lineTo(rect.right + padding, rect.bottom + padding - radius)
      ..arcToPoint(
        Offset(rect.right + padding - radius, rect.bottom + padding),
        radius: const Radius.circular(radius),
      )
      ..lineTo(rect.right + padding - size, rect.bottom + padding);
    canvas.drawPath(pathBR, cornerPaint);
  }
}
