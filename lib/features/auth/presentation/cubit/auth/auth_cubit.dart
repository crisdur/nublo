import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nublo/core/constants/auth_status.dart';
import 'package:nublo/features/auth/domain/usecases/login_with_auth0.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/signup_with_auth0.dart';
import '../../../domain/usecases/logout_use_case.dart';
import '../../../domain/usecases/check_auth_status_use_case.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.logoutUseCase,
    required this.checkAuthStatusUseCase,
  }) : super(const AuthState());

  final LoginWithAuth0UseCase loginUseCase;
  final SignupWithAuth0UseCase signupUseCase;
  final LogoutUseCase logoutUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;

  Future<void> checkAuthStatus() async {
    emit(state.copyWith(status: AuthStatus.initial));

    try {
      final result = await checkAuthStatusUseCase(NoParams());

      // add delay
      await Future.delayed(const Duration(seconds: 2));

      result.fold(
        (failure) => emit(state.copyWith(status: AuthStatus.loading)),
        (user) =>
            emit(state.copyWith(status: AuthStatus.authenticated, user: user)),
      );
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> login() async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));

    try {
      final result = await loginUseCase.execute(NoParams());
      result.fold(
        (failure) =>
            emit(state.copyWith(status: AuthStatus.error, error: failure)),
        (user) => emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
            error: null,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          error: AuthFailure(message: 'Error logging in'),
        ),
      );
    }
  }

  Future<void> signup({Map<String, String>? parameters}) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));

    try {
      final result = await signupUseCase.execute(
        SignupWithAuth0Params(parameters: parameters),
      );
      result.fold(
        (failure) =>
            emit(state.copyWith(status: AuthStatus.error, error: failure)),
        (user) => emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
            error: null,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          error: AuthFailure(message: 'An unexpected error occurred'),
        ),
      );
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));

    try {
      final result = await logoutUseCase.execute(NoParams());
      result.fold(
        (failure) {
          emit(state.copyWith(status: AuthStatus.error, error: failure));
        },
        (_) {
          emit(
            state.copyWith(
              status: AuthStatus.unauthenticated,
              user: null,
              error: null,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          error: AuthFailure(message: 'An unexpected error occurred'),
        ),
      );
    }
  }
}
