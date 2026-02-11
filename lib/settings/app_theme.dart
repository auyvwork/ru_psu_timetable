import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {

  static const _defaultSeedColor = Colors.blue;

  static ThemeData createTheme(ColorScheme? dynamicColorScheme, Brightness brightness) {
    final colorScheme = dynamicColorScheme ?? ColorScheme.fromSeed(
      seedColor: _defaultSeedColor,
      brightness: brightness,
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      textTheme: GoogleFonts.robotoFlexTextTheme(
        ThemeData(brightness: brightness).textTheme,
      ),
    );
  }
}