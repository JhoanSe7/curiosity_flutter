import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/core/utils/extensions/text_extension.dart';
import 'package:curiosity_flutter/core/utils/filters/input_filters.dart';
import 'package:curiosity_flutter/features/auth/presentation/reset_password/reset_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'widgets/main_header_widget.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  String error1 = "";

  @override
  Widget build(BuildContext context) {
    return CustomPageBuilder(
      title: "Recuperar Contraseña",
      body: Column(
        children: [
          height.xl,
          MainHeaderWidget(
            icon: Icons.security,
            title: "Te enviaremos un código",
            text: "Ingresa el correo electronico asociado a tu cuenta. "
                "Te enviaremos un codigo de verificación para restablecer tu contraseña",
          ),
          height.xl,
          CustomTextField(
            label: "Correo Electronico",
            iconLabel: Icons.email_outlined,
            iconBackground: colors.gradientPrimary,
            controller: _emailController,
            inputType: TextInputType.emailAddress,
            formatters: InputFilters.email(),
            onChange: (_) => setState(() => error1 = ""),
            textError: error1,
          ),
        ],
      ),
      bottomBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: CustomButton(
          onTap: _sendOTP,
          isGradient: true,
          large: true,
          height: 16,
          text: "Enviar código",
        ),
      ),
    );
  }

  Future<void> _sendOTP() async {
    final valid = _validateData();
    if (valid) await _handleRecovery();
  }

  bool _validateData() {
    if (_emailController.text.isEmpty) {
      error1 = "Digite su correo electronico";
    } else if (!_emailController.text.isEmail) {
      error1 = "Correo electronico no valido";
    } else {
      error1 = "";
    }
    setState(() {});
    return error1.isEmpty;
  }

  Future<void> _handleRecovery() async {
    final controller = ref.read(resetPasswordController.notifier);
    var user = await controller.sendOTP(context, email: _emailController.text);
    controller.saveUser(user);
    if ((user.id ?? "").isNotEmpty) {
      if (mounted) context.push(Routes.validateOTP);
    }
  }
}
