import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'questionary_controller.dart';

class QuestionaryPage extends ConsumerStatefulWidget {
  const QuestionaryPage({super.key});

  @override
  ConsumerState<QuestionaryPage> createState() => _QuestionaryPageState();
}

class _QuestionaryPageState extends ConsumerState<QuestionaryPage> {
  @override
  Widget build(BuildContext context) {
    return CustomPageBuilder(
      customTitle: titleWidget(),
      appbarColor: colors.gradientPurple,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 16),
            GenericLogo(
              complementOut: true,
              size: 60,
              complementSize: 25,
            ),
            SizedBox(height: 32),
            CustomText(
              "¿Cómo quieres crear tu quiz?",
              fontType: FontType.title,
            ),
            SizedBox(height: 8),
            CustomText(
              "Elije el metodo que prefieras",
              fontType: FontType.h5,
              color: colors.paragraph,
            ),
            SizedBox(height: 32),
            CustomCard(
              onTap: _generateQuiz,
              subtitle: "IA AUTOMÁTICA",
              title: "Generar con IA",
              desc: "Describe tu tema y deja que la IA cree preguntas inteligentes automaticamente",
              icon: Icons.star_border,
              bgColor: colors.gradientPurple,
              color: colors.purple,
              tag: "RÁPIDO",
              enableBorder: true,
            ),
            SizedBox(height: 32),
            CustomCard(
              onTap: _createCustom,
              subtitle: "PERSONALIZADO",
              title: "Crear Manualmente",
              desc: "Diseña cada pregunta a tu gusto con total control y creatividad",
              icon: Icons.edit,
              bgColor: colors.gradientPrimary,
              color: colors.aquamarine,
              enableBorder: true,
            ),
          ],
        ),
      ),
    );
  }

  _createCustom() {
    ref.read(questionaryController.notifier).clearAll();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (mounted) context.push(Routes.createQuiz);
      },
    );
  }

  _generateQuiz() {
    ref.read(questionaryController.notifier).clearAll();
    context.push(Routes.generateQuiz);
  }

  Widget titleWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          "Crear Cuestionario",
          color: colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        CustomText(
          "Elije como empezar",
          fontType: FontType.h6,
          color: colors.white,
        ),
      ],
    );
  }
}
