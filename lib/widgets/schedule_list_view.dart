import 'package:flutter/material.dart';
import 'package:ru_psu_timetable/models/schedule_event.dart';
import 'package:ru_psu_timetable/widgets/schedule_card.dart';

class ScheduleListView extends StatelessWidget {
  final List<ScheduleEvent> lessons;
  final String emptyMessage;
  final String languageCode;

  const ScheduleListView({
    super.key,
    required this.lessons,
    required this.emptyMessage,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    if (lessons.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            emptyMessage,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        return ScheduleCard(
          event: lessons[index],
          languageCode: languageCode,
        );
      },
    );
  }
}