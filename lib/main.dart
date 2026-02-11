import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ru_psu_timetable/screens/schedule_screen.dart';
import 'package:ru_psu_timetable/services/schedule_service.dart';
import 'package:ru_psu_timetable/settings/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

const String _languageKey = 'app_language_code';
const String _themeKey = 'app_theme_mode';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await initializeDateFormatting('ru', null);
  await initializeDateFormatting('en', null);
  Intl.defaultLocale = 'ru';

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>()!;

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('ru');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final savedTheme = prefs.getString(_themeKey);
    ThemeMode theme = ThemeMode.system;
    if (savedTheme != null) {
      if (savedTheme == ThemeMode.light.name) {
        theme = ThemeMode.light;
      } else if (savedTheme == ThemeMode.dark.name) {
        theme = ThemeMode.dark;
      }
    }

    final savedLanguageCode = prefs.getString(_languageKey) ?? 'ru';
    final Locale savedLocale = Locale(savedLanguageCode);

    setState(() {
      _themeMode = theme;
      _locale = savedLocale;
      Intl.defaultLocale = savedLocale.languageCode;
    });
  }

  void setLocale(Locale newLocale) async {
    if (newLocale.languageCode != _locale.languageCode) {
      setState(() {
        _locale = newLocale;
        Intl.defaultLocale = newLocale.languageCode;
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, newLocale.languageCode);
    }
  }

  void setThemeMode(ThemeMode newThemeMode) async {
    if (newThemeMode == _themeMode) return;

    setState(() {
      _themeMode = newThemeMode;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, newThemeMode.name);
  }



  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        final isDark = _themeMode == ThemeMode.dark ||
            (_themeMode == ThemeMode.system && MediaQuery.of(context).platformBrightness == Brightness.dark);
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarDividerColor: Colors.transparent,
            systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
            systemNavigationBarContrastEnforced: false,
            systemStatusBarContrastEnforced: false,
          ),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Themes.createTheme(lightDynamic, Brightness.light),
            darkTheme: Themes.createTheme(darkDynamic, Brightness.dark),
            themeMode: _themeMode,
            home: const ScheduleScreen(),
          ),
        );
      },
    );
  }
}