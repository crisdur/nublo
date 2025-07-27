import 'package:latlong2/latlong.dart';
import '../../../../../core/network/client/weather_client.dart';

abstract class WeatherRemoteDataSource {
  Future<Map<String, dynamic>> getWeatherByLocation(LatLng location);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final WeatherClient client;

  WeatherRemoteDataSourceImpl(this.client);

  @override
  Future<Map<String, dynamic>> getWeatherByLocation(LatLng location) async {
    final response = await client.dio.get(
      'weather',
      queryParameters: {
        'lat': location.latitude.toString(),  
        'lon': location.longitude.toString(), 
        'APPID': client.apiKey, 
        'units': 'metric',
      },
    );
    return response.data;
  }
} 