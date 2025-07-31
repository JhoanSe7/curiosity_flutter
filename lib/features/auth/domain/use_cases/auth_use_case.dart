import 'package:curiosity_flutter/core/network/models/common_error.dart';
import 'package:curiosity_flutter/features/auth/data/models/response/auth_response_model.dart';
import 'package:curiosity_flutter/features/auth/data/models/sign_in_model.dart';
import 'package:curiosity_flutter/features/auth/data/models/sign_up_model.dart';
import 'package:curiosity_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthUseCase {
  final AuthRepository repository;

  AuthUseCase(this.repository);

  Future<Either<CommonError, AuthResponseModel>> signIn({required SignInModel data}) async =>
      await repository.signIn(data: data);

  Future<Either<CommonError, AuthResponseModel>> signUp({required SignUpModel data}) async =>
      await repository.signUp(data: data);
}
