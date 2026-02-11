import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ru_psu_timetable/models/schedule_event.dart';
import 'package:ru_psu_timetable/services/ical_parser.dart';
import 'package:ru_psu_timetable/settings/language.dart';

class ScheduleResult {
  final List<ScheduleEvent>? events;
  final String? errorMessage;

  ScheduleResult.success(this.events) : errorMessage = null;
  ScheduleResult.error(this.errorMessage) : events = null;

  bool get isSuccess => events != null;
}
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
class ScheduleService {
  ScheduleService();

  Future<ScheduleResult> fetchSchedule(String urlString, Locale locale) async {


    final client = http.Client();
    try {
      final uri = Uri.parse(urlString);
      final response =
      await client.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        try {
          if (response.body.trim().isEmpty) {
            return ScheduleResult.error(
              getTranslatedString(locale, 'no_schedule_title'),
            );
          }

          final events = parseIcalData(response.body);

          if (events.isNotEmpty) {
            return ScheduleResult.success(events);
          } else {
            return ScheduleResult.error(
              '${getTranslatedString(locale, 'no_schedule_title')}\n${getTranslatedString(locale, 'no_schedule_body')}',
            );
          }
        } catch (e) {
          return ScheduleResult.error(
              '${getTranslatedString(locale, 'error_loading_title')}: Ошибка парсинга данных.');
        }
      } else {
        return ScheduleResult.error(
            '${getTranslatedString(locale, 'error_loading_title')}. Статус код: ${response.statusCode}.');
      }
    } on SocketException {
      return ScheduleResult.error(
          '${getTranslatedString(locale, 'error_loading_title')}: Ошибка сети.');
    } on FormatException {
      return ScheduleResult.error(
          '${getTranslatedString(locale, 'error_loading_title')}: Некорректный формат URL.');
    } on TimeoutException {
      return ScheduleResult.error(
          '${getTranslatedString(locale, 'error_loading_title')}: Сервер не отвечает (Таймаут).');
    } catch (e) {
      return ScheduleResult.error(
          '${getTranslatedString(locale, 'error_loading_title')}: Неизвестная ошибка: $e');
    }
  }
}