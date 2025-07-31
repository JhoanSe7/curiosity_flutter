import 'user_model.dart';

class AuthResponseModel {
  //success
  UserModel? user;

  //error
  String? message;
  String? errorCode;

  AuthResponseModel({
    this.message,
    this.errorCode,
    this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) => AuthResponseModel(
        user: UserModel.fromJson(json["user"] ?? {}),
        message: json["message"],
        errorCode: json["errorCode"],
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
      };
}
