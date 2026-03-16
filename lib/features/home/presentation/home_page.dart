import 'package:curiosity_flutter/core/constants/path_icons.dart';
import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/features/home/presentation/widgets/dashboard_view.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'home_controller.dart';
import 'widgets/bottom_bar_widget.dart';
import 'widgets/profile_view.dart';
import 'widgets/quizzes_view.dart';
import 'widgets/results_view.dart';

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
      trailing: actions(),
      customTitle: titleWidget(state.user?.firstName ?? ""),
      body: optionMenu(state.menuId, state.quizzes),
      bottomBar: BottomBarWidget(state.menuId),
    );
  }

  Widget optionMenu(HomeId id, List<QuizModel> quizzes) => switch (id) {
        HomeId.init => DashboardView(),
        HomeId.quizzes => QuizzesView(quizzes: [], toHome: true),
        HomeId.achievement => ResultsView(),
        HomeId.profile => ProfileView(),
      };

  Widget avatarWidget() {
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
        size: 20,
      ),
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

  Widget actions() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomCircularButton(
            icon: Icons.notifications_none,
            onTap: () => context.push(Routes.notifications),
          ),
          width.m,
          CustomCircularButton(
            icon: Icons.help_outline,
            onTap: () => context.push(Routes.support),
          ),
        ],
      ),
    );
  }
}
