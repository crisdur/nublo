import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:nublo/core/di/injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: false,
)
void configureDependencies() => init(getIt);