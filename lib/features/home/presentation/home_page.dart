import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/features/home/presentation/widgets/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_controller.dart';
import 'widgets/bottom_bar_widget.dart';
import 'widgets/profile_view.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeController);
    return CustomPageBuilder(
      leading: avatarWidget(),
      trailing: actions(),
      customTitle: titleWidget(state.user?.firstName ?? ""),
      body: optionMenu(state.menuId),
      bottomBar: BottomBarWidget(state.menuId),
    );
  }

  Widget optionMenu(HomeId id) => switch (id) {
        HomeId.init => DashboardView(),
        HomeId.explore => DashboardView(),
        HomeId.achievement => DashboardView(),
        HomeId.profile => ProfileView(),
      };

  Widget avatarWidget() {
    return CircleAvatar(
      backgroundColor: colors.white,
    );
  }

  Widget titleWidget(String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          "¡Hola, $name!",
          color: colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        CustomText(
          "Listo para aprender",
          fontType: FontType.h6,
          color: colors.white,
        ),
      ],
    );
  }

  Widget actions() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomCircularButton(
            icon: Icons.notifications_none,
            onTap: () {},
          ),
          SizedBox(width: 8),
          CustomCircularButton(
            icon: Icons.settings_outlined,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
