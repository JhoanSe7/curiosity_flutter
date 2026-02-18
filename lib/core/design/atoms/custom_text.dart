import 'package:curiosity_flutter/core/design/design.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final FontType? fontType;
  final int? maxLines;
  final List<Shadow>? shadows;
  final TextOverflow? overflow;

  const CustomText(
    this.text, {
    super.key,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.fontType,
    this.maxLines,
    this.shadows,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.center,
      maxLines: maxLines,
      overflow: overflow,
      style: styles.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontType: fontType,
        shadows: shadows,
      ),
    );
  }
}
