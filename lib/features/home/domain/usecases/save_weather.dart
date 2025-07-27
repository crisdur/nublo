import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/weather/weather.dart';
import '../repositories/weather_repository.dart';

class SaveWeatherParams {
  final Weather weather;

  SaveWeatherParams(this.weather);
}

class SaveWeather extends UseCase<void, SaveWeatherParams> {
  final WeatherRepository repository;

  SaveWeather(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveWeatherParams params) async {
    final result = await repository.saveWeather(params.weather);
    result.fold(
      (failure) => null,
      (_) => null,
    );
    return result;
  }
}