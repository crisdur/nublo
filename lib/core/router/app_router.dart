import 'package:auto_route/auto_route.dart';
import 'package:nublo/core/di/injection.dart';
import 'package:nublo/core/router/app_router.gr.dart';
import 'package:nublo/core/services/navigation/navigation_service.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter() : super(navigatorKey: getIt<NavigationService>().navigatorKey);

  @override
  List<AutoRoute> get routes {
    return <AutoRoute>[
      AutoRoute(page: SplashRoute.page, initial: true),
      AutoRoute(page: HomeRoute.page),
      AutoRoute(page: LoginRoute.page),
    ];
  }

  @override
  RouteType get defaultRouteType => const RouteType.material();
}
