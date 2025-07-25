import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/auth/auth.dart';
import '../repositories/auth_repository.dart';

class GetAllAuths extends NetworkUseCase<List<Auth>, NoParams> {
  GetAllAuths(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, List<Auth>>> execute(NoParams params) async {
    return await repository.getAllAuths();
  }
}