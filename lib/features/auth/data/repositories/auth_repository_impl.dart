import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:dartz/dartz.dart';
import 'package:nublo/core/constants/auth0_constants.dart';
import 'package:nublo/features/auth/domain/entities/user/user.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info/network_info.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.auth0,
    required this.networkInfo,
  });

  final Auth0 auth0;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, User>> loginWithAuth0() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final credentials = await auth0.webAuthentication(scheme: Auth0Constants.scheme).login();
      final userProfile = credentials.user;
      
      final user = User(
        sub: userProfile.sub,
        name: userProfile.name ?? 'Unknown User',
        nickname: userProfile.nickname,
        email: userProfile.email,
        picture: userProfile.pictureUrl?.toString(),
        emailVerified: userProfile.isEmailVerified ?? false,
        familyName: userProfile.familyName,
        givenName: userProfile.givenName,
        updatedAt: userProfile.updatedAt,
      );

      return Right(user);
    } on WebAuthenticationException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(AuthFailure(message: 'Authentication failed: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> signupWithAuth0({
    Map<String, String>? parameters,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final credentials = await auth0.webAuthentication(scheme: Auth0Constants.scheme).login(
        parameters: {
          'screen_hint': 'signup',
          ...?parameters,
        },
      );
      final userProfile = credentials.user;
      
      final user = User(
        sub: userProfile.sub,
        name: userProfile.name ?? 'Unknown User',
        nickname: userProfile.nickname,
        email: userProfile.email,
        picture: userProfile.pictureUrl?.toString(),
        emailVerified: userProfile.isEmailVerified ?? false,
        familyName: userProfile.familyName,
        givenName: userProfile.givenName,
        updatedAt: userProfile.updatedAt,
      );

      return Right(user);
    } on WebAuthenticationException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(AuthFailure(message: 'Signup failed: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await auth0.webAuthentication(scheme: Auth0Constants.scheme).logout();
      return const Right(null);
    } on WebAuthenticationException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(AuthFailure(message: 'Logout failed: $e'));
    }
  }

  @override
  Future<User?> checkAuthStatus() async {
    try {
      final hasValidCredentials = await auth0.credentialsManager.hasValidCredentials();
      if (!hasValidCredentials) {
        return null;
      }

      final credentials = await auth0.credentialsManager.credentials();
      final userProfile = credentials.user;
      
      return User(
        sub: userProfile.sub,
        name: userProfile.name ?? 'Unknown User',
        nickname: userProfile.nickname,
        email: userProfile.email,
        picture: userProfile.pictureUrl?.toString(),
        emailVerified: userProfile.isEmailVerified ?? false,
        familyName: userProfile.familyName,
        givenName: userProfile.givenName,
        updatedAt: userProfile.updatedAt,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Either<Failure, bool>> isUserLoggedIn() async {
    try {
      final hasValidCredentials = await auth0.credentialsManager.hasValidCredentials();
      return Right(hasValidCredentials);
    } catch (e) {
      return const Right(false);
    }
  }
} 