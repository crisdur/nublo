import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'weather.freezed.dart';

@freezed
abstract class Weather with _$Weather {
  const factory Weather({
    required String id,
    required String main,
    required String description,
    required String icon,
    required double temperature,
    required double feelsLike,
    required int humidity,
    required double windSpeed,
    required int visibility,
    required LatLng location,
    required String cityName,
    required String country,
    DateTime? savedAt,
  }) = _Weather;
}