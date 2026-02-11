import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ru_psu_timetable/models/schedule_event.dart';

class ScheduleCard extends StatelessWidget {
  final ScheduleEvent event;
  final String languageCode;

  const ScheduleCard({
    super.key,
    required this.event,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final timeFormatter = DateFormat('HH:mm', languageCode);
    final timeRange = '${timeFormatter.format(event.startTime)} – ${timeFormatter.format(event.endTime)}';

    return Card(
      color: colorScheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: colorScheme.onSurfaceVariant.withAlpha(50),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Время
            Text(
              timeRange,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.normal,
                color: colorScheme.primary,
              ),
            ),

            // Название
            Text(
              event.summary,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.normal,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Локация
            if (event.location.isNotEmpty) ...[
              _buildCompactInfoRow(
                context,
                Icons.location_on_outlined,
                event.location,
              ),
              const SizedBox(height: 6),
            ],

            // Преподаватель
            if (event.description.isNotEmpty)
              _buildCompactInfoRow(
                context,
                Icons.person_outline,
                event.description,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactInfoRow(BuildContext context, IconData icon, String value, {Color? valueColor}) {
    final theme = Theme.of(context);
    final onSurfaceVariant = theme.colorScheme.onSurfaceVariant;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: onSurfaceVariant.withOpacity(0.7),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: valueColor ?? onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}