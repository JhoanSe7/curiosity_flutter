class UserModel {
  String? id;
  String? firstName;
  String? secondName;
  String? lastName;
  String? secondLastName;
  String? email;
  String? phoneNumber;
  String? password;
  String? tokenPush;

  List<String>? createdQuizzes;
  List<String>? quizResultIds;
  List<String>? quizSessionIds;

  String? quizStatus;
  double? score;

  UserModel({
    this.id,
    this.firstName,
    this.secondName,
    this.lastName,
    this.secondLastName,
    this.email,
    this.phoneNumber,
    this.password,
    this.tokenPush,
    this.createdQuizzes,
    this.quizResultIds,
    this.quizSessionIds,
    this.quizStatus,
    this.score,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    List questions = json["createdQuizzes"] != null && json["createdQuizzes"] is List ? json["createdQuizzes"] : [];
    List results = json["quizResultIds"] != null && json["quizResultIds"] is List ? json["quizResultIds"] : [];
    List sessions = json["quizSessionIds"] != null && json["quizSessionIds"] is List ? json["quizSessionIds"] : [];
    return UserModel(
      id: json["id"],
      firstName: json["firstName"],
      secondName: json["secondName"],
      lastName: json["lastName"],
      secondLastName: json["secondLastName"],
      email: json["email"],
      phoneNumber: json["phoneNumber"],
      password: json["password"],
      tokenPush: json["tokenPush"],
      createdQuizzes: List<String>.from(questions.map((x) => x)),
      quizResultIds: List<String>.from(results.map((x) => x)),
      quizSessionIds: List<String>.from(sessions.map((x) => x)),
      quizStatus: json["quizStatus"],
      score: json["score"],
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
        "tokenPush": tokenPush,
        "createdQuizzes": createdQuizzes,
        "quizResultIds": quizResultIds,
        "quizSessionIds": quizSessionIds,
        "quizStatus": quizStatus,
        "score": score,
      };

  Map<UserParam, String> information() => {
        UserParam.name: fullName(),
        UserParam.email: email ?? "",
        UserParam.phone: phoneNumber ?? "",
      };

  String fullName() {
    var data = [firstName, secondName, lastName, secondLastName].where((e) => e != null && e.isNotEmpty).toList();
    return data.join(" ");
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'firstName': firstName,
        'secondName': secondName,
        'lastName': lastName,
        'secondLastName': secondLastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'quizStatus': quizStatus,
        'tokenPush': tokenPush,
      };

  Map<String, dynamic> toUpdate() => {
        'id': id,
        'firstName': firstName,
        'secondName': secondName,
        'lastName': lastName,
        'secondLastName': secondLastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
      };
}

enum UserParam {
  name,
  email,
  phone,
}
