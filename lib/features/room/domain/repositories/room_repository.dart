import 'package:curiosity_flutter/core/network/models/common_error.dart';
import 'package:dartz/dartz.dart';

abstract class RoomRepository {
  Future<Either<CommonError, bool>> validateRoom({required String roomCode});
}
