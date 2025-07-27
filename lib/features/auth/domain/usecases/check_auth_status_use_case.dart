import 'package:dartz/dartz.dart';
import 'package:nublo/features/auth/domain/entities/user/user.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class CheckAuthStatusUseCase extends UseCase<User?, NoParams> {
  CheckAuthStatusUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, User?>> call(NoParams params) async {
    try {
      final result = await repository.checkAuthStatus();
      return Right(result);
    } catch (e) {
      return Left(AuthFailure(message: 'Failed to check auth status'));
    }
  }
} 