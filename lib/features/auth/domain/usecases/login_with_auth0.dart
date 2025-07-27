import 'package:dartz/dartz.dart';
import 'package:nublo/features/auth/domain/repositories/auth_repository.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user/user.dart';

class LoginWithAuth0UseCase extends NetworkUseCase<User, NoParams> {
  LoginWithAuth0UseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, User>> execute(NoParams params) async {
    return await repository.loginWithAuth0();
  }
} 