class Event {
  final int id;
  final String title;
  final String description;
  final DateTime? date;
  final String? time;
  final String? location;

  Event({
    required this.id,
    required this.title,
    required this.description,
    this.date,
    this.time,
    this.location,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: _parseInt(json['id']),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      date: _parseDateTime(json['date']),
      time: json['time']?.toString(),
      location: json['location']?.toString(),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString());
    } catch (e) {
      return null;
    }
  }

  String get formattedTime {
    if (time == null) return '';
    try {
      final timeObj = DateTime.parse('1970-01-01T$time');
      return '${timeObj.hour.toString().padLeft(2, '0')}:'
          '${timeObj.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return time!;
    }
  }

  String get monthShort {
    if (date == null) return '';
    return date!.toLocal().month.toString().padLeft(2, '0');
  }

  String get dayPadded {
    if (date == null) return '';
    return date!.toLocal().day.toString().padLeft(2, '0');
  }

  String get monthName {
    if (date == null) return '';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[date!.toLocal().month - 1];
  }
}
