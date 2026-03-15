class UserModel {
  String? id;
  String? firstName;
  String? secondName;
  String? lastName;
  String? secondLastName;
  String? email;
  String? phoneNumber;
  String? password;
  List<String>? createdQuizzes;

  String? quizStatus;

  UserModel({
    this.id,
    this.firstName,
    this.secondName,
    this.lastName,
    this.secondLastName,
    this.email,
    this.phoneNumber,
    this.password,
    this.createdQuizzes,
    this.quizStatus,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    List questions = json["createdQuizzes"] != null && json["createdQuizzes"] is List ? json["createdQuizzes"] : [];
    return UserModel(
      id: json["id"],
      firstName: json["firstName"],
      secondName: json["secondName"],
      lastName: json["lastName"],
      secondLastName: json["secondLastName"],
      email: json["email"],
      phoneNumber: json["phoneNumber"],
      password: json["password"],
      createdQuizzes: List<String>.from(questions.map((x) => x)),
      quizStatus: json["quizStatus"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "secondName": secondName,
        "lastName": lastName,
        "secondLastName": secondLastName,
        "email": email,
        "phoneNumber": phoneNumber,
        "password": password,
        "createdQuizzes": createdQuizzes,
        "quizStatus": quizStatus,
      };

  Map<UserParam, String> information() => {
        UserParam.name: fullName(),
        UserParam.email: email ?? "",
        UserParam.phone: phoneNumber ?? "",
      };

  List<String> toList() => [
        id ?? "",
        firstName ?? "",
        secondName ?? "",
        lastName ?? "",
        secondLastName ?? "",
        email ?? "",
        phoneNumber ?? "",
        password ?? "",
        createdQuizzes?.join(",") ?? ""
      ];

  factory UserModel.fromList(List<String> data) {
    if (data.isEmpty || data.length < 10) return UserModel();
    return UserModel(
      id: data[0],
      firstName: data[1],
      secondName: data[2],
      lastName: data[3],
      secondLastName: data[4],
      email: data[5],
      phoneNumber: data[6],
      password: data[8],
      createdQuizzes: data[9].split(","),
    );
  }

  String fullName() {
    var data = [firstName, secondName, lastName, secondLastName].where((e) => e != null && e.isNotEmpty).toList();
    return data.join(" ");
  }

  Map<String, dynamic> toMap() => {
        'userId': id,
        'firstName': firstName,
        'secondName': secondName,
        'lastName': lastName,
        'secondLastName': secondLastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'quizStatus': quizStatus,
      };
}

enum UserParam {
  name,
  email,
  phone,
}
