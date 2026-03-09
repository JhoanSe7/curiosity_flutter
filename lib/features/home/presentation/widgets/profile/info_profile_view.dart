import 'package:curiosity_flutter/core/constants/path_icons.dart';
import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/utils/extensions/dimension_extension.dart';
import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:curiosity_flutter/features/home/presentation/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InfoProfileView extends ConsumerWidget {
  const InfoProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(homeController).user;
    return CustomPageBuilder(
      title: "Información Personal",
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            avatarProfile(context),
            height.xl,
            userInfo(user),
          ],
        ),
      ),
    );
  }

  Widget avatarProfile(BuildContext context) {
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
    final obj = user?.information() ?? {};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: obj.entries
          .map(
            (e) => infoCard(getIcon(e.key), getText(e.key), e.value),
          )
          .toList(),
    );
  }

  Widget infoCard(IconData icon, String title, String data) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          Row(
            children: [
              CustomIcon(
                icon,
                size: 20,
                color: colors.iconPlaceholder,
              ),
              width.m,
              CustomText(
                data,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.paragraph,
              ),
            ],
          )
        ],
      ),
    );
  }

  IconData getIcon(UserParam param) {
    var data = {
      UserParam.name: Icons.person_outline,
      UserParam.email: Icons.email_outlined,
      UserParam.phone: Icons.phone_android_outlined,
    };
    return data[param] ?? Icons.circle_outlined;
  }

  String getText(UserParam param) {
    var data = {
      UserParam.name: "Nombre Completo",
      UserParam.email: "Correo Electronico",
      UserParam.phone: "Numero de Telefono",
    };
    return data[param] ?? "";
  }
}
