import 'package:curiosity_flutter/core/di/injection.dart';
import 'package:curiosity_flutter/core/utils/util_processor.dart';
import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:curiosity_flutter/features/auth/data/models/sign_in_model.dart';
import 'package:curiosity_flutter/features/auth/domain/use_cases/auth_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sign_in_state.dart';

class SignInController extends StateNotifier<SignInState> {
  SignInController(this.useCase) : super(SignInState());

  final AuthUseCase useCase;

  Future<UserModel> signIn(BuildContext context, {required SignInModel data}) async {
    final result = await execute<UserModel>(context, useCase.signIn(data: data));
    return result.fold(
      (e) => processError(context, error: e.message) ?? UserModel(),
      (data) => data,
    );
  }

  Future<UserModel?> logIn(BuildContext context, String user, String passwd) async {
    final data = SignInModel(email: user.trim(), password: passwd.trim());
    final res = await signIn(context, data: data);
    return res;
  }
}

final signInController = StateNotifierProvider.autoDispose<SignInController, SignInState>(
  (ref) => SignInController(
    getIt.get(),
  ),
);
