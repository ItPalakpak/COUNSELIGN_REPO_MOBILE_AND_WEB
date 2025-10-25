class CounselorMessage {
  final int messageId;
  final String senderId;
  final String receiverId;
  final String messageText;
  final String messageType; // 'sent' or 'received'
  final DateTime createdAt;
  final bool isRead;

  CounselorMessage({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.messageText,
    required this.messageType,
    required this.createdAt,
    required this.isRead,
  });

  factory CounselorMessage.fromJson(Map<String, dynamic> json) {
    return CounselorMessage(
      messageId: _parseInt(json['message_id']) ?? 0,
      senderId: json['sender_id']?.toString() ?? '',
      receiverId: json['receiver_id']?.toString() ?? '',
      messageText: json['message_text']?.toString() ?? '',
      messageType: json['message_type']?.toString() ?? 'received',
      createdAt: _parseDateTime(json['created_at']),
      isRead:
          json['is_read'] == 1 ||
          json['is_read'] == true ||
          json['is_read'] == '1',
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      return parsed ?? DateTime.now();
    }
    return DateTime.now();
  }

  bool get isSent => messageType == 'sent';
  bool get isReceived => messageType == 'received';

  String get formattedTime {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    // If less than a minute ago
    if (diff.inMinutes < 1) {
      return 'Just now';
    }

    // If less than an hour ago
    if (diff.inHours < 1) {
      return '${diff.inMinutes}m ago';
    }

    // If today
    if (createdAt.day == now.day &&
        createdAt.month == now.month &&
        createdAt.year == now.year) {
      return '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
    }

    // If this year
    if (createdAt.year == now.year) {
      return '${_getMonthName(createdAt.month)} ${createdAt.day}';
    }

    // Otherwise show full date
    return '${_getMonthName(createdAt.month)} ${createdAt.day}, ${createdAt.year}';
  }

  String _getMonthName(int month) {
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
    return months[month - 1];
  }
}
