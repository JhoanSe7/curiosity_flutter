import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/features/home/presentation/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colors.primary),
            ),
            child: CircleAvatar(
              backgroundColor: colors.white,
            ),
          ),
          SizedBox(height: 32),
          CustomText("${state.user?.firstName} ${state.user?.lastName}"),
          SizedBox(height: 32),
          CustomButton(
            text: "Cerrar Sesion",
            color: colors.secondary,
            onTap: () => _onExit(),
          )
        ],
      ),
    );
  }

  _onExit() async {
    final pref = await SharedPreferences.getInstance();
    pref.remove("user");
    ref.read(homeController.notifier).resetData();
    if (mounted) context.go(Routes.signIn);
  }
}
