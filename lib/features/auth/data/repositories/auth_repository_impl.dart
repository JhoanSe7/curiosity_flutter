import 'package:curiosity_flutter/core/network/models/common_error.dart';
import 'package:curiosity_flutter/features/auth/data/data_sources/auth_data_source.dart';
import 'package:curiosity_flutter/features/auth/data/models/response/sign_in_response_model.dart';
import 'package:curiosity_flutter/features/auth/data/models/sign_in_model.dart';
import 'package:curiosity_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<Either<CommonError, SignInResponseModel>> signIn({required SignInModel data}) async {
    try {
      final result = await dataSource.signIn(data: data);
      if (result.status) {
        return right(SignInResponseModel.fromJson(result.body));
      } else if (!result.status) {
        final msg = SignInResponseModel.fromJson(result.body);
        throw (msg.message ?? "Error en la respuesta estado->${result.status}");
      }
      throw ("No se pudo procesar los datos");
    } catch (e) {
      return left(CommonError(message: "Error signIn: $e"));
    }
  }
}
