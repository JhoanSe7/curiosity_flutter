import 'package:curiosity_flutter/core/constants/config.dart';
import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/core/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), goTo);
  }

  Future<void> goTo() async {
    await notificationSvc.initialize();
    if (mounted) context.go(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageBuilder(
      enableAppbar: false,
      enableScrollable: false,
      body: Column(
        children: [
          Spacer(),
          CustomText(
            "Curiosity",
            fontSize: 32,
            fontWeight: FontWeight.w400,
            color: colors.primary,
            shadows: [
              BoxShadow(offset: Offset(0, 2), blurRadius: 5, color: colors.paragraph),
            ],
          ),
          height.xl,
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(seconds: 2),
            builder: (_, value, e) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: LinearProgressIndicator(
                color: colors.primary,
                value: value,
              ),
            ),
          ),
          Spacer(),
          CustomText(
            "V${Config.versionApp} - ©2025",
            fontType: FontType.h6,
            color: colors.paragraph,
          ),
        ],
      ),
    );
  }
}
