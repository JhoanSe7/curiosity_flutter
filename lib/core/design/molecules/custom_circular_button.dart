import 'package:curiosity_flutter/core/design/design.dart';
import 'package:flutter/material.dart';

class CustomCircularButton extends StatelessWidget {
  final IconData icon;
  final void Function() onTap;
  final Color? color;
  final Color? backgroundColor;
  final double? size;

  const CustomCircularButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color,
    this.backgroundColor,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return CustomGestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: backgroundColor ?? colors.white.withValues(alpha: .3),
          shape: BoxShape.circle,
        ),
        child: CustomIcon(
          icon,
          color: color ?? colors.white,
          size: size,
        ),
      ),
    );
  }
}
