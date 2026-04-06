import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/utils/extensions/dimension_extension.dart';
import 'package:curiosity_flutter/features/home/presentation/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomBarWidget extends ConsumerWidget {
  final HomeId id;

  BottomBarWidget(this.id, {super.key});

  final List<ActionsMenu> actions = [
    ActionsMenu(HomeId.init, "Inicio", Icons.home_outlined),
    ActionsMenu(HomeId.quizzes, "Quizzes", Icons.menu_book),
    ActionsMenu(HomeId.scores, "Notas", Icons.emoji_events_outlined),
    ActionsMenu(HomeId.profile, "Perfil", Icons.person_outline),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.only(bottom: 12, left: 8, right: 8, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: actions
            .map(
              (e) => CustomGestureDetector(
                onTap: () => _tapOption(ref, e.id),
                child: Container(
                  padding: EdgeInsets.all(4),
                  width: context.scale(75),
                  height: context.scale(60),
                  decoration: BoxDecoration(
                    color: id == e.id ? colors.primary.withValues(alpha: .2) : colors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIcon(
                        e.icon,
                        color: id == e.id ? colors.aquamarine : colors.iconPlaceholder,
                        size: 24,
                      ),
                      CustomText(
                        e.text,
                        fontSize: 12,
                        color: id == e.id ? colors.aquamarine : colors.paragraph,
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

void _tapOption(WidgetRef ref, HomeId id) {
  final controller = ref.read(homeController.notifier);
  controller.setMenuIndex(id);
  switch (id) {
    case HomeId.init:
    case HomeId.profile:
      controller.setScroll(true);
    case HomeId.quizzes:
    case HomeId.scores:
      controller.setScroll(false);
  }
}

class ActionsMenu {
  HomeId id;
  String text;
  IconData icon;

  ActionsMenu(this.id, this.text, this.icon);
}

enum HomeId {
  init,
  quizzes,
  scores,
  profile,
}
