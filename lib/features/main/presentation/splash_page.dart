import 'package:curiosity_flutter/core/constants/config.dart';
import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/core/services/notification_service.dart';
import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:curiosity_flutter/features/home/presentation/home_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), _initialize);
  }

  Future<void> _initialize() async {
    // await notificationSvc.initialize();
    await _validLogin();
  }

  _validLogin() async {
    if (kDebugMode) {
      final pref = await SharedPreferences.getInstance();
      var user = pref.getStringList("user") ?? [];
      if (user.isNotEmpty) {
        final data = UserModel.fromList(user);
        ref.read(homeController.notifier).setUser(data: data);
        if (mounted) context.go(Routes.home);
        return;
      }
    }
    if (mounted) context.go(Routes.signIn);
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
