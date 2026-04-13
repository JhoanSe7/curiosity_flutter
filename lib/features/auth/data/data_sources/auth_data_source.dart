import 'package:curiosity_flutter/core/constants/config.dart';
import 'package:curiosity_flutter/core/network/client_http.dart';
import 'package:curiosity_flutter/core/network/models/http_response.dart';
import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:curiosity_flutter/features/auth/data/models/sign_in_model.dart';
import 'package:injectable/injectable.dart';

abstract class AuthDataSource {
  Future<HttpResponseModel> signIn({required SignInModel data});

  Future<HttpResponseModel> signUp({required UserModel data});

  Future<HttpResponseModel> updateToken({required String userId, required String tokenPush});

  Future<HttpResponseModel> sendOTP({required String email});

  Future<HttpResponseModel> validateOTP({required String userId, required String code});

  Future<HttpResponseModel> updateUser({required UserModel data});
}

@Injectable(as: AuthDataSource)
class AuthDataSourceImpl extends AuthDataSource {
  final ClientHttp clientHttp;

  AuthDataSourceImpl(this.clientHttp);

  @override
  Future<HttpResponseModel> signIn({required SignInModel data}) async {
    return await clientHttp.post(
      endpoint: "${Config.apiUrl}users/sign-in",
      body: data.toJson(),
    );
  }

  @override
  Future<HttpResponseModel> signUp({required UserModel data}) async {
    return await clientHttp.post(
      endpoint: "${Config.apiUrl}users",
      body: data.toJson(),
    );
  }

  @override
  Future<HttpResponseModel> updateToken({required String userId, required String tokenPush}) async {
    return await clientHttp.post(
      endpoint: "${Config.apiUrl}users/updateToken",
      body: {
        "userId": userId,
        "tokenPush": tokenPush,
      },
    );
  }

  @override
  Future<HttpResponseModel> sendOTP({required String email}) async {
    return await clientHttp.post(
      endpoint: "${Config.apiUrl}users/reset-password",
      body: {"email": email},
    );
  }

  @override
  Future<HttpResponseModel> validateOTP({required String userId, required String code}) async {
    return await clientHttp.post(
      endpoint: "${Config.apiUrl}users/validate-otp",
      body: {"userId": userId, "code": code},
    );
  }

  @override
  Future<HttpResponseModel> updateUser({required UserModel data}) async {
    return await clientHttp.post(
      endpoint: "${Config.apiUrl}users/update-user",
      body: data.toUpdate(),
    );
  }
}
