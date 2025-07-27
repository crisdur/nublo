import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

/// Class that contains all the app's colors
class AppColors {
  AppColors._();

  static Color purple = HexColor('#6A3DE8');
  static Color blue = HexColor('#536DFE');

  static LinearGradient get backgroundGradient => LinearGradient(
    colors: [AppColors.blue, AppColors.purple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
