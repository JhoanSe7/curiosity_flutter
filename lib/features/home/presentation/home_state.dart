import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';

import 'widgets/bottom_bar_widget.dart';

class HomeState {
  final HomeId menuId;
  final UserModel? user;

  HomeState({
    this.menuId = HomeId.init,
    this.user,
  });

  HomeState copyWith({
    HomeId? menuId,
    UserModel? user,
  }) =>
      HomeState(
        menuId: menuId ?? this.menuId,
        user: user ?? this.user,
      );
}
