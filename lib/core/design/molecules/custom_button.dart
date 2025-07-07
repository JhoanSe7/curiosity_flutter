import 'package:curiosity_flutter/core/design/design.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final Color? backgroundColor;
  final Function()? onTap;

  const CustomButton({
    super.key,
    this.text,
    this.child,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomGestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient: backgroundColor == null ? LinearGradient(colors: colors.principal) : null,
          color: backgroundColor,
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
