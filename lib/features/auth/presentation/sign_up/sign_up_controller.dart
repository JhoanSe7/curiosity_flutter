import 'package:curiosity_flutter/core/di/injection.dart';
import 'package:curiosity_flutter/core/utils/util_processor.dart';
import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:curiosity_flutter/features/auth/domain/use_cases/auth_use_case.dart';
import 'package:curiosity_flutter/features/auth/presentation/sign_up/sign_up_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpController extends StateNotifier<SignUpState> {
  SignUpController(this.useCase) : super(SignUpState());
  final AuthUseCase useCase;

  Future<UserModel> signUp(BuildContext context, {required UserModel data}) async {
    final result = await execute<UserModel>(context, useCase.signUp(data: data));
    return result.fold(
      (e) => processError(context, error: e.message) ?? UserModel(),
      (data) => data,
    );
  }

  Future<UserModel?> register(BuildContext context, UserModel data) async {
    final res = await signUp(context, data: data);
    return res;
  }
}

final signUpController = StateNotifierProvider.autoDispose<SignUpController, SignUpState>(
  (ref) => SignUpController(
    getIt.get(),
  ),
);
