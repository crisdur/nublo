import 'package:injectable/injectable.dart';
import '../../../../core/network/network_info/network_info.dart';
import '../data/datasources/remote/home_remote_datasource.dart';
import '../data/repositories/home_repository_impl.dart';
import '../domain/repositories/home_repository.dart';
import '../domain/usecases/get_all_homes.dart';
import '../presentation/cubit/home/home_cubit.dart';

@module
abstract class HomeModule {
  @lazySingleton
  HomeRemoteDataSource provideHomeRemoteDataSource() =>
      HomeRemoteDataSourceImpl();

  @lazySingleton
  HomeRepository provideHomeRepository(
    HomeRemoteDataSource remoteDataSource,
    NetworkInfo networkInfo,
  ) =>
      HomeRepositoryImpl(
        remoteDataSource: remoteDataSource,
        networkInfo: networkInfo,
      );

  @lazySingleton
  GetAllHomes provideGetAllHomes(
    HomeRepository repository,
  ) =>
      GetAllHomes(repository);

  @injectable
  HomeCubit provideHomeCubit(
    GetAllHomes getAllHomes,
  ) =>
      HomeCubit(
        getAllHomes: getAllHomes,
      );
} 