import 'package:curiosity_flutter/core/di/injection.dart';
import 'package:curiosity_flutter/core/utils/failure_util.dart';
import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:curiosity_flutter/features/auth/data/models/sign_in_model.dart';
import 'package:curiosity_flutter/features/auth/domain/use_cases/auth_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sign_in_state.dart';

class SignInController extends StateNotifier<SignInState> {
  SignInController(this.useCase) : super(SignInState());

  final AuthUseCase useCase;

  Future<UserModel?> signIn({required SignInModel data}) async {
    final result = await useCase.signIn(data: data);
    return result.fold(
      (e) => processError(e.message),
      (data) => data.user,
    );
  }

  void setUser({required UserModel? data}) {
    if (mounted) state = state.copyWith(user: data);
  }

  Future<void> logIn(String user, String passwd) async {
    final data = SignInModel(username: user, password: passwd);
    final res = await signIn(data: data);
    setUser(data: res);
  }
}

final signInController = StateNotifierProvider.autoDispose<SignInController, SignInState>((ref) => SignInController(
      getIt.get(),
    ));
