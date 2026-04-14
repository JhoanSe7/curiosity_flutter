import 'package:curiosity_flutter/core/network/models/common_error.dart';
import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:curiosity_flutter/features/auth/data/models/sign_in_model.dart';
import 'package:curiosity_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthUseCase {
  final AuthRepository repository;

  AuthUseCase(this.repository);

  Future<Either<CommonError, UserModel>> signIn({required SignInModel data}) async =>
      await repository.signIn(data: data);

  Future<Either<CommonError, UserModel>> signUp({required UserModel data}) async => await repository.signUp(data: data);

  Future<Either<CommonError, UserModel>> updateToken({required String userId, required String tokenPush}) async =>
      await repository.updateToken(userId: userId, tokenPush: tokenPush);

  Future<Either<CommonError, UserModel>> sendOTP({required String email}) async =>
      await repository.sendOTP(email: email);

  Future<Either<CommonError, bool>> validateOTP({required String userId, required String code}) async =>
      await repository.validateOTP(userId: userId, code: code);

  Future<Either<CommonError, UserModel>> updateUser({required UserModel data}) async =>
      await repository.updateUser(data: data);

  Future<Either<CommonError, bool>> status() async => await repository.status();
}
