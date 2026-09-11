enum TimelineEventType {
  success,
  rain,
  panel,
  congestion,
  speed,
  incident,
  smoke,
  connection,
}

class TimelineEvent {
  const TimelineEvent({
    required this.time,
    required this.title,
    required this.type,
    this.detail,
  });

  final String time;
  final String title;
  final TimelineEventType type;
  final String? detail;
}
