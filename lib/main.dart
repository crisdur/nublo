import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nublo/app.dart';
import 'package:nublo/core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]);
  await configureDependencies();
  runApp(const App());
}