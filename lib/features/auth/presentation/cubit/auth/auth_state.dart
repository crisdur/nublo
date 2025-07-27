import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nublo/core/error/failure.dart';
import 'package:nublo/features/auth/domain/entities/user/user.dart';
import '../../../../../core/constants/auth_status.dart';


part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    User? user,
    @Default(AuthStatus.initial) AuthStatus status,
    @Default(null) Failure? error,
  }) = _AuthState;
}
