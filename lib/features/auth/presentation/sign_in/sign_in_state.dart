import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';

class SignInState {
  final UserModel? user;

  SignInState({
    this.user,
  });

  SignInState copyWith({
    UserModel? user,
  }) =>
      SignInState(
        user: user ?? this.user,
      );
}
