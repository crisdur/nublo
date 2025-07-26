import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

ThemeData themeData = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.white,
    primary: AppColors.purple,
    secondary: AppColors.blue,
    brightness: Brightness.dark,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Colors.white,
  ),
  textTheme: GoogleFonts.latoTextTheme(
    ThemeData(brightness: Brightness.dark).textTheme,
  ),
);
