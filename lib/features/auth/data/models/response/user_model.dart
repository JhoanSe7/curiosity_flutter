class UserModel {
  String? id;
  String? firstName;
  String? secondName;
  String? lastName;
  String? secondLastName;
  String? email;
  String? phoneNumber;
  String? role;
  String? password;

  UserModel({
    this.id,
    this.firstName,
    this.secondName,
    this.lastName,
    this.secondLastName,
    this.email,
    this.phoneNumber,
    this.role,
    this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        firstName: json["firstName"],
        secondName: json["secondName"],
        lastName: json["lastName"],
        secondLastName: json["secondLastName"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        role: json["role"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "secondName": secondName,
        "lastName": lastName,
        "secondLastName": secondLastName,
        "email": email,
        "phoneNumber": phoneNumber,
        "role": role,
        "password": password,
      };
}
