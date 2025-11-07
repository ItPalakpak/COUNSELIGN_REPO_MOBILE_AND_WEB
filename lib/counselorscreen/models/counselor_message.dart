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
    final DateTime localCreatedAt = createdAt.toLocal();
    final DateTime now = DateTime.now();
    final Duration diff = now.difference(localCreatedAt);

    // If less than a minute ago
    if (diff.inMinutes < 1) {
      return 'Just now';
    }

    // If less than an hour ago
    if (diff.inHours < 1) {
      return '${diff.inMinutes}m ago';
    }

    // If today
    if (localCreatedAt.day == now.day &&
        localCreatedAt.month == now.month &&
        localCreatedAt.year == now.year) {
      return _formatTime12Hour(localCreatedAt);
    }

    // If this year
    if (localCreatedAt.year == now.year) {
      return '${_getMonthName(localCreatedAt.month)} ${localCreatedAt.day}, ${_formatTime12Hour(localCreatedAt)}';
    }

    // Otherwise show full date
    return '${_getMonthName(localCreatedAt.month)} ${localCreatedAt.day}, ${localCreatedAt.year} ${_formatTime12Hour(localCreatedAt)}';
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

  String _formatTime12Hour(DateTime dateTime) {
    final int hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final String minute = dateTime.minute.toString().padLeft(2, '0');
    final String period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
