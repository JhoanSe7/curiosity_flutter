import 'package:curiosity_flutter/core/network/models/common_error.dart';
import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:curiosity_flutter/features/auth/data/models/sign_in_model.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<CommonError, UserModel>> signIn({required SignInModel data});

  Future<Either<CommonError, UserModel>> signUp({required UserModel data});
}
