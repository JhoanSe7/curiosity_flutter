import 'package:curiosity_flutter/core/design/design.dart';
import 'package:flutter/material.dart';

class MainHeaderWidget extends StatelessWidget {
  const MainHeaderWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: CustomIcon(
            icon,
            size: 40,
            color: colors.primary,
          ),
        ),
        height.xl,
        CustomText(
          title,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        height.m,
        Padding(
          padding: EdgeInsets.all(16),
          child: CustomText(
            text,
            fontSize: 14,
            color: colors.paragraph,
          ),
        ),
      ],
    );
  }
}
