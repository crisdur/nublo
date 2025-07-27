import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nublo/features/home/domain/usecases/save_weather.dart';
import '../../domain/entities/weather/weather.dart';
import '../cubit/weather/weather_cubit.dart';

class WeatherDialog extends StatelessWidget {
  final Weather weather;

  const WeatherDialog({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${weather.cityName}, ${weather.country}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Weather: ${weather.main}'),
          Text('Description: ${weather.description}'),
          Text('Temperature: ${weather.temperature.round()}°C'),
          Text('Feels like: ${weather.feelsLike.round()}°C'),
          Text('Humidity: ${weather.humidity}%'),
          Text('Wind Speed: ${weather.windSpeed.toStringAsFixed(1)} m/s'),
          Text('Visibility: ${(weather.visibility / 1000).toStringAsFixed(1)} km'),
          Text('Location: ${weather.location.latitude.toStringAsFixed(4)}, ${weather.location.longitude.toStringAsFixed(4)}'),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () async {
                  final weatherCubit = GetIt.I<WeatherCubit>();
                  await weatherCubit.saveWeather(SaveWeatherParams(weather));
                  await weatherCubit.loadSavedWeathers();

                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
                child: const Text('Save Weather Info'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
