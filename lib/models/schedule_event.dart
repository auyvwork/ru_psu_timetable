class ScheduleEvent {
  final String summary;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final String status;

  ScheduleEvent({
    required this.summary,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.status,
  });

  factory ScheduleEvent.fromJson(Map<String, dynamic> json) {
    return ScheduleEvent(
      summary: json['summary'] as String,
      description: json['description'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      location: json['location'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'location': location,
      'status': status,
    };
  }
}