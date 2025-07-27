import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String sub,
    required String name,
    String? nickname,
    String? email,
    String? picture,
    @Default(false) bool emailVerified,
    String? familyName,
    String? givenName,
    DateTime? updatedAt,
  }) = _User;
} 