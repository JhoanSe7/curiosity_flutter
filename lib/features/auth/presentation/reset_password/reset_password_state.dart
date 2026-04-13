import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';

class ResetPasswordState {
  final UserModel? user;

  ResetPasswordState({
    this.user,
  });

  ResetPasswordState copyWith({
    UserModel? user,
  }) =>
      ResetPasswordState(
        user: user ?? this.user,
      );
}
