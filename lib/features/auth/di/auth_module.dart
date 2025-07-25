import 'package:injectable/injectable.dart';
import '../../../../core/network/network_info/network_info.dart';
import '../data/datasources/remote/auth_remote_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/get_all_auths.dart';
import '../presentation/cubit/auth/auth_cubit.dart';

@module
abstract class AuthModule {
  @lazySingleton
  AuthRemoteDataSource provideAuthRemoteDataSource() =>
      AuthRemoteDataSourceImpl();

  @lazySingleton
  AuthRepository provideAuthRepository(
    AuthRemoteDataSource remoteDataSource,
    NetworkInfo networkInfo,
  ) => AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );

  @lazySingleton
  GetAllAuths provideGetAllAuths(AuthRepository repository) =>
      GetAllAuths(repository);

  @injectable
  AuthCubit provideAuthCubit(GetAllAuths getAllAuths) => AuthCubit();
}
