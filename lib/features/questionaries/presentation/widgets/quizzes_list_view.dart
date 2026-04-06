import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/features/home/presentation/home_controller.dart';
import 'package:curiosity_flutter/features/home/presentation/widgets/quizzes_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class QuizzesListView extends ConsumerStatefulWidget {
  const QuizzesListView({super.key});

  @override
  ConsumerState<QuizzesListView> createState() => _QuizzesListViewState();
}

class _QuizzesListViewState extends ConsumerState<QuizzesListView> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeController);
    return CustomPageBuilder(
      enablePadding: false,
      enableScrollable: false,
      customTitle: titleWidget(state.quizzes.length),
      trailing: actions(),
      body: QuizzesView(),
    );
  }

  Widget titleWidget(int length) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          "Mis Cuestionarios",
          color: colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        CustomText(
          length > 1 ? "$length cuestionarios creados" : "$length cuestionario creado",
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
            icon: Icons.add,
            onTap: () => context.push(Routes.questionary),
          ),
        ],
      ),
    );
  }
}
