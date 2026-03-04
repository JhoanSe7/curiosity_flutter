import 'package:curiosity_flutter/core/design/tokens/colors.dart';
import 'package:curiosity_flutter/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrPreview extends StatelessWidget {
  const QrPreview({super.key, required this.code, this.size, this.color});

  final String code;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.scale(size ?? 100),
      width: context.scale(size ?? 100),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.inputBorder),
        boxShadow: [
          BoxShadow(color: colors.greyLight.withValues(alpha: .3), offset: Offset(0, 2), blurRadius: 6),
        ],
      ),
      child: PrettyQrView.data(
        data: code,
        decoration: PrettyQrDecoration(
          shape: PrettyQrShape.custom(
            PrettyQrSquaresSymbol(color: color ?? colors.primary),
            finderPattern: PrettyQrSmoothSymbol(color: color ?? colors.primary),
          ),
        ),
      ),
    );
  }
}
