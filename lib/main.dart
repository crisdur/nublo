import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nublo/app.dart';
import 'package:nublo/core/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]);
  configureDependencies();
  runApp(const App());
}