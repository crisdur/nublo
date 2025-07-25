import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../di/injection.dart';
import '../error/failure.dart';
import '../network/network_info/network_info.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Network-aware UseCase that automatically validates connectivity
abstract class NetworkUseCase<Type, Params> extends UseCase<Type, Params> {
  NetworkUseCase() : _networkInfo = getIt<NetworkInfo>();

  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, Type>> call(Params params) async {
    if (!await _networkInfo.isConnected) {
      return Left<Failure, Type>(const NetworkFailure());
    }
    return await execute(params);
  }

  Future<Either<Failure, Type>> execute(Params params);
}

/// Local-only UseCase that doesn't require network validation
abstract class LocalUseCase<Type, Params> extends UseCase<Type, Params> {
  @override
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => <Object>[];
} 