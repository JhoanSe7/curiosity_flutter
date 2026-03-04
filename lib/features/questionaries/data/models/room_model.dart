class RoomModel {
  String? quizId;
  String? hostId;
  String? hostFirstName;
  String? hostLastName;

  String? hostName;
  String? roomCode;
  String? quizTitle;

  RoomModel({
    this.quizId,
    this.hostId,
    this.hostFirstName,
    this.hostLastName,
    this.hostName,
    this.roomCode,
    this.quizTitle,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
        quizId: json["quizId"],
        hostId: json["hostId"],
        hostFirstName: json["hostFirstName"],
        hostLastName: json["hostLastName"],
        hostName: json["hostName"],
        roomCode: json["roomCode"],
        quizTitle: json["quizTitle"],
      );

  Map<String, dynamic> toJson() => {
        "quizId": quizId,
        "hostId": hostId,
        "hostFirstName": hostFirstName,
        "hostLastName": hostLastName,
        "hostName": hostName,
        "roomCode": roomCode,
        "quizTitle": quizTitle,
      };
}
