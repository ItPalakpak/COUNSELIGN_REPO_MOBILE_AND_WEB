import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../api/config.dart';
import '../models/admin_profile.dart';
import '../models/message.dart';
import '../models/appointment.dart';

class AdminDashboardViewModel extends ChangeNotifier {
  // Admin profile data
  AdminProfile? _adminProfile;
  AdminProfile? get adminProfile => _adminProfile;

  String? _lastLogin;
  String? get lastLogin => _lastLogin;

  // Loading states
  bool _isLoadingProfile = true;
  bool get isLoadingProfile => _isLoadingProfile;

  bool _isLoadingMessages = true;
  bool get isLoadingMessages => _isLoadingMessages;

  bool _isLoadingAppointments = true;
  bool get isLoadingAppointments => _isLoadingAppointments;

  // Data
  List<Message> _messages = [];
  List<Message> get messages => _messages;

  List<Appointment> _appointments = [];
  List<Appointment> get appointments => _appointments;

  int _unreadMessagesCount = 0;
  int get unreadMessagesCount => _unreadMessagesCount;

  void initialize() {
    fetchAdminProfile();
    fetchMessages();
    fetchAppointments();
  }

  // Fetch admin profile
  Future<void> fetchAdminProfile() async {
    try {
      _isLoadingProfile = true;
      notifyListeners();

      final response = await http.get(
        Uri.parse('${ApiConfig.currentBaseUrl}/admin/profile/get'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          _adminProfile = AdminProfile.fromJson(data['admin']);
          _lastLogin = data['last_login'] ?? 'Unknown';
        }
      }
    } catch (e) {
      debugPrint('Error fetching admin profile: $e');
    } finally {
      _isLoadingProfile = false;
      notifyListeners();
    }
  }

  // Fetch messages
  Future<void> fetchMessages() async {
    try {
      _isLoadingMessages = true;
      notifyListeners();

      final response = await http.get(
        Uri.parse('${ApiConfig.currentBaseUrl}/admin/messages/get'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          _messages = (data['messages'] as List?)
              ?.map((m) => Message.fromJson(m))
              .toList() ?? [];
          _unreadMessagesCount = _messages.where((m) => !m.isRead).length;
        }
      }
    } catch (e) {
      debugPrint('Error fetching messages: $e');
    } finally {
      _isLoadingMessages = false;
      notifyListeners();
    }
  }

  // Fetch appointments
  Future<void> fetchAppointments() async {
    try {
      _isLoadingAppointments = true;
      notifyListeners();

      final response = await http.get(
        Uri.parse('${ApiConfig.currentBaseUrl}/admin/appointments/get'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          _appointments = (data['appointments'] as List?)
              ?.map((a) => Appointment.fromJson(a))
              .toList() ?? [];
        }
      }
    } catch (e) {
      debugPrint('Error fetching appointments: $e');
    } finally {
      _isLoadingAppointments = false;
      notifyListeners();
    }
  }

  // Mark message as read
  Future<bool> markMessageAsRead(int messageId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.currentBaseUrl}/admin/messages/mark-read'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'message_id': messageId.toString()},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final messageIndex = _messages.indexWhere((m) => m.id == messageId);
          if (messageIndex != -1) {
            _messages[messageIndex] = _messages[messageIndex].copyWith(isRead: true);
            _unreadMessagesCount = _messages.where((m) => !m.isRead).length;
            notifyListeners();
          }
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error marking message as read: $e');
      return false;
    }
  }

  // Get recent messages (limit to 2 for dashboard)
  List<Message> getRecentMessages() {
    return _messages.take(2).toList();
  }

  // Get recent appointments (limit to 2 for dashboard)
  List<Appointment> getRecentAppointments() {
    return _appointments.take(2).toList();
  }
}