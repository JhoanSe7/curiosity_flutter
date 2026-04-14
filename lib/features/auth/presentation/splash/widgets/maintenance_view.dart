import 'package:curiosity_flutter/core/constants/path_animations.dart';
import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class MaintenanceView extends StatelessWidget {
  const MaintenanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPageBuilder(
      enableAppbar: false,
      enableScrollable: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            decoration: BoxDecoration(
              color: colors.white,
              shape: BoxShape.circle,
            ),
            child: CustomIcon(
              Icons.settings_outlined,
              size: 40,
              color: colors.primary,
            ),
          ),
          height.xl,
          CustomText(
            "App en mantenimiento",
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          height.m,
          Padding(
            padding: EdgeInsets.all(16),
            child: CustomText(
              "Estamos realizando mejoras en la plataforma para brindarte una experiencia increible. "
              "Estaremos de vuelta pronto.",
              fontSize: 14,
              color: colors.paragraph,
            ),
          ),
          height.xl,
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.inputBorder),
            ),
            child: Row(
              children: [
                Lottie.asset(animations.pulse, width: 32),
                width.m,
                Flexible(
                  child: Column(
                    children: [
                      CustomText(
                        "Servicios detenidos temporalmente",
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      CustomText(
                        "Tiempo estimado: ~30 min",
                        fontSize: 14,
                        color: colors.paragraph,
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      bottomBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: CustomButton(
          text: "Volver a intentar",
          height: 16,
          isGradient: true,
          large: true,
          gradientColor: colors.gradientSecondary,
          onTap: () => context.pushReplacement(Routes.root),
        ),
      ),
    );
  }
}
