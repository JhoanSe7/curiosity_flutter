import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShowMoreWidget extends StatelessWidget {
  const ShowMoreWidget(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(Routes.quizzesList),
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text,
              fontSize: 14,
              color: colors.darkGreen,
              fontWeight: FontWeight.w600,
            ),
            CustomIcon(
              Icons.arrow_forward_ios,
              size: 14,
              color: colors.darkGreen,
            )
          ],
        ),
      ),
    );
  }
}
