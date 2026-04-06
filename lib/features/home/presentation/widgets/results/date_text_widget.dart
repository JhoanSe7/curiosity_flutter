import 'package:curiosity_flutter/core/design/design.dart';
import 'package:flutter/material.dart';

class DateTextWidget extends StatelessWidget {
  const DateTextWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomIcon(
          Icons.calendar_today_outlined,
          size: 18,
          color: colors.iconPlaceholder,
        ),
        width.s,
        Flexible(
          child: CustomText(
            text,
            fontSize: 14,
            color: colors.paragraph,
            fontWeight: FontWeight.w500,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}
