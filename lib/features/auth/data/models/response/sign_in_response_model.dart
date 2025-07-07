import 'user_model.dart';

class SignInResponseModel {
  //success
  UserModel? user;

  //error
  String? message;
  String? errorCode;

  SignInResponseModel({
    this.message,
    this.errorCode,
    this.user,
  });

  factory SignInResponseModel.fromJson(Map<String, dynamic>? json) => SignInResponseModel(
        user: UserModel.fromJson(json?["user"]),
        message: json?["message"],
        errorCode: json?["errorCode"],
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
      };
}
