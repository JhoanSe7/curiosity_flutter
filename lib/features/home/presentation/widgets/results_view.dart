import 'package:curiosity_flutter/core/design/design.dart';
import 'package:flutter/material.dart';

class ResultsView extends StatelessWidget {
  const ResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPageBuilder(
      title: "Resultados",
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CustomText(
              "Sin resultados",
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            height.m,
            CustomText(
              "Cuando finalices un quiz, tus resultados se visualizaran aqui",
              fontSize: 14,
              color: colors.paragraph,
            )
          ],
        ),
      ),
    );
  }
}
