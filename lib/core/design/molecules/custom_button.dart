import 'package:curiosity_flutter/core/design/design.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final Color? backgroundColor;
  final Function()? onTap;
  final double? width;
  final double? height;
  final bool enable;

  const CustomButton({
    super.key,
    this.text,
    this.child,
    this.backgroundColor,
    this.onTap,
    this.width,
    this.height,
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomGestureDetector(
      onTap: enable ? onTap : () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: width ?? 10, horizontal: height ?? 10),
        decoration: BoxDecoration(
          gradient: backgroundColor == null && enable ? LinearGradient(colors: colors.principal) : null,
          color: enable ? backgroundColor : colors.inactiveButton,
          borderRadius: BorderRadius.circular(14),
        ),
        child: child ??
            CustomText(
              text ?? "",
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: colors.white,
            ),
      ),
    );
  }
}
