import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Добавьте этот импорт для SystemChrome
import 'package:google_fonts/google_fonts.dart';

class Themes {
  static const _defaultSeedColor = Colors.blue;

  static ThemeData createTheme(ColorScheme? dynamicColorScheme, Brightness brightness) {
    final colorScheme = dynamicColorScheme ?? ColorScheme.fromSeed(
      seedColor: _defaultSeedColor,
      brightness: brightness,
    );

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,

      systemNavigationBarIconBrightness: brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,

      statusBarColor: Colors.transparent,
      statusBarIconBrightness: brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,
    ));

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      applyElevationOverlayColor: true,
      textTheme: GoogleFonts.robotoFlexTextTheme(
        ThemeData(brightness: brightness).textTheme,
      ),
    );
  }
}