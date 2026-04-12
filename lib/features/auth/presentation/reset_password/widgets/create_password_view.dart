import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/core/utils/extensions/message_extension.dart';
import 'package:curiosity_flutter/core/utils/filters/input_filters.dart';
import 'package:curiosity_flutter/features/auth/presentation/reset_password/reset_password_controller.dart';
import 'package:curiosity_flutter/features/home/presentation/home_controller.dart';
import 'package:curiosity_flutter/features/home/presentation/widgets/bottom_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'main_header_widget.dart';

class CreatePasswordView extends ConsumerStatefulWidget {
  const CreatePasswordView({super.key});

  @override
  ConsumerState<CreatePasswordView> createState() => _CreatePasswordViewState();
}

class _CreatePasswordViewState extends ConsumerState<CreatePasswordView> {
  final TextEditingController _passwdController = TextEditingController();
  final TextEditingController _rePasswdController = TextEditingController();

  String error1 = "";
  String error2 = "";

  @override
  Widget build(BuildContext context) {
    return CustomPageBuilder(
      title: "Nueva contraseña",
      enableLeading: false,
      centerTitle: true,
      trailing: CustomCircularButton(
        icon: Icons.close,
        onTap: _exit,
      ),
      body: Column(
        children: [
          height.xl,
          MainHeaderWidget(
            icon: Icons.lock_outline,
            title: "Crea una nueva contraseña",
            text: "Tu nueva contraseña debe ser diferente de las utilizadas anteriormente.",
          ),
          height.xl,
          CustomTextField(
            controller: _passwdController,
            label: "Nueva Contraseña",
            iconLabel: Icons.lock_outline,
            iconBackground: colors.gradientViolet,
            inputType: TextInputType.text,
            formatters: InputFilters.passwd(),
            password: true,
            textError: error1,
            onChange: (_) => _validateFields(),
            showStrengthLevel: true,
          ),
          height.l,
          CustomTextField(
            controller: _rePasswdController,
            label: "Confirmar Contraseña",
            iconLabel: Icons.lock_outline,
            iconBackground: colors.gradientMagenta,
            inputType: TextInputType.text,
            formatters: InputFilters.passwd(),
            password: true,
            textError: error2,
            onChange: (_) => _validateFields(),
          ),
          height.l,
        ],
      ),
      bottomBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: CustomButton(
          onTap: _createPassword,
          isGradient: true,
          large: true,
          height: 16,
          text: "Reestablecer contraseña",
        ),
      ),
    );
  }

  Future<void> _exit() async {
    final res = await context.showModal(
      title: "Salir",
      content: "Estas seguro que deseas salir",
      buttonText: "Abandonar",
      showClose: true,
      iconColor: colors.red,
      buttonColor: colors.red,
    );
    if (res as bool) if (mounted) context.go(Routes.signIn);
  }

  void _validateFields() {
    String required = "Campo obligatorio";
    if (_passwdController.text.isEmpty) return setState(() => error1 = required);
    if (_rePasswdController.text.isEmpty) return setState(() => error2 = required);

    setState(() {
      error1 = "";
      error2 = "";
    });
  }

  Future<void> _createPassword() async {
    if (error1.isNotEmpty && error2.isNotEmpty) return;
    if (_passwdController.text != _rePasswdController.text) return setState(() => error2 = "Contraseñas no coinciden");
    final controller = ref.read(resetPasswordController.notifier);
    var user = await controller.sendNewPassword(context, password: _passwdController.text.trim());
    if ((user.id ?? "").isNotEmpty) {
      final dashController = ref.read(homeController.notifier);
      dashController.setUser(data: user);
      dashController.setMenuIndex(HomeId.init);
      if (mounted) context.go(Routes.home);
    }
  }
}
