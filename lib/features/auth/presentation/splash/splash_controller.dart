import 'package:curiosity_flutter/core/di/injection.dart';
import 'package:curiosity_flutter/features/auth/domain/use_cases/auth_use_case.dart';
import 'package:curiosity_flutter/features/auth/presentation/splash/splash_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashController extends StateNotifier<SplashState> {
  SplashController(this.useCase) : super(SplashState());

  final AuthUseCase useCase;

  ///
  Future<bool> status(BuildContext context) async {
    final result = await useCase.status();
    return result.fold(
      (e) => false,
      (res) => res,
    );
  }
}

final splashController = StateNotifierProvider<SplashController, SplashState>(
  (ref) => SplashController(getIt.get()),
);
