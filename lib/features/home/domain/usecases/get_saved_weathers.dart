import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/weather/weather.dart';
import '../repositories/weather_repository.dart';


class GetSavedWeathers implements UseCase<List<Weather>, NoParams> {
  final WeatherRepository repository;

  GetSavedWeathers(this.repository);

  @override
  Future<Either<Failure, List<Weather>>> call(NoParams params) async {
    return await repository.getSavedWeathers();
  }
} 