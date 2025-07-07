class UserModel {
  String? id;
  String? username;

  UserModel({
    this.id,
    this.username,
  });

  factory UserModel.fromJson(Map<String, dynamic>? json) => UserModel(
        id: json?["_id"],
        username: json?["username"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
      };
}
