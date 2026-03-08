import 'package:curiosity_flutter/core/constants/path_icons.dart';
import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/utils/extensions/dimension_extension.dart';
import 'package:curiosity_flutter/features/home/presentation/widgets/dashboard_view.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_controller.dart';
import 'widgets/bottom_bar_widget.dart';
import 'widgets/profile_view.dart';
import 'widgets/quizzes_view.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeController);
    return CustomPageBuilder(
      loadingPage: state.isLoading,
      leading: avatarWidget(),
      trailing: actions,
      customTitle: titleWidget(state.user?.firstName ?? ""),
      body: optionMenu(state.menuId, state.quizzes),
      bottomBar: BottomBarWidget(state.menuId),
    );
  }

  Widget optionMenu(HomeId id, List<QuizModel> quizzes) => switch (id) {
        HomeId.init => DashboardView(),
        HomeId.quizzes => QuizzesView(quizzes: [], toHome: true),
        HomeId.achievement => SizedBox.shrink(),
        HomeId.profile => ProfileView(),
      };

  Widget avatarWidget() {
    return CircleAvatar(
      backgroundImage: AssetImage(icons.app),
      radius: context.scale(20),
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
          fontSize: 14,
          color: colors.white,
        ),
      ],
    );
  }

  Widget actions = Expanded(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomCircularButton(
          icon: Icons.notifications_none,
          onTap: () {},
        ),
        width.m,
        CustomCircularButton(
          icon: Icons.settings_outlined,
          onTap: () {},
        ),
      ],
    ),
  );
}
