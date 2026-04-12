import 'package:curiosity_flutter/core/network/models/common_error.dart';
import 'package:curiosity_flutter/features/auth/data/data_sources/auth_data_source.dart';
import 'package:curiosity_flutter/core/network/models/response/error_response_model.dart';
import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:curiosity_flutter/features/auth/data/models/sign_in_model.dart';
import 'package:curiosity_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<Either<CommonError, UserModel>> signIn({required SignInModel data}) async {
    try {
      final result = await dataSource.signIn(data: data);
      if (result.success) {
        return right(UserModel.fromJson(result.body));
      } else if (!result.success && result.body is Map<String, dynamic>) {
        final error = ErrorResponseModel.fromJson(result.body);
        return left(CommonError(message: "${error.message}(${error.errorCode})"));
      }
      throw (result.message ?? "No se pudo procesar los datos");
    } catch (e) {
      return left(CommonError(message: "Error signIn: $e"));
    }
  }

  @override
  Future<Either<CommonError, UserModel>> signUp({required UserModel data}) async {
    try {
      final result = await dataSource.signUp(data: data);
      if (result.success) {
        return right(UserModel.fromJson(result.body));
      } else if (!result.success && result.body is Map<String, dynamic>) {
        final error = ErrorResponseModel.fromJson(result.body);
        return left(CommonError(message: "${error.message}(${error.errorCode})"));
      }
      throw (result.message ?? "No se pudo procesar los datos");
    } catch (e) {
      return left(CommonError(message: "Error signUp: $e"));
    }
  }

  @override
  Future<Either<CommonError, UserModel>> updateToken({required String userId, required String tokenPush}) async {
    try {
      final result = await dataSource.updateToken(userId: userId, tokenPush: tokenPush);
      if (result.success) {
        return right(UserModel.fromJson(result.body));
      } else if (!result.success && result.body is Map<String, dynamic>) {
        final error = ErrorResponseModel.fromJson(result.body);
        return left(CommonError(message: "${error.message}(${error.errorCode})"));
      }
      throw (result.message ?? "No se pudo procesar los datos");
    } catch (e) {
      return left(CommonError(message: "Error updateToken: $e"));
    }
  }

  @override
  Future<Either<CommonError, UserModel>> sendOTP({required String email}) async {
    try {
      final result = await dataSource.sendOTP(email: email);
      if (result.success) {
        return right(UserModel.fromJson(result.body));
      } else if (!result.success && result.body is Map<String, dynamic>) {
        final error = ErrorResponseModel.fromJson(result.body);
        return left(CommonError(message: "${error.message}(${error.errorCode})"));
      }
      throw (result.message ?? "No se pudo procesar los datos");
    } catch (e) {
      return left(CommonError(message: "Error sendOTP: $e"));
    }
  }

  @override
  Future<Either<CommonError, bool>> validateOTP({required String userId, required String code}) async {
    try {
      final result = await dataSource.validateOTP(userId: userId, code: code);
      if (result.success) {
        return right(result.body);
      } else if (!result.success && result.body is Map<String, dynamic>) {
        final error = ErrorResponseModel.fromJson(result.body);
        return left(CommonError(message: "${error.message}(${error.errorCode})"));
      }
      throw (result.message ?? "No se pudo procesar los datos");
    } catch (e) {
      return left(CommonError(message: "Error validateOTP: $e"));
    }
  }

  @override
  Future<Either<CommonError, UserModel>> updateUser({required UserModel data}) async {
    try {
      final result = await dataSource.updateUser(data: data);
      if (result.success) {
        return right(UserModel.fromJson(result.body));
      } else if (!result.success && result.body is Map<String, dynamic>) {
        final error = ErrorResponseModel.fromJson(result.body);
        return left(CommonError(message: "${error.message}(${error.errorCode})"));
      }
      throw (result.message ?? "No se pudo procesar los datos");
    } catch (e) {
      return left(CommonError(message: "Error updateUser: $e"));
    }
  }
}
