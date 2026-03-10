import 'package:curiosity_flutter/core/constants/path_icons.dart';
import 'package:curiosity_flutter/core/design/design.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutView extends StatefulWidget {
  const AboutView({super.key});

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  PackageInfo? packageInfo;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadData);
  }

  _loadData() async {
    packageInfo = await PackageInfo.fromPlatform();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageBuilder(
      title: "Acerca de",
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: colors.greyLight.withValues(alpha: .5), offset: Offset(0, 2), blurRadius: 10),
                ],
              ),
              child: Image(
                image: AssetImage(icons.app),
              ),
            ),
            height.xl,
            CustomText(
              "Curiosity",
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
            height.l,
            CustomText(
              "Versión ${packageInfo?.version} (Build ${packageInfo?.buildNumber})",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colors.paragraph,
            ),
            height.l,
            CustomText(
              "Desarrollado por:",
              fontSize: 12,
              color: colors.paragraph,
            ),
            CustomText(
              "Jhoan Silva (@JhoanSe7)",
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colors.paragraph,
            ),
            CustomText(
              "Carlos Santos (@titorodrigues17)",
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colors.paragraph,
            ),
            CustomText(
              "Unidades Tecnologicas de Santander",
              fontSize: 12,
              color: colors.paragraph,
            ),
            height.xl,
            CustomText(
              "© 2026 Curiosity",
              fontSize: 12,
              color: colors.primary,
            ),
            CustomText(
              "Todos los derechos reservados",
              fontSize: 12,
              color: colors.paragraph,
            )
          ],
        ),
      ),
    );
  }
}
