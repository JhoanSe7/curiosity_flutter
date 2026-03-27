import 'package:curiosity_flutter/core/constants/path_icons.dart';
import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:curiosity_flutter/features/home/presentation/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeController);
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          titleProfile(),
          height.l,
          avatarProfile(),
          height.l,
          userInfo(state.user),
          height.m,
          badgeRole(),
          height.xl,
          userStats(state.user),
          height.m,
          actionButton(),
          height.xl,
          optionsList(),
        ],
      ),
    );
  }

  Widget titleProfile() {
    return CustomText(
      "Mi Perfil",
      fontSize: 18,
      fontWeight: FontWeight.w600,
    );
  }

  Widget avatarProfile() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: colors.gradientOrange),
        border: Border.all(color: colors.yellow, width: 2),
      ),
      child: CustomSvg(
        icons.king,
        color: colors.white,
        size: 90,
      ),
    );
  }

  Widget userInfo(UserModel? user) {
    return Column(
      children: [
        CustomText(
          "${user?.firstName ?? ""} ${user?.lastName ?? ""}",
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        CustomText(
          user?.email ?? "",
          fontSize: 14,
        ),
      ],
    );
  }

  Widget badgeRole() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors.gradientBlue),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomSvg(
            icons.star,
            size: 14,
          ),
          width.m,
          CustomText(
            "Beta Tester",
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colors.white,
          ),
        ],
      ),
    );
  }

  Widget userStats(UserModel? user) {
    var quizzes = user?.createdQuizzes ?? [];
    return Row(
      children: [
        statDetailCard("Salas Creadas", quizzes.length),
        statDetailCard("Participaciones", 0),
      ],
    );
  }

  Widget statDetailCard(String text, int value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.inputBorder),
        ),
        child: Column(
          children: [
            CustomText("$value", fontSize: 18, fontWeight: FontWeight.w700),
            CustomText(
              text,
              fontSize: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget optionsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          "Ajustes Generales",
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        height.l,
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.inputBorder),
          ),
          child: Column(
            children: [
              itemOptionCard(Icons.person_outline, "Informacion Personal", Routes.infoProfile),
              Divider(color: colors.inputBorder),
              itemOptionCard(Icons.notifications_none, "Notificaciones", Routes.notifications),
              Divider(color: colors.inputBorder),
              itemOptionCard(Icons.help_outline, "Ayuda y Soporte", Routes.support),
              Divider(color: colors.inputBorder),
              itemOptionCard(Icons.notifications_none, "Acerca de", Routes.about),
            ],
          ),
        ),
      ],
    );
  }

  Widget itemOptionCard(IconData icon, String text, String route) {
    return CustomGestureDetector(
      onTap: () => context.push(route),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CustomIcon(
              icon,
              size: 20,
              color: colors.primary,
            ),
            width.l,
            Expanded(
              child: CustomText(
                text,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.left,
              ),
            ),
            width.m,
            CustomIcon(
              Icons.chevron_right,
              size: 25,
              color: colors.iconPlaceholder,
            ),
          ],
        ),
      ),
    );
  }

  Widget actionButton() {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: CustomButton(
        textColor: colors.red,
        border: Border.all(color: colors.red),
        height: 16,
        color: colors.red.withValues(alpha: .1),
        onTap: _onExit,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIcon(
              Icons.exit_to_app,
              color: colors.red,
              size: 18,
            ),
            width.m,
            CustomText(
              "Cerrar Sesion",
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onExit() async {
    context.go(Routes.signIn);
  }
}
