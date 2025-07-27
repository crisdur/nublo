import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../core/constants/loading_status.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/get_weather_by_location.dart';
import '../../../domain/usecases/save_weather.dart';
import '../../../domain/usecases/get_saved_weathers.dart';
import '../../../domain/usecases/delete_saved_weather.dart';
import '../../../domain/entities/weather/weather.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final GetWeatherByLocation getWeatherByLocation;
  final SaveWeather saveWeather;
  final GetSavedWeathers getSavedWeathersUseCase;
  final DeleteSavedWeather deleteSavedWeatherUseCase;

  WeatherCubit({
    required this.getWeatherByLocation,
    required this.saveWeather,
    required this.getSavedWeathersUseCase,
    required this.deleteSavedWeatherUseCase,
  }) : super(const WeatherState());

  Future<void> getWeather(LatLng location) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    final result = await getWeatherByLocation(
      GetWeatherByLocationParams(location),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(status: LoadingStatus.error, failure: failure));
      },
      (weather) {
        emit(
          state.copyWith(
            status: LoadingStatus.loaded,
            currentWeather: weather,
            failure: null,
          ),
        );
      },
    );
  }

  Future<void> saveCurrentWeather() async {
    if (state.currentWeather == null) {
      return;
    }
    emit(state.copyWith(status: LoadingStatus.loading));
    final result = await saveWeather(SaveWeatherParams(state.currentWeather!));

    result.fold(
      (failure) {
        emit(state.copyWith(status: LoadingStatus.error, failure: failure));
      },
      (_) async {
        final savedWeathers = await getSavedWeathers();
        emit(
          state.copyWith(
            status: LoadingStatus.loaded,
            failure: null,
            savedWeathers: savedWeathers,
          ),
        );
      },
    );
  }

  Future<void> loadSavedWeathers() async {
    final result = await getSavedWeathersUseCase(NoParams());
    result.fold(
      (failure) {
        emit(state.copyWith(status: LoadingStatus.error, failure: failure));
      },
      (weathers) {
        emit(
          state.copyWith(
            savedWeathers: weathers,
            status: LoadingStatus.loaded,
            failure: null,
          ),
        );
      },
    );
  }

  Future<List<Weather>> getSavedWeathers() async {
    final result = await getSavedWeathersUseCase(NoParams());
    return result.fold((failure) => [], (weathers) => weathers);
  }

  Future<void> deleteSavedWeather(int weatherId) async {
    final result = await deleteSavedWeatherUseCase(
      DeleteSavedWeatherParams(weatherId),
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(status: LoadingStatus.error, failure: failure)),
      (_) async {
        final savedWeathers = await getSavedWeathers();
        emit(
          state.copyWith(
            status: LoadingStatus.loaded,
            failure: null,
            savedWeathers: savedWeathers,
          ),
        );
      },
    );
  }
}
