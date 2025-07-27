import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'home.freezed.dart';

@freezed
abstract class Home with _$Home {
  const factory Home({
    @Default('') String id,
    required String displayName,
    String? description,
    String? address,
    String? localizedCategory,
    String? phoneNumber,
    String? website,
    required LatLng location,
  }) = _Home;
} 