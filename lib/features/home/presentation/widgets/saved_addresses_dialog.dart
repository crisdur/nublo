import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nublo/core/constants/app_colors.dart';
import '../../../../core/constants/loading_status.dart';
import '../../domain/entities/weather/weather.dart';
import '../cubit/weather/weather_cubit.dart';
import '../cubit/weather/weather_state.dart';

class SavedAddressesDialog extends StatefulWidget {
  const SavedAddressesDialog({super.key});

  @override
  State<SavedAddressesDialog> createState() => _SavedAddressesDialogState();
}

class _SavedAddressesDialogState extends State<SavedAddressesDialog> {
  late final WeatherCubit _weatherCubit;

  @override
  void initState() {
    super.initState();
    _weatherCubit = GetIt.I<WeatherCubit>();
    _weatherCubit.loadSavedWeathers();
  }

  Future<void> _deleteWeather(Weather weather) async {
    await _weatherCubit.deleteSavedWeather(int.parse(weather.id));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Saved Weather Addresses'),
      content: SizedBox(
        width: double.maxFinite,
        height: 500,
        child: BlocBuilder<WeatherCubit, WeatherState>(
          bloc: _weatherCubit,
          builder: (context, state) {
            if (state.status == LoadingStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            final savedWeathers = state.savedWeathers;

            if (savedWeathers.isEmpty) {
              return const Center(
                child: Text('No saved weather addresses yet.'),
              );
            }

            return ScrollConfiguration(
              behavior: ScrollConfiguration.of(
                context,
              ).copyWith(scrollbars: true),
              child: RawScrollbar(
                thumbColor: AppColors.blue,
                thumbVisibility: true,
                trackVisibility: true,
                thickness: 8,
                radius: const Radius.circular(20),
                child: ListView.builder(
                  itemCount: savedWeathers.length,
                  itemBuilder: (context, index) {
                    final weather =
                        savedWeathers[savedWeathers.length - 1 - index];
                    return ListTile(
                      leading: CachedNetworkImage(
                        imageUrl:
                            'https://openweathermap.org/img/w/${weather.icon}.png',
                        width: 40,
                        height: 40,
                      ),
                      title: Text(
                        '${weather.cityName}, ${weather.country} - ${weather.temperature.round()}°C',
                      ),
                      subtitle: Text(
                        '${weather.location.latitude.toStringAsFixed(4)}, ${weather.location.longitude.toStringAsFixed(4)}\n'
                        'Saved: ${weather.savedAt?.toString().substring(0, 19) ?? 'Unknown'}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteWeather(weather),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
