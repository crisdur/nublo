import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nublo/core/constants/auth_status.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  Future<void> checkAuthStatus() async {
    emit(state.copyWith(status: AuthStatus.initial));

    await Future.delayed(const Duration(seconds: 2));




    emit(state.copyWith(status: AuthStatus.unauthenticated));
  }
}
