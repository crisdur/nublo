import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import 'package:nublo/core/constants/app_colors.dart';
import 'package:nublo/core/constants/auth0_constants.dart';
import 'package:nublo/core/widgets/appbar/custom_app_bar.dart';
import 'package:nublo/core/constants/loading_status.dart';
import 'package:nublo/core/constants/auth_status.dart';
import 'package:nublo/core/router/app_router.gr.dart';
import 'package:nublo/core/services/location/location_service.dart';
import '../../../domain/entities/weather/weather.dart';
import '../../cubit/weather/weather_cubit.dart';
import '../../cubit/weather/weather_state.dart';
import '../../widgets/weather_dialog.dart';
import '../../widgets/saved_addresses_dialog.dart';
import '../../widgets/logout_dialog.dart';
import '../../../../auth/presentation/cubit/auth/auth_cubit.dart';
import '../../../../auth/presentation/cubit/auth/auth_state.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MapController mapController = MapController();
  late final LocationService _locationService;

  LatLng _currentPosition = const LatLng(4.6097, -74.0817);
  bool _isLoadingLocation = false;

  late final WeatherCubit _weatherCubit;

  @override
  void initState() {
    super.initState();
    _locationService = GetIt.I<LocationService>();
    _weatherCubit = GetIt.I<WeatherCubit>();
    // Get weather for initial Colombia location
    _weatherCubit.getWeather(_currentPosition);
  }

  void _showWeatherDialog(BuildContext context, Weather weather) {
    showDialog(
      context: context,
      builder: (dialogContext) => WeatherDialog(weather: weather),
    );
  }

  void _showSavedAddressesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => const SavedAddressesDialog(),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const LogoutDialog(),
    );
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  Future<void> _centerOnCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final location = await _locationService.getCurrentLocation();
      if (location != null) {
        setState(() {_currentPosition = location;});

        mapController.moveAndRotate(location, 13.0, 0.0);

        if (mounted) {_weatherCubit.getWeather(location);}
        
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Could not get current location. Please check your location permissions.',
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error getting location: $e')));
      }
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _weatherCubit),
        BlocProvider.value(value: GetIt.I<AuthCubit>()),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, authState) {
          if (authState.status == AuthStatus.unauthenticated) {
            context.router.replace(const SplashRoute());
          }
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: CustomAppBar(
            title: 'Weather Map',
            actions: [
              IconButton(
                icon: const Icon(Icons.my_location),
                onPressed: _centerOnCurrentLocation,
                tooltip: 'Center on Current Location',
              ),
              IconButton(
                icon: const Icon(Icons.history),
                onPressed: () => _showSavedAddressesDialog(context),
                tooltip: 'Saved Addresses',
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => _logout(context),
                tooltip: 'Logout',
              ),
            ],
          ),
          body: BlocConsumer<WeatherCubit, WeatherState>(
            listener: (context, state) {
              if (state.failure != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.failure?.message ?? 'Error getting weather info',
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  _MapWidget(
                    mapController: mapController,
                    currentPosition: _currentPosition,
                    currentWeather: state.currentWeather,
                    onTap: (point) =>
                        context.read<WeatherCubit>().getWeather(point),
                    onWeatherTap: (weather) =>
                        _showWeatherDialog(context, weather),
                  ),
                  if (state.status == LoadingStatus.loading ||
                      _isLoadingLocation)
                    const Center(child: CircularProgressIndicator()),
                ],
              );
            },
          ),
          floatingActionButton: _MapFloatingActionButtons(
            mapController: mapController,
            isLoadingLocation: _isLoadingLocation,
            onCenterLocation: _centerOnCurrentLocation,
          ),
        ),
      ),
    );
  }
}

class _MapWidget extends StatelessWidget {
  final MapController mapController;
  final LatLng currentPosition;
  final Weather? currentWeather;
  final Function(LatLng) onTap;
  final Function(Weather) onWeatherTap;

  const _MapWidget({
    required this.mapController,
    required this.currentPosition,
    required this.currentWeather,
    required this.onTap,
    required this.onWeatherTap,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: currentPosition,
        initialZoom: 6.0,
        onTap: (_, point) {
          onTap(point);
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: Auth0Constants.scheme,
        ),
        if (currentWeather != null)
          MarkerLayer(
            markers: [
              Marker(
                point: currentWeather!.location,
                width: 80,
                height: 80,
                child: GestureDetector(
                  onTap: () => onWeatherTap(currentWeather!),
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            'https://openweathermap.org/img/w/${currentWeather!.icon}.png',
                        width: 50,
                        height: 50,
                      ),
                      Text(
                        '${currentWeather!.temperature.round()}°C',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _MapFloatingActionButtons extends StatelessWidget {
  final MapController mapController;
  final bool isLoadingLocation;
  final VoidCallback onCenterLocation;

  const _MapFloatingActionButtons({
    required this.mapController,
    required this.isLoadingLocation,
    required this.onCenterLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: 'zoomIn',
          onPressed: () {
            mapController.moveAndRotate(
              mapController.camera.center,
              mapController.camera.zoom + 1.0,
              mapController.camera.rotation,
            );
          },
          tooltip: 'Zoom In',
          backgroundColor: AppColors.purple,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          heroTag: 'zoomOut',
          onPressed: () {
            mapController.moveAndRotate(
              mapController.camera.center,
              mapController.camera.zoom - 1.0,
              mapController.camera.rotation,
            );
          },
          tooltip: 'Zoom Out',
          backgroundColor: AppColors.purple,
          child: const Icon(Icons.remove, color: Colors.white),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          heroTag: 'location',
          onPressed: onCenterLocation,
          tooltip: 'Get Current Location',
          backgroundColor: AppColors.purple,
          child: isLoadingLocation
              ? const CircularProgressIndicator(color: Colors.white)
              : const Icon(Icons.my_location, color: Colors.white),
        ),
      ],
    );
  }
}
