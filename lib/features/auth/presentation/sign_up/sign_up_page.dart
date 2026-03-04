import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/core/utils/utils.dart';
import 'package:curiosity_flutter/features/auth/data/models/field_name.dart';
import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:curiosity_flutter/features/auth/presentation/sign_up/sign_up_controller.dart';
import 'package:curiosity_flutter/features/home/presentation/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends ConsumerState<SignUpPage> {
  bool btnEnable = false;

  final labels = {
    FieldName.name1: "Primer Nombre",
    FieldName.name2: "Segundo Nombre (Opcional)",
    FieldName.lastName1: "Primer Apellido",
    FieldName.lastName2: "Segundo Apellido (Opcional)",
    FieldName.email: "Correo Electrónico",
    FieldName.phone: "Teléfono",
    FieldName.rol: "¿Cuál es tu rol?",
    FieldName.passwd: "Contraseña",
    FieldName.repass: "Confirmar Contraseña",
  };
  final iconLabels = {
    FieldName.name1: Icons.person_2_outlined,
    FieldName.name2: Icons.person_2_outlined,
    FieldName.lastName1: Icons.person_2_outlined,
    FieldName.lastName2: Icons.person_2_outlined,
    FieldName.email: Icons.email_outlined,
    FieldName.phone: Icons.phone_outlined,
    FieldName.rol: Icons.lock_outline,
    FieldName.passwd: Icons.lock_outline,
    FieldName.repass: Icons.lock_outline,
  };

  final iconColor = {
    FieldName.name1: colors.gradientPrimary,
    FieldName.name2: colors.gradientGrey,
    FieldName.lastName1: colors.gradientSecondary,
    FieldName.lastName2: colors.gradientPurple,
    FieldName.email: colors.gradientBlue,
    FieldName.phone: colors.gradientGreen,
    FieldName.rol: colors.gradientYellow,
    FieldName.passwd: colors.gradientMagenta,
    FieldName.repass: colors.gradientViolet,
  };

  final inputType = {
    FieldName.name1: TextInputType.text,
    FieldName.name2: TextInputType.text,
    FieldName.lastName1: TextInputType.text,
    FieldName.lastName2: TextInputType.text,
    FieldName.email: TextInputType.emailAddress,
    FieldName.phone: TextInputType.number,
    FieldName.rol: TextInputType.text,
    FieldName.passwd: TextInputType.text,
    FieldName.repass: TextInputType.text,
  };

  final inputFormat = {
    FieldName.name1: InputFilters.text(),
    FieldName.name2: InputFilters.text(),
    FieldName.lastName1: InputFilters.text(),
    FieldName.lastName2: InputFilters.text(),
    FieldName.email: InputFilters.email(),
    FieldName.phone: InputFilters.cellphone(),
    FieldName.rol: InputFilters.text(),
    FieldName.passwd: InputFilters.passwd(),
    FieldName.repass: InputFilters.passwd(),
  };

  final controllers = FieldName.values.asMap().map((_, value) => MapEntry(value, TextEditingController()));

  final errors = FieldName.values.asMap().map((_, value) => MapEntry(value, ""));

  List<String> roles = [
    "🎓 Estudiante",
    "👨‍🏫 Profesor",
    "⚙️ Administrador",
  ];

  List<String> desc = [
    "Aprendo y hago cuestionarios",
    "Creo contenido educativo",
    "Superviso el aprendizaje",
    "Gestiono la plataforma",
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageBuilder(
      enableAppbar: false,
      enableScrollable: false,
      body: Column(
        children: [
          CustomHeader(
            title: "Curiosity",
            decorationColor: colors.gradientGrey,
            additionalWidget: [
              CustomText(
                "¡Unete a la aventura!",
                fontSize: 14,
                color: colors.white,
              ),
            ],
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 22, horizontal: 16),
              color: colors.background,
              child: Column(
                children: [
                  CustomText(
                    "¡Crea tu cuenta!",
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  CustomText(
                    "Completa tus datos para comenzar",
                    fontSize: 14,
                    color: colors.paragraph,
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (var input in FieldName.values) ...[
                            height.l,
                            if (input == FieldName.rol)
                              _customField(input)
                            else
                              CustomTextField(
                                controller: controllers[input],
                                label: labels[input] ?? "",
                                iconLabel: iconLabels[input],
                                iconBackground: iconColor[input],
                                inputType: inputType[input] ?? TextInputType.text,
                                formatters: inputFormat[input],
                                password: input == FieldName.passwd || input == FieldName.repass,
                                textError: errors[input] ?? "",
                                onChange: (p0) => _validateFields(input),
                                showStrengthLevel: input == FieldName.passwd,
                              ),
                          ],
                          height.xl,
                          CustomButton(
                            onTap: _register,
                            isGradient: true,
                            width: 16,
                            enable: btnEnable,
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
                                  "¡Comenzar mi Aventura!",
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
                          height.xl,
                          CustomGestureDetector(
                            onTap: context.pop,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  "¿Ya tienes cuenta? ",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: colors.paragraph,
                                ),
                                CustomText(
                                  "¡Inicia sesion aquí! 🚀",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: colors.aquamarine,
                                )
                              ],
                            ),
                          ),
                          height.l,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _customField(FieldName input) {
    return Column(
      children: [
        CustomLabel(
          text: labels[input] ?? "",
          icon: iconLabels[input],
          iconBackground: iconColor[input] ?? colors.gradientPrimary,
        ),
        height.m,
        CustomDropdownButton(
          items: _items,
          hintText: "Selecciona tu rol",
          onSelect: (value) {
            controllers[input]?.text = value ?? "";
            _validateFields(input);
          },
        ),
        if ((errors[input] ?? "").isNotEmpty) ...[
          height.m,
          Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              errors[input] ?? "",
              color: colors.red,
              fontSize: 14,
            ),
          )
        ]
      ],
    );
  }

  List<ItemModel> get _items {
    List<ItemModel> list = [];
    for (int i = 0; i < roles.length; i++) {
      list.add(ItemModel(value: roles[i].cleaned, title: roles[i], subtitle: desc[i]));
    }
    return list;
  }

  _validateFields(FieldName key) {
    try {
      String required = "Campo obligatorio";
      if ((key == FieldName.name1 ||
              key == FieldName.lastName1 ||
              key == FieldName.phone ||
              key == FieldName.passwd ||
              key == FieldName.email ||
              key == FieldName.rol ||
              key == FieldName.repass) &&
          controllers[key]!.text.isEmpty) {
        setState(() {
          errors[key] = required;
        });
        return;
      }
      if (key == FieldName.email && !controllers[key]!.text.isEmail) {
        setState(() {
          errors[key] = "Correo electronico no valido";
        });
        return;
      }
      if (key == FieldName.repass && (controllers[FieldName.passwd]!.text != controllers[FieldName.repass]!.text)) {
        setState(() {
          errors[key] = "Contraseñas no coinciden";
        });
        return;
      }
      setState(() {
        errors[key] = "";
        btnEnable = !errors.values.any((e) => e.isNotEmpty);
      });
    } catch (e) {
      print("_validateFields() Error $e");
    }
  }

  _register() {
    _validateFields(FieldName.rol);
    if (btnEnable) _handleRegistry();
    controllers.forEach((key, value) => print("$key -> ${value.text}"));
  }

  _handleRegistry() async {
    final controller = ref.read(signUpController.notifier);
    final data = UserModel(
      firstName: controllers[FieldName.name1]?.text,
      secondName: controllers[FieldName.name2]?.text,
      lastName: controllers[FieldName.lastName1]?.text,
      secondLastName: controllers[FieldName.lastName2]?.text,
      email: controllers[FieldName.email]?.text,
      phoneNumber: controllers[FieldName.phone]?.text.replaceAll(" ", ""),
      role: controllers[FieldName.rol]?.text,
      password: controllers[FieldName.passwd]?.text,
    );
    final register = await controller.register(context, data);
    if (register != null && (register.firstName ?? "").isNotEmpty) {
      ref.read(homeController.notifier).setUser(data: register);
      if (mounted) context.go(Routes.home);
    }
  }
}
