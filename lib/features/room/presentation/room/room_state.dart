class RoomState {
  final String roomCode;

  RoomState({
    this.roomCode = "",
  });

  RoomState copyWith({
    String? roomCode,
  }) =>
      RoomState(
        roomCode: roomCode ?? this.roomCode,
      );
}
