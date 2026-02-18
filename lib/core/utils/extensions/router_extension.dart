import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension RouterExtension on BuildContext {
  // ***************************************************
  // Elimina la cola de navegacion hasta la ruta elegida
  // ***************************************************
  void removeUntil(String route) {
    final goRouter = GoRouter.of(this);

    while (goRouter.routerDelegate.currentConfiguration.matches.isNotEmpty) {
      final currentLocation = goRouter.routerDelegate.currentConfiguration.matches.last.matchedLocation;

      if (currentLocation == route) {
        break;
      }

      if (goRouter.canPop()) {
        goRouter.pop();
      }
    }
  }

  /// Tener cuidad al usar, solo para hacer pop en lugar explicitos
  void removeByQuantity(int cant) {
    final goRouter = GoRouter.of(this);
    for (var i = 0; i < cant; i++) {
      if (goRouter.canPop()) goRouter.pop();
    }
  }
}
