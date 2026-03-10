import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/utils/extensions/message_extension.dart';
import 'package:curiosity_flutter/features/home/data/models/support_model.dart';
import 'package:curiosity_flutter/features/home/presentation/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SupportView extends ConsumerStatefulWidget {
  const SupportView({super.key});

  @override
  ConsumerState<SupportView> createState() => _SupportViewState();
}

class _SupportViewState extends ConsumerState<SupportView> {
  final _titleController = TextEditingController();
  final _detailController = TextEditingController();
  String issuesType = "";

  int error = 0;

  List<String> options = [
    "Problema Tecnico",
    "Problema con la cuenta",
    "Sugerencia o mejora",
    "Otro problema",
  ];

  @override
  Widget build(BuildContext context) {
    return CustomPageBuilder(
      title: "Ayuda y Soporte",
      body: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            height.xl,
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.white,
                shape: BoxShape.circle,
              ),
              child: CustomIcon(
                Icons.help_outline,
                size: 40,
                color: colors.primary,
              ),
            ),
            height.l,
            CustomText(
              "¿Cómo te ayudamos?",
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            height.l,
            CustomText(
              "Crea un ticket describiendo tu problema y nuestro equipo te responderá pronto.",
              fontSize: 14,
              color: colors.paragraph,
            ),
            height.l,
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    label: "Título del problema",
                    placeHolder: "Ej: Error al conectar camara",
                    controller: _titleController,
                    textError: error == 1 ? "El título es requerido" : "",
                    dense: true,
                    onChange: (_) => _setError(0),
                  ),
                  height.l,
                  CustomText(
                    "Tipo de pregunta",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  height.m,
                  CustomDropdownButton(
                    items: options.map((e) => ItemModel(title: e, value: e)).toList(),
                    onSelect: _issuesType,
                    borderColor: colors.primary,
                    height: 48,
                  ),
                  if (error == 2) ...[
                    height.m,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        "El tipo de problema es requerido",
                        color: colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ],
                  height.l,
                  CustomTextField(
                    label: "Descripción",
                    maxLines: 3,
                    placeHolder: "Describe detalladamente lo que ocurrió",
                    controller: _detailController,
                    textError: error == 3 ? "La descripción es requerida" : "",
                    onChange: (_) => _setError(0),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomBar: Padding(
        padding: EdgeInsets.all(16),
        child: CustomButton(
          text: "Enviar Ticket",
          large: true,
          onTap: _sendTicket,
          height: 16,
        ),
      ),
    );
  }

  _issuesType(String? value) {
    issuesType = value ?? "";
  }

  _sendTicket() {
    bool invalid = _validateFields();
    if (invalid) return;
    var data = SupportModel(
      title: _titleController.text,
      issuesType: issuesType,
      description: _detailController.text,
    );
    ref.read(homeController.notifier).sendReport(data: data);
    context.pop();
    context.showToast(text: "Ticket enviado con exito");
  }

  bool _validateFields() {
    var titleEmpty = _titleController.text.isEmpty;
    var detailEmpty = _detailController.text.isEmpty;
    var issuesTypeEmpty = issuesType.isEmpty;
    if (titleEmpty) {
      _setError(1);
    } else if (issuesTypeEmpty) {
      _setError(2);
    } else if (detailEmpty) {
      _setError(3);
    }

    return titleEmpty || detailEmpty || issuesTypeEmpty;
  }

  _setError(int code) {
    if (mounted) {
      setState(() {
        error = code;
      });
    }
  }
}
