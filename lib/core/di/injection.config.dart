// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/data_sources/auth_data_source.dart' as _i933;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/use_cases/auth_use_case.dart' as _i283;
import '../../features/questionaries/data/data_sources/questionaries_data_source.dart'
    as _i812;
import '../../features/questionaries/data/repositories/questionaries_repository_impl.dart'
    as _i932;
import '../../features/questionaries/domain/repositories/questionaries_repository.dart'
    as _i664;
import '../../features/questionaries/domain/use_cases/questionaries_use_case.dart'
    as _i912;
import '../network/client_http.dart' as _i107;
import '../services/web_socket_service.dart' as _i524;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i107.ClientHttp>(() => _i107.ClientHttp());
    gh.singleton<_i524.WebSocketService>(() => _i524.WebSocketService());
    gh.factory<_i933.AuthDataSource>(
        () => _i933.AuthDataSourceImpl(gh<_i107.ClientHttp>()));
    gh.factory<_i812.QuestionariesDataSource>(
        () => _i812.QuestionariesDataSourceImpl(gh<_i107.ClientHttp>()));
    gh.factory<_i664.QuestionariesRepository>(() =>
        _i932.QuestionariesRepositoryImpl(gh<_i812.QuestionariesDataSource>()));
    gh.factory<_i912.QuestionariesUseCase>(
        () => _i912.QuestionariesUseCase(gh<_i664.QuestionariesRepository>()));
    gh.factory<_i787.AuthRepository>(
        () => _i153.AuthRepositoryImpl(gh<_i933.AuthDataSource>()));
    gh.factory<_i283.AuthUseCase>(
        () => _i283.AuthUseCase(gh<_i787.AuthRepository>()));
    return this;
  }
}
