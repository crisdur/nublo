import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/error/failure.dart';
import '../entities/weather/weather.dart';

abstract class WeatherRepository {
  Future<Either<Failure, Weather>> getWeatherByLocation(LatLng location);
  Future<Either<Failure, void>> saveWeather(Weather weather);
  Future<Either<Failure, List<Weather>>> getSavedWeathers();
  Future<Either<Failure, void>> deleteSavedWeather(int weatherId);
} 