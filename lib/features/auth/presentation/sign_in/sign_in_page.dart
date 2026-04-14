import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/core/utils/utils.dart';
import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:curiosity_flutter/features/auth/presentation/sign_in/sign_in_controller.dart';
import 'package:curiosity_flutter/features/home/presentation/home_controller.dart';
import 'package:curiosity_flutter/features/home/presentation/widgets/bottom_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  String error1 = "";
  String error2 = "";

  @override
  Widget build(BuildContext context) {
    return CustomPageBuilder(
      enableAppbar: false,
      enablePadding: false,
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
                      style: styles.poppins(color: colors.yellow, fontSize: context.scale(16)),
                    ),
                    TextSpan(
                      text: "Aprende ● Juega ● Descubre",
                      style: styles.poppins(
                        color: colors.white,
                        fontSize: context.scale(14),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: " ★",
                      style: styles.poppins(color: colors.yellow, fontSize: context.scale(16)),
                    ),
                  ],
                ),
              ),
              height.s,
              CustomText(
                "Tu aventura educativa comienza aqui",
                fontSize: 12,
                color: colors.white,
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: context.scale(22) ?? 22, horizontal: context.scale(16) ?? 16),
            color: colors.background,
            child: Column(
              children: [
                CustomText(
                  "¡Bienvenido de vuelta!",
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                CustomText(
                  "Continua tu viaje de aprendizaje",
                  fontSize: 12,
                  color: colors.paragraph,
                ),
                height.l,
                CustomTextField(
                  label: "Correo Electronico",
                  iconLabel: Icons.email_outlined,
                  iconBackground: colors.gradientPrimary,
                  controller: _userController,
                  inputType: TextInputType.emailAddress,
                  formatters: InputFilters.email(),
                  onChange: (_) => setState(() => error1 = ""),
                  textError: error1,
                ),
                height.l,
                CustomTextField(
                  label: "Contraseña",
                  iconLabel: Icons.lock_outline,
                  iconBackground: colors.gradientSecondary,
                  controller: _passController,
                  password: true,
                  inputType: TextInputType.visiblePassword,
                  formatters: InputFilters.passwd(),
                  onChange: (_) => setState(() => error2 = ""),
                  onEdited: _userLogin,
                  textError: error2,
                ),
                height.l,
                CustomButton(
                  onTap: _userLogin,
                  isGradient: true,
                  height: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIcon(
                        Icons.emoji_events_outlined,
                        size: 16,
                        color: colors.white,
                      ),
                      height.m,
                      CustomText(
                        "¡Comenzar a Explorar!",
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: colors.white,
                      ),
                      height.m,
                      CustomIcon(
                        Icons.star_border,
                        size: 16,
                        color: colors.white,
                      ),
                    ],
                  ),
                ),
                height.l,
                CustomGestureDetector(
                  onTap: _recovery,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    child: CustomText(
                      "¿Olvidaste tu contraseña? 🤔",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colors.aquamarine,
                    ),
                  ),
                ),
                height.xl,
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Divider(indent: 24, endIndent: 24),
                    Container(
                      width: 60,
                      color: colors.background,
                      child: CustomText(
                        "o",
                        fontSize: 14,
                        color: colors.paragraph,
                      ),
                    )
                  ],
                ),
                height.xl,
                CustomText(
                  "¿Primera vez en Curiosity?",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colors.paragraph,
                ),
                height.l,
                CustomGestureDetector(
                  onTap: _goToRegister,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    child: CustomText(
                      "¡Únete gratis y aprende!",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colors.aquamarine,
                    ),
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
  Future<void> _userLogin() async {
    final valid = _validateData();
    if (valid) await _handleLogin();
  }

  bool _validateData() {
    if (_userController.text.isEmpty) {
      error1 = "Digite su correo electronico";
    } else if (!_userController.text.isEmail) {
      error1 = "Correo electronico no valido";
    } else {
      error1 = "";
    }
    if (_passController.text.isEmpty) {
      error2 = "Digite su contraseña";
    } else {
      error2 = "";
    }
    setState(() {});
    return error1.isEmpty && error2.isEmpty;
  }

  Future<void> _handleLogin() async {
    final controller = ref.read(signInController.notifier);
    UserModel? user = await controller.logIn(context, _userController.text, _passController.text);
    if (user != null && (user.id ?? "").isNotEmpty) {
      final pref = await SharedPreferences.getInstance();
      var localToken = pref.getString("tokenFCM") ?? "";
      user = await _validateTokenPush(user, localToken);
      final dashController = ref.read(homeController.notifier);
      dashController.setUser(data: user);
      dashController.setMenuIndex(HomeId.init);
      if (mounted) context.go(Routes.home);
    }
  }

  Future<UserModel> _validateTokenPush(UserModel user, String localToken) async {
    final controller = ref.read(signInController.notifier);
    if (localToken.isNotEmpty && localToken != user.tokenPush) {
      return await controller.updateToken(context, userId: user.id ?? "", tokenPush: localToken);
    } else {
      return user;
    }
  }

  void _goToRegister() {
    context.push(Routes.signUp);
  }

  void _recovery() {
    context.push(Routes.requestOTP);
  }
}
