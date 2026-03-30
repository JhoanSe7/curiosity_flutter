import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuizCreateCardWidget extends StatelessWidget {
  const QuizCreateCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.inputBorder),
      ),
      child: Column(
        children: [
          GenericLogo(),
          height.l,
          CustomText(
            "¡Tu primer custionario te espera!",
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
          height.l,
          CustomText(
            "Crea cuestionarios increibles y comparte tu conocimiento con el mundo",
            color: colors.paragraph,
            fontSize: 16,
          ),
          height.l,
          CustomButton(
            onTap: () => context.push(Routes.questionary),
            width: 24,
            height: 12,
            isGradient: true,
            gradientColor: colors.gradientPurple,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIcon(
                  Icons.add,
                  color: colors.white,
                ),
                width.l,
                CustomText(
                  "Crear mi primer quiz",
                  color: colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
