import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/weather/weather.dart';
import '../repositories/weather_repository.dart';

class GetWeatherByLocationParams {
  final LatLng location;

  GetWeatherByLocationParams(this.location);
}

class GetWeatherByLocation extends UseCase<Weather, GetWeatherByLocationParams> {
  final WeatherRepository repository;

  GetWeatherByLocation(this.repository);

  @override
  Future<Either<Failure, Weather>> call(GetWeatherByLocationParams params) async {
    return await repository.getWeatherByLocation(params.location);
  }
} 