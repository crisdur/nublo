import 'package:dartz/dartz.dart';
import 'package:nublo/features/auth/domain/entities/user/user.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class SignupWithAuth0UseCase extends NetworkUseCase<User, SignupWithAuth0Params> {
  SignupWithAuth0UseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, User>> execute(SignupWithAuth0Params params) async {
    return await repository.signupWithAuth0(parameters: params.parameters);
  }
}

class SignupWithAuth0Params {
  SignupWithAuth0Params({this.parameters});

  final Map<String, String>? parameters;
} 