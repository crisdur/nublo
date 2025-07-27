import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/network/network_info/network_info.dart';
import '../../../../core/services/location/location_service.dart';
import '../data/datasources/remote/weather_remote_datasource.dart';
import '../data/datasources/local/weather_local_datasource.dart';
import '../data/repositories/weather_repository_impl.dart';
import '../domain/repositories/home_repository.dart';
import '../domain/repositories/weather_repository.dart';
import '../domain/usecases/get_all_homes.dart';
import '../domain/usecases/get_weather_by_location.dart';
import '../domain/usecases/save_weather.dart';
import '../domain/usecases/get_saved_weathers.dart';
import '../domain/usecases/delete_saved_weather.dart';
import '../presentation/cubit/home/home_cubit.dart';
import '../presentation/cubit/weather/weather_cubit.dart';
import '../../../../core/network/client/weather_client.dart';

@module
abstract class HomeModule {
  @preResolve
  @singleton
  Future<Database> provideDatabase() async {
    return openDatabase(
      'weather.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''CREATE TABLE weathers (
            id TEXT PRIMARY KEY,
            main TEXT,
            description TEXT,
            icon TEXT,
            temperature REAL,
            feels_like REAL,
            humidity INTEGER,
            wind_speed REAL,
            visibility INTEGER,
            latitude REAL,
            longitude REAL,
            city_name TEXT,
            country TEXT,
            saved_at TEXT
          )''');
      },
    );
  }

  @lazySingleton
  WeatherClient provideWeatherClient() =>
      WeatherClient(apiKey: 'b934a178c9d4683a2c27f46976d2a0fd');

  @lazySingleton
  LocationService provideLocationService() => LocationServiceImpl();

  @lazySingleton
  WeatherRemoteDataSource provideWeatherRemoteDataSource(
    WeatherClient client,
  ) => WeatherRemoteDataSourceImpl(client);

  @lazySingleton
  WeatherLocalDataSource provideWeatherLocalDataSource(Database database) =>
      WeatherLocalDataSourceImpl(database);

  @lazySingleton
  WeatherRepository provideWeatherRepository(
    WeatherRemoteDataSource remoteDataSource,
    WeatherLocalDataSource localDataSource,
    NetworkInfo networkInfo,
  ) => WeatherRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    networkInfo: networkInfo,
  );

  @lazySingleton
  GetAllHomes provideGetAllHomes(HomeRepository repository) =>
      GetAllHomes(repository);

  @lazySingleton
  GetWeatherByLocation provideGetWeatherByLocation(
    WeatherRepository repository,
  ) => GetWeatherByLocation(repository);

  @lazySingleton
  SaveWeather provideSaveWeather(WeatherRepository repository) =>
      SaveWeather(repository);

  @lazySingleton
  GetSavedWeathers provideGetSavedWeathers(WeatherRepository repository) =>
      GetSavedWeathers(repository);

  @lazySingleton
  DeleteSavedWeather provideDeleteSavedWeather(WeatherRepository repository) =>
      DeleteSavedWeather(repository);

  @injectable
  HomeCubit provideHomeCubit(GetAllHomes getAllHomes) =>
      HomeCubit(getAllHomes: getAllHomes);

  @injectable
  WeatherCubit provideWeatherCubit(
    GetWeatherByLocation getWeatherByLocation,
    SaveWeather saveWeather,
    GetSavedWeathers getSavedWeathers,
    DeleteSavedWeather deleteSavedWeather,
  ) => WeatherCubit(
    getWeatherByLocation: getWeatherByLocation,
    saveWeather: saveWeather,
    getSavedWeathersUseCase: getSavedWeathers,
    deleteSavedWeatherUseCase: deleteSavedWeather,
  );
}
