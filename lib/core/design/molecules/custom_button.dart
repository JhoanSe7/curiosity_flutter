import 'package:curiosity_flutter/core/design/design.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final Color? color;
  final Color? textColor;
  final List<Color>? gradientColor;
  final Function()? onTap;
  final double? width;
  final double? height;
  final bool enable;
  final bool isGradient;

  const CustomButton({
    super.key,
    this.text,
    this.child,
    this.color,
    this.textColor,
    this.gradientColor,
    this.onTap,
    this.width,
    this.height,
    this.enable = true,
    this.isGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomGestureDetector(
      onTap: enable ? onTap : () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: height ?? 10, horizontal: width ?? 10),
        decoration: BoxDecoration(
          gradient: isGradient ? LinearGradient(colors: gradientColor ?? colors.gradientPrimary) : null,
          color: !isGradient
              ? enable
                  ? color
                  : colors.inactiveButton
              : null,
          borderRadius: BorderRadius.circular(14),
        ),
        child: child ??
            CustomText(
              text ?? "",
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: textColor ?? colors.white,
            ),
      ),
    );
  }
}
