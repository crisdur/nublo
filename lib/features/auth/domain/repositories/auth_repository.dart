import 'package:dartz/dartz.dart';
import 'package:nublo/features/auth/domain/entities/user/user.dart';
import '../../../../core/error/failure.dart';
 
abstract class AuthRepository {
  // Auth0 authentication methods
  Future<Either<Failure, User>> loginWithAuth0();
  
  Future<Either<Failure, User>> signupWithAuth0({
    Map<String, String>? parameters,
  });
  
  Future<Either<Failure, void>> logout();
  
  Future<User?> checkAuthStatus();
  
  Future<Either<Failure, bool>> isUserLoggedIn();
} 