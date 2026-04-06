import 'package:curiosity_flutter/core/constants/path_icons.dart';
import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/core/services/notification_service.dart';
import 'package:curiosity_flutter/core/utils/util_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

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
    await _permissionRequest();
    if (!(await view.isHuawei)) await notificationSvc.initialize();
    if (mounted) context.go(Routes.signIn);
  }

  Future<void> _permissionRequest() async {
    await [
      Permission.camera,
      Permission.storage,
      Permission.manageExternalStorage,
      Permission.photos,
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageBuilder(
      enableAppbar: false,
      enableScrollable: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: colors.gradientMagenta,
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: CustomSvg(
              icons.brain,
              size: 100,
            ),
          ),
          height.l,
          CustomText(
            "Curiosity",
            fontSize: 32,
            fontWeight: FontWeight.w400,
            color: colors.secondary,
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
                color: colors.secondary,
                value: value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
