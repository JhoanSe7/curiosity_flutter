import 'package:curiosity_flutter/core/design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomPageBuilder(
      enableAppbar: false,
      body: Column(
        children: [
          CustomHeader(
            title: "Curiosity",
            additionalWidget: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "★ ",
                      style: styles.poppins(color: colors.yellow, fontSize: 18),
                    ),
                    TextSpan(
                      text: "Aprende ● Juega ● Descubre",
                      style: styles.poppins(color: colors.white, fontType: FontType.b),
                    ),
                    TextSpan(
                      text: " ★",
                      style: styles.poppins(color: colors.yellow, fontSize: 18),
                    ),
                  ],
                ),
              ),
              styles.h(Size.s),
              CustomText(
                "Tu aventura educativa comienza aqui",
                fontType: FontType.h6,
                color: colors.white,
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 22, horizontal: 16),
            color: colors.background,
            child: Column(
              children: [
                CustomText(
                  "¡Bienvenido de vuelta!",
                  fontType: FontType.h2,
                  fontWeight: FontWeight.w700,
                ),
                CustomText(
                  "Continua tu viaje de aprendizaje",
                  fontSize: 12,
                  color: colors.paragraph,
                ),
                styles.h(Size.l),
                labelInput("Correo Electronico", Icons.email_outlined, colors.principal),
                styles.h(Size.l),
                CustomTextField(
                  controller: userController,
                ),
                styles.h(Size.l),
                labelInput("Contraseña", Icons.lock_outline, colors.secondary),
                styles.h(Size.l),
                CustomTextField(
                  controller: passController,
                  password: true,
                ),
                styles.h(Size.l),
                // LoginButtonWidget(),
                CustomButton(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.emoji_events_outlined,
                        size: 16,
                        color: colors.white,
                      ),
                      styles.w(Size.m),
                      CustomText(
                        "¡Comenzar a Explorar!",
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: colors.white,
                      ),
                      styles.w(Size.m),
                      Icon(
                        Icons.star_border,
                        size: 16,
                        color: colors.white,
                      ),
                    ],
                  ),
                ),
                styles.h(Size.l),
                CustomGestureDetector(
                  onTap: () {},
                  child: CustomText(
                    "¿Olvidaste tu contraseña? 🤔",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.secondGreen,
                  ),
                ),
                styles.h(Size.xl),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Divider(indent: 24, endIndent: 24),
                    Container(
                      width: 60,
                      color: colors.background,
                      child: CustomText(
                        "o",
                        fontType: FontType.h6,
                        color: colors.paragraph,
                      ),
                    )
                  ],
                ),
                styles.h(Size.xl),
                CustomText(
                  "¿Primera vez en Curiosity?",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colors.paragraph,
                ),
                styles.h(Size.l),
                CustomGestureDetector(
                  onTap: () {},
                  child: CustomText(
                    "¡Únete gratis y aprende!",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.secondGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  labelInput(String text, IconData icon, List<Color> color) {
    return Row(
      children: [
        iconInput(icon, color),
        styles.w(Size.m),
        CustomText(
          text,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ],
    );
  }

  iconInput(IconData icon, List<Color> color) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: colors.white, size: 14),
    );
  }
}
