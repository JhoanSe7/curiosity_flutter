import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'room_state.dart';

class RoomController extends StateNotifier<RoomState> {
  RoomController() : super(RoomState());

  /// Setter para el código del room
  void setRoomCode(String roomCode) {
    if (mounted) state = state.copyWith(roomCode: roomCode);
  }
}

final roomController = StateNotifierProvider<RoomController, RoomState>((ref) => RoomController());
