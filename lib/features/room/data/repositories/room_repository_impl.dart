import 'package:curiosity_flutter/core/network/models/common_error.dart';
import 'package:curiosity_flutter/core/network/models/response/error_response_model.dart';
import 'package:curiosity_flutter/features/room/data/data_sources/room_data_source.dart';
import 'package:curiosity_flutter/features/room/domain/repositories/room_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: RoomRepository)
class RoomRepositoryImpl extends RoomRepository {
  RoomDataSource dataSource;

  RoomRepositoryImpl(this.dataSource);

  @override
  Future<Either<CommonError, bool>> validateRoom({required String roomCode}) async {
    try {
      final result = await dataSource.validateRoom(roomCode: roomCode);
      if (result.success) {
        return right(true);
      } else if (!result.success && result.body is Map<String, dynamic>) {
        final error = ErrorResponseModel.fromJson(result.body);
        return left(CommonError(message: "${error.message}(${error.errorCode})"));
      }
      throw (result.message ?? "No se pudo procesar los datos");
    } catch (e) {
      return left(CommonError(message: "Error deleteQuiz: $e"));
    }
  }
}
