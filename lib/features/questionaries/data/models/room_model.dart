class RoomModel {
  String? quizId;
  String? hostId;

  String? roomCode;
  String? quizTitle;

  RoomModel({
    this.quizId,
    this.hostId,
    this.roomCode,
    this.quizTitle,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
        quizId: json["quizId"],
        hostId: json["hostId"],
        roomCode: json["roomCode"],
        quizTitle: json["quizTitle"],
      );

  Map<String, dynamic> toJson() => {
        "quizId": quizId,
        "hostId": hostId,
        "roomCode": roomCode,
        "quizTitle": quizTitle,
      };
}
