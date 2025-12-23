import 'package:curiosity_flutter/core/di/injection.dart';
import 'package:curiosity_flutter/core/utils/failure_util.dart';
import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:curiosity_flutter/features/auth/data/models/sign_up_model.dart';
import 'package:curiosity_flutter/features/auth/domain/use_cases/auth_use_case.dart';
import 'package:curiosity_flutter/features/auth/presentation/sign_up/sign_up_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpController extends StateNotifier<SignUpState> {
  SignUpController(this.useCase) : super(SignUpState());
  final AuthUseCase useCase;

  Future<UserModel?> signUp(BuildContext context, {required SignUpModel data}) async {
    final result = await useCase.signUp(data: data);
    return result.fold(
      (e) => processError<UserModel>(context, error: e.message),
      (data) => data.user,
    );
  }

  void setUser({required UserModel? data}) {
    if (mounted) state = state.copyWith(user: data);
  }

  Future<bool> register(BuildContext context, SignUpModel data) async {
    final res = await signUp(context, data: data);
    if (res != null) {
      setUser(data: res);
      return true;
    }
    return false;
  }
}

final signUpController = StateNotifierProvider.autoDispose<SignUpController, SignUpState>(
  (ref) => SignUpController(
    getIt.get(),
  ),
);
