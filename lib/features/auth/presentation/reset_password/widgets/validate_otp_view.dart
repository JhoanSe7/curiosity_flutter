import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/design/templates/countdown_timer.dart';
import 'package:curiosity_flutter/core/design/templates/customs_pinput_widget.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/core/utils/extensions/message_extension.dart';
import 'package:curiosity_flutter/features/auth/presentation/reset_password/reset_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'main_header_widget.dart';

class ValidateOtpView extends ConsumerStatefulWidget {
  const ValidateOtpView({super.key});

  @override
  ConsumerState<ValidateOtpView> createState() => _ValidateOtpViewState();
}

class _ValidateOtpViewState extends ConsumerState<ValidateOtpView> {
  String codeOTP = "";
  String error = "";
  int attempts = 2;

  bool timeUp = false;

  @override
  Widget build(BuildContext context) {
    return CustomPageBuilder(
      title: "Verificar código",
      body: Column(
        children: [
          height.xl,
          MainHeaderWidget(
            icon: Icons.mail_outline,
            title: "Ingresa tu código",
            text: "Hemos enviado un código de seguridad de 6 digitos a tu correo electronico.",
          ),
          height.xl,
          CustomsPinputWidget(
            onCompleted: _onInput,
            onChange: _onInput,
            error: error.isNotEmpty,
          ),
          if (error.isNotEmpty) ...[height.m, CustomText(error, fontSize: 12, color: colors.error)],
          height.l,
          expirationWidget(),
          height.xl,
          resendCodeWidget(),
        ],
      ),
      bottomBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: CustomButton(
          onTap: _validateCode,
          isGradient: true,
          large: true,
          height: 16,
          text: "Verificar código",
        ),
      ),
    );
  }

  Widget expirationWidget() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colors.white,
        border: BoxBorder.all(color: colors.inputBorder),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIcon(
            Icons.access_time,
            color: colors.iconPlaceholder,
          ),
          width.m,
          CustomText(
            "El código expira en",
            fontSize: 14,
            color: colors.paragraph,
          ),
          width.m,
          CountdownTimer(
            key: ValueKey("Key-$attempts"),
            duration: Duration(seconds: 10),
            onFinished: _onCountdown,
          ),
        ],
      ),
    );
  }

  Widget resendCodeWidget() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(8),
        border: BoxBorder.all(color: colors.inputBorder),
      ),
      child: Column(
        children: [
          CustomText(
            "¿No recibiste el código?",
            fontSize: 14,
            color: colors.paragraph,
          ),
          height.l,
          CustomButton(
            onTap: _resendCode,
            color: colors.inactiveButton.withValues(alpha: .2),
            border: BoxBorder.all(color: colors.inputBorder),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIcon(
                  Icons.refresh,
                  color: colors.primary,
                ),
                width.m,
                CustomText(
                  "Solicitar nuevo código",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onInput(String code) async {
    codeOTP = code;
    setState(() => error = "");
  }

  Future<void> _validateCode() async {
    final controller = ref.read(resetPasswordController.notifier);
    final state = ref.read(resetPasswordController);
    if (codeOTP.isNotEmpty && codeOTP.length == 6) {
      var success = await controller.validateOTP(context, userId: state.user?.id ?? "", code: codeOTP);
      if (success) {
        if (mounted) context.push(Routes.createPassword);
      } else {
        if (mounted) await context.showModal(title: "Validación fallida", content: "El código es incorrecto");
        timeUp = true;
        codeOTP = "";
        await _resendCode();
      }
    } else {
      setState(() => error = "Digite el código de verificacion");
    }
  }

  void _onCountdown() {
    timeUp = true;
  }

  Future<void> _resendCode() async {
    if (attempts == 0) {
      var res = await context.showModal(title: "Validación fallida", content: "No tienes mas intentos");
      if (res as bool) if (mounted) context.go(Routes.signIn);
      return;
    }
    if (timeUp) {
      await _handleCode();
      setState(() {
        attempts--;
        timeUp = false;
        codeOTP = "";
      });
    } else {
      context.showToast(text: "El tiempo de espera no ha expirado", type: MessageType.warning);
    }
  }

  Future<void> _handleCode() async {
    final controller = ref.read(resetPasswordController.notifier);
    final state = ref.read(resetPasswordController);
    var user = await controller.sendOTP(context, email: state.user?.email ?? "");
    controller.saveUser(user);
    if ((user.id ?? "").isNotEmpty) {
      if (mounted) context.showToast(text: "Se ha enviado un nuevo código", type: MessageType.success);
    }
  }
}
