import 'package:dartz/dartz.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info/network_info.dart';
import '../../domain/entities/home/home.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/remote/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final HomeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, List<Home>>> getAllHomes() async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.getAllHomes();
        return Right(items);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
}