import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nublo/core/error/failure.dart';
import '../../../../../core/constants/auth_status.dart';
import '../../../domain/entities/auth/auth.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthStatus.initial) AuthStatus status,
    @Default(<Auth>[]) List<Auth> items,
    @Default(null) Failure? failure,
  }) = _AuthState;
}
