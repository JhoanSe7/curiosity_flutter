import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          quickAccessWidget(),
          SizedBox(height: 32),
          beginWidget(),
          SizedBox(height: 32),
          questionnairesWidget(),
        ],
      ),
    );
  }

  Widget quickAccessWidget() {
    return Column(
      children: [
        subtitleWidget("Acciones Rápidas", Icons.electric_bolt_outlined, colors.yellow),
        SizedBox(height: 16),
        Row(
          children: [
            quickAccessButton(
              "Crear Quiz",
              "Diseña tu\ncuestionario",
              Icons.add,
              colors.gradientSecondary,
              () => context.push(Routes.questionary),
            ),
            SizedBox(width: 16),
            quickAccessButton(
              "Unirse",
              "Código de quiz",
              Icons.numbers,
              colors.gradientPrimary,
              () {},
            ),
          ],
        )
      ],
    );
  }

  Widget subtitleWidget(String text, IconData icon, Color color) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
        ),
        SizedBox(width: 8),
        CustomText(
          text,
          fontType: FontType.title,
        ),
      ],
    );
  }

  Widget quickAccessButton(
    String title,
    String desc,
    IconData icon,
    List<Color> bgColor,
    void Function() onTap,
  ) {
    return Expanded(
      child: CustomGestureDetector(
        onTap: onTap,
        child: Container(
          height: context.height * .18,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: colors.greyLight, offset: Offset(0, 3), blurRadius: 10),
            ],
            gradient: LinearGradient(
              colors: bgColor,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: colors.white.withValues(alpha: .3),
                ),
                child: Icon(
                  icon,
                  color: colors.white,
                ),
              ),
              SizedBox(height: 8),
              CustomText(
                title,
                color: colors.white,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 4),
              CustomText(
                desc,
                color: colors.white,
                fontType: FontType.h6,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget beginWidget() {
    return Column(
      children: [
        subtitleWidget("¿Cómo empezar?", Icons.star_border, colors.yellow),
        SizedBox(height: 16),
        CustomCard(
          subtitle: "Paso 1",
          title: "Crea tu primer quiz",
          desc: "Diseña preguntas divertidas sobre cualquier tema que te apasione",
          icon: Icons.add,
          bgColor: colors.gradientPurple,
          color: colors.purple,
          enableShadow: true,
        ),
        SizedBox(height: 16),
        CustomCard(
          subtitle: "Paso 2",
          title: "Comparte el código",
          desc: "Invita a tus amigos a jugar usando el código unico de tu quiz",
          icon: Icons.numbers,
          bgColor: colors.gradientPrimary,
          color: colors.aquamarine,
          enableShadow: true,
        ),
        SizedBox(height: 16),
        CustomCard(
          subtitle: "Paso 3",
          title: "Juega y aprende",
          desc: "Compite en tiempo real y descubre quién sabe más",
          icon: Icons.electric_bolt_outlined,
          bgColor: colors.gradientYellow,
          color: colors.orange,
          enableShadow: true,
        ),
      ],
    );
  }

  Widget questionnairesWidget() {
    return Column(
      children: [
        subtitleWidget("Mis Cuestionarios", Icons.menu_book, colors.purple),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
              color: colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.inputBorder)),
          child: Column(
            children: [
              GenericLogo(),
              SizedBox(height: 16),
              CustomText(
                "¡Tu primer custionario te espera!",
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
              SizedBox(height: 16),
              CustomText(
                "Crea cuestionarios increibles y comparte tu conocimiento con el mundo",
                fontType: FontType.h5,
                color: colors.paragraph,
              ),
              SizedBox(height: 16),
              CustomButton(
                onTap: () => context.push(Routes.questionary),
                width: 24,
                height: 12,
                isGradient: true,
                gradientColor: colors.gradientPurple,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add,
                      color: colors.white,
                    ),
                    SizedBox(width: 16),
                    CustomText(
                      "Crear mi primer quiz",
                      color: colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
