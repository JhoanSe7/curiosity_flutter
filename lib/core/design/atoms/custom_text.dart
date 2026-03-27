import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/utils/extensions/dimension_extension.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final List<Shadow>? shadows;
  final TextOverflow? overflow;
  final Paint? foreground;
  final double? height;

  const CustomText(
    this.text, {
    super.key,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.shadows,
    this.overflow,
    this.foreground,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.center,
      maxLines: maxLines,
      overflow: overflow,
      style: styles.poppins(
        fontSize: context.scale(fontSize),
        fontWeight: fontWeight,
        color: color,
        shadows: shadows,
        foreground: foreground,
        height: height,
      ),
    );
  }
}
