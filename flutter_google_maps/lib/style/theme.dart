import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData claro = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.fundoClaro,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.verdeEscuro,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.verdeEscuro,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.fundoClaro,
    ),
  );

  static ThemeData escuro = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.fundoEscuro,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.verdeMedio,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.fundoEscuro,
      foregroundColor: AppColors.verdeClaro,
      elevation: 0,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.fundoEscuro,
    ),
  );
}