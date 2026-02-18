import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/features/home/presentation/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomBarWidget extends ConsumerWidget {
  final HomeId id;

  BottomBarWidget(this.id, {super.key});

  final List<ActionsMenu> actions = [
    ActionsMenu(HomeId.init, "Inicio", Icons.home_outlined),
    ActionsMenu(HomeId.explore, "Explorar", Icons.search),
    ActionsMenu(HomeId.achievement, "Logros", Icons.emoji_events_outlined),
    ActionsMenu(HomeId.profile, "Perfil", Icons.person_outline),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.only(bottom: 12,left: 8, right: 8, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: actions
            .map(
              (e) => CustomGestureDetector(
                onTap: () => ref.read(homeController.notifier).setMenuIndex(e.id),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  width: 75,
                  decoration: BoxDecoration(
                    color: id == e.id ? colors.primary.withValues(alpha: .2) : colors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        e.icon,
                        color: id == e.id ? colors.aquamarine : colors.iconPlaceholder,
                        size: 30,
                      ),
                      CustomText(
                        e.text,
                        fontType: FontType.h6,
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

class ActionsMenu {
  HomeId id;
  String text;
  IconData icon;

  ActionsMenu(this.id, this.text, this.icon);
}

enum HomeId {
  init,
  explore,
  achievement,
  profile,
}
