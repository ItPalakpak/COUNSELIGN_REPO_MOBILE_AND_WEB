import '../../api/config.dart';

class Conversation {
  final String userId;
  final String userName;
  final String? profilePicture;
  final String lastMessage;
  final String lastMessageTime;
  final String lastMessageType; // 'sent' or 'received'
  final int unreadCount;
  final String? statusText;

  Conversation({
    required this.userId,
    required this.userName,
    this.profilePicture,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.lastMessageType,
    required this.unreadCount,
    this.statusText,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      userId:
          json['other_user_id']?.toString() ??
          json['user_id']?.toString() ??
          '',
      userName:
          json['other_username']?.toString() ??
          json['name']?.toString() ??
          'Unknown',
      profilePicture: _buildImageUrl(json['other_profile_picture']),
      lastMessage: json['last_message']?.toString() ?? 'No messages yet',
      lastMessageTime: json['last_message_time']?.toString() ?? '',
      lastMessageType: json['last_message_type']?.toString() ?? 'received',
      unreadCount: _parseInt(json['unread_count']) ?? 0,
      statusText: json['status_text']?.toString(),
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static String _buildImageUrl(String? profilePicture) {
    if (profilePicture == null || profilePicture.isEmpty) {
      return 'Photos/profile.png';
    }
    if (profilePicture.startsWith('http')) {
      return profilePicture;
    }
    String baseUrl = ApiConfig.currentBaseUrl;
    if (baseUrl.endsWith('/index.php')) {
      baseUrl = baseUrl.replaceAll('/index.php', '');
    }
    return '$baseUrl/$profilePicture';
  }

  bool get hasUnreadMessages => unreadCount > 0;

  String get formattedLastMessage {
    if (lastMessageType == 'sent') {
      return 'You: $lastMessage';
    } else if (lastMessageType == 'received') {
      return 'Sent a Message: $lastMessage';
    }
    return lastMessage;
  }

  String get truncatedLastMessage {
    const maxLength = 20;
    if (formattedLastMessage.length > maxLength) {
      return '${formattedLastMessage.substring(0, maxLength - 3)}...';
    }
    return formattedLastMessage;
  }
}
