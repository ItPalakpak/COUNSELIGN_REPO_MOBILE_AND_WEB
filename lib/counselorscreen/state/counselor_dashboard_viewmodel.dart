import 'package:flutter/material.dart';
import '../../utils/session.dart';
import 'dart:convert';
import '../../api/config.dart';
import '../../utils/secure_logger.dart';
import '../models/counselor_profile.dart';
import '../models/message.dart';
import '../models/notification.dart';

class CounselorDashboardViewModel extends ChangeNotifier {
  // Counselor profile data
  CounselorProfile? _counselorProfile;
  CounselorProfile? get counselorProfile => _counselorProfile;

  String? _lastLogin;
  String? get lastLogin => _lastLogin;

  // Derived display fields for UI
  String get displayName {
    final profile = _counselorProfile;
    if (profile == null) return 'Counselor';
    return profile.displayName;
  }

  bool get hasName {
    final profile = _counselorProfile;
    if (profile == null) return false;
    return profile.hasName;
  }

  String get userId {
    final profile = _counselorProfile;
    if (profile == null) return '';
    return profile.userId;
  }

  String get profileImageUrl {
    if (_counselorProfile == null) {
      debugPrint('🖼️ Dashboard: No profile loaded, using default');
      // Fix: Remove /index.php from baseUrl if it exists for default image too
      String cleanBaseUrl = ApiConfig.currentBaseUrl;
      if (cleanBaseUrl.endsWith('/index.php')) {
        cleanBaseUrl = cleanBaseUrl.replaceAll('/index.php', '');
      }
      return '$cleanBaseUrl/Photos/profile.png';
    }

    final imageUrl = _counselorProfile!.buildImageUrl(ApiConfig.currentBaseUrl);
    debugPrint('🖼️ Dashboard: Profile picture URL: $imageUrl');
    debugPrint(
      '🖼️ Dashboard: Profile picture field: ${_counselorProfile!.profilePicture}',
    );
    return imageUrl;
  }

  String get formattedLastLogin {
    if (_lastLogin == null || _lastLogin!.isEmpty) return 'N/A';
    final raw = _lastLogin!;
    final normalized = raw.contains('T') ? raw : raw.replaceFirst(' ', 'T');
    final parsed = DateTime.tryParse(normalized);
    if (parsed == null) return raw;
    final local = parsed.toLocal();
    return '${_monthName(local.month)} ${local.day}, ${local.year} ${_formatTime(local)}';
  }

  // Loading states
  bool _isLoadingProfile = true;
  bool get isLoadingProfile => _isLoadingProfile;

  // Drawer state
  bool _isDrawerOpen = false;
  bool get isDrawerOpen => _isDrawerOpen;

  // Chat state
  bool _isChatOpen = false;
  bool get isChatOpen => _isChatOpen;

  // Notifications state
  bool _isNotificationsOpen = false;
  bool get isNotificationsOpen => _isNotificationsOpen;

  // Recent appointments state
  List<dynamic> _recentAppointments = [];
  List<dynamic> get recentAppointments => _recentAppointments;

  // Messages
  List<Message> _messages = [];
  List<Message> get messages => _messages;

  int _unreadMessagesCount = 0;
  int get unreadMessagesCount => _unreadMessagesCount;

  // Notifications
  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;

  int _unreadNotificationsCount = 0;
  int get unreadNotificationsCount => _unreadNotificationsCount;

  final Session _session = Session();

  void initialize() {
    debugPrint('Initializing counselor dashboard...');
    fetchCounselorProfile();
    fetchMessages();
    fetchNotifications();
    fetchRecentAppointments();
  }

  // Fetch counselor profile
  Future<void> fetchCounselorProfile() async {
    try {
      _isLoadingProfile = true;
      notifyListeners();

      debugPrint(
        '🔍 Fetching counselor profile from: ${ApiConfig.currentBaseUrl}/counselor/profile/get',
      );
      final response = await _session.get(
        '${ApiConfig.currentBaseUrl}/counselor/profile/get',
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint('Profile API Response Status: ${response.statusCode}');
      debugPrint('Profile API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('Profile API Data: $data');
        if (data['success'] == true) {
          debugPrint('🖼️ Dashboard: Raw API response data: $data');
          debugPrint(
            '🖼️ Dashboard: profile_picture field: ${data['profile_picture']}',
          );
          debugPrint('🖼️ Dashboard: counselor data: ${data['counselor']}');
          debugPrint(
            '🔍 Counselor name fields - first_name: ${data['counselor']?['first_name']}, last_name: ${data['counselor']?['last_name']}, full_name: ${data['counselor']?['full_name']}',
          );

          // Check if profile_picture is in the counselor object instead
          if (data['counselor'] != null) {
            debugPrint(
              '🖼️ Dashboard: counselor profile_picture: ${data['counselor']['profile_picture']}',
            );
          }

          // Create profile data from the response format using the new structure
          final profileData = {
            'id': data['user_id'] ?? 0,
            'user_id': data['user_id'] ?? '',
            'username': data['username'] ?? data['user_id'] ?? '',
            'email': data['email'] ?? '',
            'role': data['role'] ?? 'counselor',
            'last_login': data['last_login'],
            'profile_picture':
                data['profile_picture'] ??
                data['counselor']?['profile_picture'],
            'counselor': data['counselor'],
          };

          debugPrint('🖼️ Dashboard: Created profile data: $profileData');
          _counselorProfile = CounselorProfile.fromJson(profileData);
          _lastLogin = data['last_login']?.toString();
          _isLoadingProfile = false;
          debugPrint(
            'Profile loaded: ${_counselorProfile?.counselor?.name ?? _counselorProfile?.username ?? 'Unknown'}, Last login: $_lastLogin',
          );
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error fetching counselor profile: $e');
    } finally {
      _isLoadingProfile = false;
      notifyListeners();
    }
  }

  // ---------------- Formatting helpers ----------------
  String _monthName(int m) {
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
    if (m < 1 || m > 12) return '';
    return months[m - 1];
  }

  String _formatTime(DateTime dt) {
    final hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour12:$minute $period';
  }

  // Fetch messages
  Future<void> fetchMessages() async {
    try {
      final response = await _session.get(
        '${ApiConfig.currentBaseUrl}/counselor/message/operations?action=get_dashboard_messages&limit=2',
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint('Messages API Response Status: ${response.statusCode}');
      debugPrint('Messages API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('Messages API Data: $data');
        if (data['success'] == true) {
          // Convert conversations to messages for display
          final conversations = data['conversations'] as List? ?? [];
          _messages = conversations
              .map(
                (conv) => Message(
                  id: 0, // Dashboard messages don't need real IDs
                  senderId: conv['other_user_id'] ?? '',
                  senderName: conv['other_username'] ?? 'Unknown',
                  receiverId: '', // Not needed for dashboard
                  messageText: conv['last_message'] ?? '',
                  createdAt:
                      DateTime.tryParse(conv['last_message_time'] ?? '') ??
                      DateTime.now(),
                  isRead: conv['unread_count'] == 0,
                  lastActivity: conv['last_activity']?.toString(),
                  lastLogin: conv['last_login']?.toString(),
                  logoutTime: conv['logout_time']?.toString(),
                ),
              )
              .toList();
          _unreadMessagesCount = _messages.where((m) => !m.isRead).length;
          debugPrint(
            'Messages loaded: ${_messages.length} messages, $_unreadMessagesCount unread',
          );
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error fetching messages: $e');
    }
  }

  // Fetch notifications
  Future<void> fetchNotifications() async {
    try {
      debugPrint(
        '🔍 Fetching notifications from: ${ApiConfig.currentBaseUrl}/counselor/notifications',
      );
      final response = await _session.get(
        '${ApiConfig.currentBaseUrl}/counselor/notifications',
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint('Notifications API Response Status: ${response.statusCode}');
      debugPrint('Notifications API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('Notifications API Data: $data');
        if (data['status'] == 'success') {
          _notifications =
              (data['notifications'] as List?)
                  ?.map((n) => NotificationModel.fromJson(n))
                  .toList() ??
              [];
          _unreadNotificationsCount = data['unread_count'] ?? 0;
          debugPrint(
            'Notifications loaded: ${_notifications.length} notifications, $_unreadNotificationsCount unread',
          );
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
    }
  }

  // Send message
  Future<bool> sendMessage(String message) async {
    try {
      final formData = {
        'message': message,
        'receiver_id': 'admin123', // Admin ID
      };

      final response = await _session.post(
        '${ApiConfig.currentBaseUrl}/counselor/message/send',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: formData,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          await fetchMessages(); // Refresh messages
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error sending message: $e');
      return false;
    }
  }

  // Mark notification as read
  Future<bool> markNotificationAsRead(int notificationId) async {
    try {
      final response = await _session.post(
        '${ApiConfig.currentBaseUrl}/counselor/notifications/mark-read',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'notification_id': notificationId.toString()},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final notificationIndex = _notifications.indexWhere(
            (n) => n.id == notificationId,
          );
          if (notificationIndex != -1) {
            _notifications[notificationIndex] =
                _notifications[notificationIndex].copyWith(isRead: true);
            _unreadNotificationsCount = _notifications
                .where((n) => !n.isRead)
                .length;
            notifyListeners();
          }
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
      return false;
    }
  }

  // Drawer methods
  void toggleDrawer() {
    _isDrawerOpen = !_isDrawerOpen;
    notifyListeners();
  }

  void closeDrawer() {
    _isDrawerOpen = false;
    notifyListeners();
  }

  // Chat methods
  void toggleChat() {
    _isChatOpen = !_isChatOpen;
    if (_isChatOpen) {
      _isNotificationsOpen = false; // Close notifications if open
    }
    notifyListeners();
  }

  void closeChat() {
    _isChatOpen = false;
    notifyListeners();
  }

  // Notifications methods
  void toggleNotifications() {
    _isNotificationsOpen = !_isNotificationsOpen;
    if (_isNotificationsOpen) {
      _isChatOpen = false; // Close chat if open
    }
    notifyListeners();
  }

  void closeNotifications() {
    _isNotificationsOpen = false;
    notifyListeners();
  }

  // Navigation methods
  void navigateToAnnouncements(BuildContext context) {
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/counselor/announcements');
    }
  }

  void navigateToScheduledAppointments(BuildContext context) {
    if (context.mounted) {
      Navigator.pushReplacementNamed(
        context,
        '/counselor/appointments/scheduled',
      );
    }
  }

  void navigateToFollowUpSessions(BuildContext context) {
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/counselor/follow-up');
    }
  }

  void navigateToProfile(BuildContext context) {
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/counselor/profile');
    }
  }

  void logout(BuildContext context) async {
    try {
      // Call logout endpoint to update activity fields in database
      debugPrint('🚪 Calling logout endpoint...');
      final response = await _session.get(
        '${ApiConfig.currentBaseUrl}/auth/logout',
        headers: {'Content-Type': 'application/json'},
      );
      debugPrint('🚪 Logout response status: ${response.statusCode}');
    } catch (e) {
      debugPrint('Error calling logout endpoint: $e');
      // Continue with logout even if endpoint call fails
    } finally {
      // Clear session cookies
      _session.clearCookies();
      // Navigate back to landing
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    }
  }

  // Fetch recent pending appointments
  Future<void> fetchRecentAppointments() async {
    try {
      final response = await _session.get(
        '${ApiConfig.currentBaseUrl}/counselor/dashboard/recent-pending-appointments',
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          _recentAppointments = data['appointments'] ?? [];
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error fetching recent appointments: $e');
    }
  }
}
