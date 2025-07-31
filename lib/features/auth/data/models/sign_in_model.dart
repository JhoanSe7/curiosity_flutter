class SignInModel {
  final String? username;
  final String? password;

  SignInModel({this.username, this.password});

  factory SignInModel.fromJson(Map<String, dynamic> json) => SignInModel(
        username: json["username"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
      };
}
