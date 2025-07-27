import 'package:nublo/core/error/failure.dart';
import 'package:sqflite/sqflite.dart';
import '../../../domain/entities/weather/weather.dart';
import 'package:latlong2/latlong.dart';

abstract class WeatherLocalDataSource {
  Future<void> saveWeather(Weather weather);
  Future<List<Weather>> getSavedWeathers();
  Future<void> deleteWeather(int weatherId);
}

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final Database database;

  WeatherLocalDataSourceImpl(this.database);

  @override
  Future<void> saveWeather(Weather weather) async {
    try {
      final uniqueId = '${weather.id}_${DateTime.now().millisecondsSinceEpoch}';
      await database.insert(
        'weathers',
        {
          'id': uniqueId,
          'main': weather.main,
          'description': weather.description,
          'icon': weather.icon,
          'temperature': weather.temperature,
          'feels_like': weather.feelsLike,
          'humidity': weather.humidity,
          'wind_speed': weather.windSpeed,
          'visibility': weather.visibility,
          'latitude': weather.location.latitude,
          'longitude': weather.location.longitude,
          'city_name': weather.cityName,
          'country': weather.country,
          'saved_at': DateTime.now().toIso8601String(),
        }
      );
    } catch (e) {
      throw CacheFailure();
    }
  }

  @override
  Future<List<Weather>> getSavedWeathers() async {
    final List<Map<String, dynamic>> maps = await database.query('weathers');

    return List.generate(maps.length, (i) {
      final originalId = maps[i]['id'].toString().split('_')[0];
      return Weather(
        id: originalId,
        main: maps[i]['main'],
        description: maps[i]['description'],
        icon: maps[i]['icon'],
        temperature: maps[i]['temperature'],
        feelsLike: maps[i]['feels_like'],
        humidity: maps[i]['humidity'],
        windSpeed: maps[i]['wind_speed'],
        visibility: maps[i]['visibility'],
        location: LatLng(maps[i]['latitude'], maps[i]['longitude']),
        cityName: maps[i]['city_name'],
        country: maps[i]['country'],
        savedAt: DateTime.parse(maps[i]['saved_at']),
      );
    });
  }

  @override
  Future<void> deleteWeather(int weatherId) async {
    final List<Map<String, dynamic>> records = await database.query(
      'weathers',
      where: 'id LIKE ?',
      whereArgs: ['${weatherId.toString()}_%'],
      orderBy: 'saved_at DESC',
      limit: 1
    );

    if (records.isNotEmpty) {
      await database.delete(
        'weathers',
        where: 'id = ?',
        whereArgs: [records[0]['id']],
      );
    }
  }
}