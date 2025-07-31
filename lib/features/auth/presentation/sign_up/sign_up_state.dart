import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';

class SignUpState {
  final UserModel? user;

  SignUpState({this.user});

  SignUpState copyWith({
    UserModel? user,
  }) =>
      SignUpState(
        user: user ?? this.user,
      );
}
