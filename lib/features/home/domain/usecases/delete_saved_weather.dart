import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/weather_repository.dart';

class DeleteSavedWeatherParams {
  final int weatherId;
  DeleteSavedWeatherParams(this.weatherId);
}

class DeleteSavedWeather implements UseCase<void, DeleteSavedWeatherParams> {
  final WeatherRepository repository;

  DeleteSavedWeather(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteSavedWeatherParams params) async {
    return await repository.deleteSavedWeather(params.weatherId);
  }
} 