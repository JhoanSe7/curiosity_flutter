import 'package:curiosity_flutter/core/di/injection.dart';
import 'package:curiosity_flutter/core/utils/processor_utils.dart';
import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:curiosity_flutter/features/auth/domain/use_cases/auth_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'reset_password_state.dart';

class ResetPasswordController extends StateNotifier<ResetPasswordState> {
  ResetPasswordController(this.useCase) : super(ResetPasswordState());

  final AuthUseCase useCase;

  /// Envia codigo otp para restablecer contraseña
  Future<UserModel> sendOTP(BuildContext context, {required String email}) async {
    final result = await execute<UserModel>(context, useCase.sendOTP(email: email));
    return result.fold(
      (e) => processError(context, error: e.message) ?? UserModel(),
      (data) => data,
    );
  }

  /// Valida codigo otp para restablecer contraseña
  Future<bool> validateOTP(BuildContext context, {required String userId, required String code}) async {
    final result = await execute<bool>(context, useCase.validateOTP(userId: userId, code: code));
    return result.fold(
      (e) => processError(context, error: e.message) ?? false,
      (data) => data,
    );
  }

  /// Actualiza usuario
  Future<UserModel> updateUser(BuildContext context, {required UserModel data}) async {
    final result = await execute<UserModel>(context, useCase.updateUser(data: data));
    return result.fold(
      (e) => processError(context, error: e.message) ?? UserModel(),
      (data) => data,
    );
  }

  /// Guarda el usuario en el estado
  void saveUser(UserModel user) {
    if (mounted) state = state.copyWith(user: user);
  }

  /// Actualiza la contraseña
  Future<UserModel> sendNewPassword(BuildContext context, {required String password}) async {
    var data = state.user ?? UserModel()
      ..password = password;
    return await updateUser(context, data: data);
  }
}

final resetPasswordController = StateNotifierProvider<ResetPasswordController, ResetPasswordState>(
  (ref) => ResetPasswordController(getIt.get()),
);
