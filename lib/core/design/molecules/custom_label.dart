import 'package:curiosity_flutter/core/design/design.dart';
import 'package:flutter/material.dart';

class CustomLabel extends StatelessWidget {
  final String text;
  final IconData? icon;
  final List<Color> iconBackground;
  final Color? iconColor;

  const CustomLabel({
    super.key,
    required this.text,
    this.icon,
    required this.iconBackground,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: iconBackground),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor ?? colors.white, size: 14),
          ),
          width.m
        ],
        CustomText(
          text,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ],
    );
  }
}
