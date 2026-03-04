import 'package:curiosity_flutter/core/design/design.dart';
import 'package:flutter/material.dart';

class SubtitleWidget extends StatelessWidget {
  const SubtitleWidget(this.text, this.icon, this.color, {super.key});

  final String text;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomIcon(
          icon,
          color: color,
        ),
        width.m,
        CustomText(
          text,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }
}
