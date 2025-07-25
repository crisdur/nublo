import 'package:flutter/material.dart';
import 'package:nublo/core/di/injection.dart';
import 'package:nublo/core/router/app_router.dart';
import 'package:nublo/core/services/navigation/navigation_service.dart';
import 'package:nublo/core/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final AppRouter appRouter = AppRouter();
    final NavigationService navigationService = getIt<NavigationService>();

    return MaterialApp.router(
      title: 'Nublo',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: navigationService.scaffoldMessengerKey,
      theme: themeData,
      routerConfig: appRouter.config(),
    );
  }
}