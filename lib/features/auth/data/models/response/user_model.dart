class UserModel {
  String? id;
  String? username;
  String? password;

  String? firstName;
  String? secondName;
  String? firstLastName;
  String? secondLastName;
  String? email;
  String? phoneNumber;
  String? rol;

  UserModel({
    this.id,
    this.username,
    this.password,
    this.firstName,
    this.secondName,
    this.firstLastName,
    this.secondLastName,
    this.email,
    this.phoneNumber,
    this.rol,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["_id"],
        username: json["username"],
        password: json["password"],
        firstName: json["firstName"],
        secondName: json["secondName"],
        firstLastName: json["firstLastName"],
        secondLastName: json["secondLastName"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        rol: json["rol"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "password": password,
        "firstName": firstName,
        "secondName": secondName,
        "firstLastName": firstLastName,
        "secondLastName": secondLastName,
        "email": email,
        "phoneNumber": phoneNumber,
        "rol": rol,
      };
}
