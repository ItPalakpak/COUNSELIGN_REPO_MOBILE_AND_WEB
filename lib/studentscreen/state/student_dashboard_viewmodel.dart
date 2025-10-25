import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/config.dart';
import '../../utils/session.dart';
import '../models/notification.dart' as user_notification;
import '../models/message.dart';
import '../models/user_profile.dart';
import '../models/counselor.dart';
import '../dialogs/confirmation_dialog.dart';
import '../dialogs/alert_dialog.dart';
import '../dialogs/notice_dialog.dart';

class StudentDashboardViewModel extends ChangeNotifier {
  final Session _session = Session();

  // User profile data
  UserProfile? _userProfile;
  UserProfile? get userProfile => _userProfile;

  // Derived display fields for UI (avoids formatting in widgets)
  String get displayName => _userProfile?.displayName ?? 'Student';
  String get formattedLastLogin {
    final raw = _userProfile?.lastLogin;
    if (raw == null || raw.isEmpty) return 'N/A';
    final normalized = raw.contains('T') ? raw : raw.replaceFirst(' ', 'T');
    final parsed = DateTime.tryParse(normalized);
    if (parsed == null) return raw; // Fallback to server string if unparseable
    final local = parsed.toLocal();
    return '${_monthName(local.month)} ${local.day}, ${local.year} ${_formatTime(local)}';
  }

  // Drawer state
  bool _isDrawerOpen = false;
  bool get isDrawerOpen => _isDrawerOpen;

  // Notifications
  List<user_notification.UserNotification> _notifications = [];
  List<user_notification.UserNotification> get notifications => _notifications;
  int _unreadNotificationCount = 0;
  int get unreadNotificationCount => _unreadNotificationCount;
  bool _showNotifications = false;
  bool get showNotifications => _showNotifications;

  // Chat state
  List<Message> _messages = [];
  List<Message> get messages => _messages;

  // Get messages filtered by selected counselor
  List<Message> get counselorMessages {
    if (_selectedCounselor == null) return [];

    final counselorId = _selectedCounselor!.counselorId;
    final currentUserId = _userProfile?.userId ?? '';

    return _messages.where((message) {
      // Include messages where:
      // 1. Student sent to this counselor (sender is student, receiver is counselor)
      // 2. Counselor sent to this student (sender is counselor, receiver is student)
      return (message.senderId == currentUserId &&
              message.receiverId == counselorId) ||
          (message.senderId == counselorId &&
              message.receiverId == currentUserId);
    }).toList();
  }

  bool _showChat = false;
  bool get showChat => _showChat;
  bool _isTyping = false;
  bool get isTyping => _isTyping;
  final TextEditingController messageController = TextEditingController();
  final ScrollController chatScrollController = ScrollController();

  // Counselor selection state
  List<Counselor> _counselors = [];
  List<Counselor> get counselors => _counselors;
  Counselor? _selectedCounselor;
  Counselor? get selectedCounselor => _selectedCounselor;
  bool _isLoadingCounselors = false;
  bool get isLoadingCounselors => _isLoadingCounselors;
  bool _showCounselorSelection = false;
  bool get showCounselorSelection => _showCounselorSelection;

  // Loading states
  bool _isLoadingProfile = true;
  bool get isLoadingProfile => _isLoadingProfile;
  bool _isLoadingNotifications = false;
  bool get isLoadingNotifications => _isLoadingNotifications;
  bool _isSendingMessage = false;
  bool get isSendingMessage => _isSendingMessage;

  // PDS Reminder state
  bool _showPdsReminder = false;
  bool get showPdsReminder => _showPdsReminder;

  // Timers for polling
  Timer? _notificationTimer;
  Timer? _messageTimer;

  // Initialize the viewmodel
  void initialize() {
    loadUserProfile();
    loadNotifications();
    loadCounselors();
    startPolling();
    _checkPdsReminder();
  }

  @override
  void dispose() {
    _notificationTimer?.cancel();
    _messageTimer?.cancel();
    messageController.dispose();
    chatScrollController.dispose();
    super.dispose();
  }

  // User Profile Methods
  Future<void> loadUserProfile() async {
    try {
      final response = await _session.get(
        '${ApiConfig.currentBaseUrl}/student/profile/get',
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          _userProfile = UserProfile.fromJson(data);
          _isLoadingProfile = false;
          notifyListeners();
        } else {
          debugPrint('Failed to load profile: ${data['message']}');
          _isLoadingProfile = false;
          notifyListeners();
        }
      } else {
        debugPrint('Profile API returned status: ${response.statusCode}');
        _isLoadingProfile = false;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
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

  // Drawer Methods
  void toggleDrawer() {
    _isDrawerOpen = !_isDrawerOpen;
    notifyListeners();
  }

  void closeDrawer() {
    _isDrawerOpen = false;
    notifyListeners();
  }

  // Navigation Methods
  void navigateToAnnouncements(BuildContext context) {
    closeDrawer();
    Navigator.of(context).pushNamed('/student/announcements');
  }

  void navigateToScheduleAppointment(BuildContext context) {
    closeDrawer();
    Navigator.of(context).pushNamed('/student/schedule-appointment');
  }

  void navigateToMyAppointments(BuildContext context) {
    closeDrawer();
    Navigator.of(context).pushNamed('/student/my-appointments');
  }

  void navigateToFollowUpSessions(BuildContext context) {
    closeDrawer();
    Navigator.of(context).pushNamed('/student/follow-up-sessions');
  }

  void navigateToProfile(BuildContext context) {
    closeDrawer();
    Navigator.of(context).pushNamed('/student/profile');
  }

  void logout(BuildContext context) {
    closeDrawer();
    // Clear session cookies
    _session.clearCookies();
    // Handle logout - navigate back to landing
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  // Notification Methods
  Future<void> loadNotifications() async {
    if (_isLoadingNotifications) return;

    _isLoadingNotifications = true;
    notifyListeners();

    try {
      final response = await _session.get(
        '${ApiConfig.currentBaseUrl}/student/notifications',
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          final allNotifications =
              (data['notifications'] as List?)
                  ?.map((n) => user_notification.UserNotification.fromJson(n))
                  .toList() ??
              [];

          // Filter out message-related notifications
          // This ensures the notifications dropdown only shows non-message notifications
          // (appointments, announcements, etc.) and excludes chat/message notifications
          _notifications = allNotifications.where((notification) {
            final type = notification.type.toLowerCase();
            // Exclude message-related notification types
            return !type.contains('message') &&
                !type.contains('chat') &&
                !type.contains('messaging') &&
                !type.contains('conversation') &&
                !type.contains('reply');
          }).toList();

          // Recalculate unread count for filtered notifications
          _unreadNotificationCount = _notifications
              .where((n) => !n.isRead)
              .length;
        }
      }
    } catch (e) {
      debugPrint('Error loading notifications: $e');
    } finally {
      _isLoadingNotifications = false;
      notifyListeners();
    }
  }

  Future<void> markNotificationAsRead(int notificationId) async {
    try {
      final response = await _session.post(
        '${ApiConfig.currentBaseUrl}/student/notifications/mark-read',
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'notification_id': notificationId}),
      );

      if (response.statusCode == 200) {
        final notification = _notifications.firstWhere(
          (n) => n.id == notificationId,
        );
        notification.isRead = true;
        _unreadNotificationCount = (_unreadNotificationCount - 1)
            .clamp(0, double.infinity)
            .toInt();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }

  void toggleNotifications() {
    _showNotifications = !_showNotifications;
    if (_showNotifications) {
      _showChat = false; // Close chat if open
    }
    notifyListeners();
  }

  void closeNotifications() {
    _showNotifications = false;
    notifyListeners();
  }

  void handleNotificationTap(
    BuildContext context,
    user_notification.UserNotification notification,
  ) {
    closeNotifications();

    if (!notification.isRead) {
      markNotificationAsRead(notification.id);
    }

    // Handle navigation based on notification type
    switch (notification.type) {
      case 'appointment':
        navigateToMyAppointments(context);
        break;
      case 'event':
      case 'announcement':
        navigateToAnnouncements(context);
        break;
      case 'message':
        toggleChat();
        break;
    }
  }

  // Counselor Methods
  Future<void> loadCounselors() async {
    if (_isLoadingCounselors) return;

    _isLoadingCounselors = true;
    notifyListeners();

    try {
      final response = await _session.get(
        '${ApiConfig.currentBaseUrl}/student/get-counselors',
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success' || data['success'] == true) {
          _counselors =
              (data['counselors'] as List?)
                  ?.map((c) => Counselor.fromJson(c))
                  .toList() ??
              [];
        }
      }
    } catch (e) {
      debugPrint('Error loading counselors: $e');
    } finally {
      _isLoadingCounselors = false;
      notifyListeners();
    }
  }

  void showCounselorSelectionDialog() {
    _showCounselorSelection = true;
    notifyListeners();
  }

  void hideCounselorSelection() {
    _showCounselorSelection = false;
    notifyListeners();
  }

  void selectCounselor(Counselor counselor) {
    _selectedCounselor = counselor;
    _showCounselorSelection = false;
    _showChat = true;
    _showNotifications = false;
    loadMessages();
    startMessagePolling();
    notifyListeners();
  }

  // Chat Methods
  void toggleChat() {
    if (_selectedCounselor == null) {
      showCounselorSelectionDialog();
      return;
    }

    _showChat = !_showChat;
    if (_showChat) {
      _showNotifications = false; // Close notifications if open
      loadMessages();
      startMessagePolling();
    } else {
      stopMessagePolling();
    }
    notifyListeners();
  }

  void closeChat() {
    _showChat = false;
    stopMessagePolling();
    notifyListeners();
  }

  Future<void> loadMessages() async {
    try {
      final response = await _session.post(
        '${ApiConfig.currentBaseUrl}/student/message/operations?action=get_messages',
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final newMessages =
              (data['messages'] as List?)
                  ?.map((m) => Message.fromJson(m))
                  .toList() ??
              [];

          // Mark messages as sent/received based on current user
          final currentUserId = _userProfile?.userId ?? '';
          for (var message in newMessages) {
            // This is a simplified check - in real app you'd compare with actual user ID
            message.setCurrentUser(currentUserId);
          }

          _messages = newMessages;
          notifyListeners();

          // Scroll to bottom after loading messages
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (chatScrollController.hasClients) {
              chatScrollController.animateTo(
                chatScrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading messages: $e');
    }
  }

  Future<void> sendMessage(BuildContext context) async {
    final messageText = messageController.text.trim();
    if (messageText.isEmpty ||
        _isSendingMessage ||
        _selectedCounselor == null) {
      return;
    }

    _isSendingMessage = true;
    _isTyping = true;
    notifyListeners();

    try {
      final formData = {
        'action': 'send_message',
        'receiver_id': _selectedCounselor!.counselorId,
        'message': messageText,
      };

      final response = await _session.post(
        '${ApiConfig.currentBaseUrl}/student/message/operations',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: formData,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          messageController.clear();
          await loadMessages(); // Refresh messages

          // Fixed: Check if context is still mounted before showing snackbar
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Message sent successfully')),
            );
          }
        } else {
          // Fixed: Check if context is still mounted before showing snackbar
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(data['message'] ?? 'Failed to send message'),
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error sending message: $e');
      // Fixed: Check if context is still mounted before showing snackbar
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error sending message')));
      }
    } finally {
      _isSendingMessage = false;
      _isTyping = false;
      notifyListeners();
    }
  }

  // Polling Methods
  void startPolling() {
    // Poll for notifications every 10 seconds
    _notificationTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      loadNotifications();
    });

    // Message polling is started when chat is opened
  }

  void startMessagePolling() {
    _messageTimer?.cancel();
    _messageTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      loadMessages();
    });
  }

  void stopMessagePolling() {
    _messageTimer?.cancel();
    _messageTimer = null;
  }

  // Utility Methods
  String formatMessageTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inDays == 0) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }

  // Modal Utility Methods
  Future<void> showConfirmationModal(
    BuildContext context,
    String message, [
    VoidCallback? onConfirm,
  ]) async {
    return showDialog(
      context: context,
      builder: (context) =>
          ConfirmationDialog(message: message, onConfirm: onConfirm),
    );
  }

  Future<void> showAlertModal(
    BuildContext context,
    String message,
    String type,
  ) async {
    AlertType alertType;
    switch (type) {
      case 'success':
        alertType = AlertType.success;
        break;
      case 'error':
        alertType = AlertType.error;
        break;
      case 'warning':
        alertType = AlertType.warning;
        break;
      default:
        alertType = AlertType.info;
    }

    return showDialog(
      context: context,
      builder: (context) =>
          AlertDialogWidget(message: message, type: alertType),
    );
  }

  Future<void> showNoticeModal(
    BuildContext context,
    String message,
    String type,
  ) async {
    NoticeType noticeType;
    switch (type) {
      case 'success':
        noticeType = NoticeType.success;
        break;
      case 'error':
        noticeType = NoticeType.error;
        break;
      case 'warning':
        noticeType = NoticeType.warning;
        break;
      default:
        noticeType = NoticeType.info;
    }

    return showDialog(
      context: context,
      builder: (context) => NoticeDialog(message: message, type: noticeType),
    );
  }

  // In UserDashboardViewModel class
  void clearAllNotifications(BuildContext context) {
    // Clear notifications locally
    _notifications.clear();
    _unreadNotificationCount = 0;
    notifyListeners();

    // Fixed: Check if context is still mounted before showing snackbar
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All notifications cleared'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    // Optional: Call API to clear notifications on server
    // _clearNotificationsOnServer();
  }

  // PDS Reminder Methods
  Future<void> _checkPdsReminder() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      const reminderShownKey = 'pdsReminderShown';
      final hasShownReminder = prefs.getBool(reminderShownKey) ?? false;

      debugPrint('PDS Reminder Debug: hasShownReminder = $hasShownReminder');

      // If reminder hasn't been shown in this session, show it
      if (!hasShownReminder) {
        debugPrint('PDS Reminder: Showing (first time in session)');
        // Show modal after a short delay to ensure page is fully loaded
        Timer(const Duration(seconds: 1), () {
          _showPdsReminder = true;
          notifyListeners();
        });
      } else {
        debugPrint('PDS Reminder: Not showing (already shown in session)');
      }
    } catch (e) {
      debugPrint('Error checking PDS reminder: $e');
    }
  }

  void dismissPdsReminder() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      const reminderShownKey = 'pdsReminderShown';
      await prefs.setBool(reminderShownKey, true);
      debugPrint('PDS Reminder: Marked as shown in session');
    } catch (e) {
      debugPrint('Error dismissing PDS reminder: $e');
    }

    _showPdsReminder = false;
    notifyListeners();
  }

  void navigateToProfileFromPdsReminder(BuildContext context) {
    dismissPdsReminder();
    navigateToProfile(context);
  }
}
