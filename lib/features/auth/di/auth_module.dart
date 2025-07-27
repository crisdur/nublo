import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:nublo/features/auth/domain/usecases/login_with_auth0.dart';
import '../../../../core/network/network_info/network_info.dart';
import '../../../core/constants/auth0_constants.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/signup_with_auth0.dart';
import '../domain/usecases/logout_use_case.dart';
import '../domain/usecases/check_auth_status_use_case.dart';
import '../presentation/cubit/auth/auth_cubit.dart';

@module
abstract class AuthModule {
  @lazySingleton
  Auth0 provideAuth0() => Auth0(Auth0Constants.domain, Auth0Constants.clientId);

  @lazySingleton
  AuthRepository provideAuthRepository(
    Auth0 auth0,
    NetworkInfo networkInfo,
  ) => AuthRepositoryImpl(
    auth0: auth0,
    networkInfo: networkInfo,
  );



  @lazySingleton
  SignupWithAuth0UseCase provideSignupWithAuth0UseCase(AuthRepository repository) =>
      SignupWithAuth0UseCase(repository);

  @lazySingleton
  LogoutUseCase provideLogoutUseCase(AuthRepository repository) =>
      LogoutUseCase(repository);

  @lazySingleton
  CheckAuthStatusUseCase provideCheckAuthStatusUseCase(AuthRepository repository) =>
      CheckAuthStatusUseCase(repository);

  @injectable
  AuthCubit provideAuthCubit(
    LoginWithAuth0UseCase loginUseCase,
    SignupWithAuth0UseCase signupUseCase,
    LogoutUseCase logoutUseCase,
    CheckAuthStatusUseCase checkAuthStatusUseCase,
  ) => AuthCubit(
    loginUseCase: loginUseCase,
    signupUseCase: signupUseCase,
    logoutUseCase: logoutUseCase,
    checkAuthStatusUseCase: checkAuthStatusUseCase,
  );
}
