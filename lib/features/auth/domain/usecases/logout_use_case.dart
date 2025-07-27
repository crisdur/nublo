import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase extends NetworkUseCase<void, NoParams> {
  LogoutUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, void>> execute(NoParams params) async {
    return await repository.logout();
  }
} 