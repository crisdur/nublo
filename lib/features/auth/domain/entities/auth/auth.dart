import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth.freezed.dart';

@freezed
abstract class Auth with _$Auth {
  const factory Auth({
    @Default('') String id,
    required String displayName,
    String? description,
    String? address,
    String? localizedCategory,
    String? phoneNumber,
    String? website,
    double? latitude,
    double? longitude,
  }) = _Auth;
} 