import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:curiosity_flutter/features/home/presentation/home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/bottom_bar_widget.dart';

class HomeController extends StateNotifier<HomeState> {
  HomeController() : super(HomeState());

  void setMenuIndex(HomeId id) {
    state = state.copyWith(menuId: id);
  }

  void setUser({required UserModel? data}) {
    if (mounted) state = state.copyWith(user: data);
  }

  void resetData() {
    if (mounted) state = state.copyWith(menuId: HomeId.init, user: null);
  }
}

final homeController = StateNotifierProvider<HomeController, HomeState>((ref) => HomeController());
