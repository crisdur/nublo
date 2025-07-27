import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nublo/core/error/failure.dart';
import '../../../../../core/constants/loading_status.dart';
import '../../../domain/entities/weather/weather.dart';

part 'weather_state.freezed.dart';

@freezed
abstract class WeatherState with _$WeatherState {
  const factory WeatherState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default(null) Failure? failure,
    Weather? currentWeather,
    @Default([]) List<Weather> savedWeathers,
  }) = _WeatherState;
} 