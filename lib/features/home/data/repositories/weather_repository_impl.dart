import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info/network_info.dart';
import '../../domain/entities/weather/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/remote/weather_remote_datasource.dart';
import '../datasources/local/weather_local_datasource.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Weather>> getWeatherByLocation(LatLng location) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final weatherData = await remoteDataSource.getWeatherByLocation(location);
      final weather = Weather(
        id: weatherData['weather'][0]['id'].toString(),
        main: weatherData['weather'][0]['main'],
        description: weatherData['weather'][0]['description'],
        icon: weatherData['weather'][0]['icon'],
        temperature: weatherData['main']['temp'].toDouble(),
        feelsLike: weatherData['main']['feels_like'].toDouble(),
        humidity: weatherData['main']['humidity'].toInt(),
        windSpeed: weatherData['wind']['speed'].toDouble(),
        visibility: weatherData['visibility'].toInt(),
        location: location,
        cityName: weatherData['name'] ?? 'Unknown location',
        country: weatherData['sys']['country'],
      );
      return Right(weather);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveWeather(Weather weather) async {
    try {
      try {
      await localDataSource.saveWeather(weather);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Weather>>> getSavedWeathers() async {
    try {
      final weathers = await localDataSource.getSavedWeathers();
      return Right(weathers);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteSavedWeather(int weatherId) async {
    try {
      await localDataSource.deleteWeather(weatherId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}