class SignUpModel {
  final String? firstName;
  final String? secondName;
  final String? lastName;
  final String? secondLastName;
  final String? email;
  final String? phoneNumber;
  final String? role;
  final String? username;
  final String? password;

  SignUpModel({
    this.firstName,
    this.secondName,
    this.lastName,
    this.secondLastName,
    this.email,
    this.phoneNumber,
    this.role,
    this.username,
    this.password,
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) => SignUpModel(
        firstName: json["firstName"],
        secondName: json["secondName"],
        lastName: json["lastName"],
        secondLastName: json["secondLastName"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        role: json["role"],
        username: json["username"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "secondName": secondName,
        "lastName": lastName,
        "secondLastName": secondLastName,
        "email": email,
        "phoneNumber": phoneNumber,
        "role": role,
        "username": username,
        "password": password,
      };
}
