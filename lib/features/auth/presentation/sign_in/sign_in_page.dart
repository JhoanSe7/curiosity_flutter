import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/core/utils/utils.dart';
import 'package:curiosity_flutter/features/auth/presentation/sign_in/sign_in_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();

  String error1 = "";
  String error2 = "";

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
                CustomTextField(
                  label: "Correo Electronico",
                  iconLabel: Icons.email_outlined,
                  iconBackground: colors.principal,
                  controller: userController,
                  inputType: TextInputType.emailAddress,
                  formatters: InputFilters.email(),
                  onChange: (_) => _clearError(true),
                  textError: error1,
                ),
                styles.h(Size.l),
                CustomTextField(
                  label: "Contraseña",
                  iconLabel: Icons.lock_outline,
                  iconBackground: colors.secondary,
                  controller: passController,
                  password: true,
                  inputType: TextInputType.visiblePassword,
                  formatters: InputFilters.passwd(),
                  onChange: (_) => _clearError(false),
                  textError: error2,
                ),
                styles.h(Size.l),
                // LoginButtonWidget(),
                CustomButton(
                  onTap: _userLogin,
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
                  onTap: _goToRegister,
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

  //Functions
  _userLogin() async {
    final valid = _validateData();
    if (valid) await _handleLogin();
  }

  bool _validateData() {
    if (userController.text.isEmpty) {
      error1 = "Digite su correo electronico";
    } else if (!userController.text.isEmail) {
      error1 = "Correo electronico no valido";
    } else {
      error1 = "";
    }
    if (passController.text.isEmpty) {
      error2 = "Digite su contraseña";
    } else {
      error2 = "";
    }
    setState(() {});
    return error1.isEmpty && error2.isEmpty;
  }

  _handleLogin() async {
    final controller = ref.read(signInController.notifier);
    final login = await controller.logIn(context, userController.text, passController.text);
    if (login) {
      if (mounted) context.go(Routes.home);
    }
  }

  _clearError(bool user) {
    if (user) {
      error1 = "";
    } else {
      error2 = "";
    }
    setState(() {});
  }

  _goToRegister() {
    context.push(Routes.signUp);
  }
}
