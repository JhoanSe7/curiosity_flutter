import 'package:curiosity_flutter/core/design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationsView extends ConsumerStatefulWidget {
  const NotificationsView({super.key});

  @override
  ConsumerState<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends ConsumerState<NotificationsView> {
  @override
  Widget build(BuildContext context) {
    return CustomPageBuilder(
      title: "Notificaciones",
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.inactiveButton.withValues(alpha: .3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: CustomIcon(
              Icons.notifications_off_outlined,
              size: 40,
              color: colors.iconPlaceholder,
            ),
          ),
          height.xl,
          CustomText(
            "Sin notificaciones nuevas",
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          height.m,
          Padding(
            padding: EdgeInsets.all(16),
            child: CustomText(
              "Cuando no tengas actividad pendiente, esta zona mostrará este estado vacio para indicarlo claramente",
              fontSize: 14,
              color: colors.paragraph,
            ),
          )
        ],
      ),
    );
  }
}
