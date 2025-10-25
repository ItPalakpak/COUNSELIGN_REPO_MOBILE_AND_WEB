import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import '../../api/config.dart';
import '../../utils/session.dart';
import '../models/completed_appointment.dart';
import '../models/follow_up_session.dart';
import '../models/counselor_availability.dart';
import 'package:http/http.dart' as http;

class CounselorFollowUpSessionsViewModel extends ChangeNotifier {
  List<CompletedAppointment> _completedAppointments = [];
  List<CompletedAppointment> get completedAppointments =>
      _completedAppointments;

  List<CompletedAppointment> get pendingAppointments => _completedAppointments
      .where((appointment) => appointment.pendingFollowUpCount > 0)
      .toList();

  List<CompletedAppointment> get regularAppointments => _completedAppointments
      .where((appointment) => appointment.pendingFollowUpCount == 0)
      .toList();

  List<FollowUpSession> _followUpSessions = [];
  List<FollowUpSession> get followUpSessions => _followUpSessions;

  CounselorAvailability? _counselorAvailability;
  CounselorAvailability? get counselorAvailability => _counselorAvailability;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String _searchTerm = '';
  String get searchTerm => _searchTerm;

  int? _currentParentAppointmentId;
  int? get currentParentAppointmentId => _currentParentAppointmentId;

  String? _currentStudentId;
  String? get currentStudentId => _currentStudentId;

  Future<void> initialize() async {
    await loadCompletedAppointments();
  }

  Future<void> loadCompletedAppointments({String searchTerm = ''}) async {
    _setLoading(true);
    _error = null;
    _searchTerm = searchTerm;

    try {
      String url =
          '${ApiConfig.currentBaseUrl}/counselor/follow-up/completed-appointments';
      if (searchTerm.isNotEmpty) {
        url += '?search=${Uri.encodeComponent(searchTerm)}';
      }

      final response = await Session().get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          final appointments =
              (data['appointments'] as List<dynamic>?)?.map((json) {
                // Debug logging to help identify data issues
                debugPrint('Appointment JSON: $json');
                return CompletedAppointment.fromJson(json);
              }).toList() ??
              [];

          // Sort appointments according to backend logic:
          // 1. Pending follow-up count DESC (pending first)
          // 2. Next pending date ASC (earliest pending first)
          // 3. Preferred date DESC (most recent first)
          // 4. Preferred time DESC (latest time first)
          appointments.sort((a, b) {
            // First sort by pending follow-up count (DESC)
            if (a.pendingFollowUpCount != b.pendingFollowUpCount) {
              return b.pendingFollowUpCount.compareTo(a.pendingFollowUpCount);
            }

            // Then by next pending date (ASC) - nulls last
            if (a.nextPendingDate != null && b.nextPendingDate != null) {
              final dateComparison = a.nextPendingDate!.compareTo(
                b.nextPendingDate!,
              );
              if (dateComparison != 0) return dateComparison;
            } else if (a.nextPendingDate != null) {
              return -1; // a has pending date, b doesn't
            } else if (b.nextPendingDate != null) {
              return 1; // b has pending date, a doesn't
            }

            // Then by preferred date (DESC)
            final dateComparison = b.preferredDate.compareTo(a.preferredDate);
            if (dateComparison != 0) return dateComparison;

            // Finally by preferred time (DESC)
            return b.preferredTime.compareTo(a.preferredTime);
          });

          _completedAppointments = appointments;
        } else {
          _error = data['message'] ?? 'Failed to load completed appointments';
        }
      } else {
        _error =
            'Failed to load completed appointments: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error loading completed appointments: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadFollowUpSessions(int parentAppointmentId) async {
    _currentParentAppointmentId = parentAppointmentId;
    _error = null;

    try {
      final response = await Session().get(
        '${ApiConfig.currentBaseUrl}/counselor/follow-up/sessions?parent_appointment_id=$parentAppointmentId',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          _followUpSessions =
              (data['follow_up_sessions'] as List<dynamic>?)
                  ?.map((json) => FollowUpSession.fromJson(json))
                  .toList() ??
              [];
          notifyListeners();
        } else {
          _error = data['message'] ?? 'Failed to load follow-up sessions';
        }
      } else {
        _error = 'Failed to load follow-up sessions: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error loading follow-up sessions: $e';
    }
  }

  Future<void> loadCounselorAvailability(String date) async {
    try {
      final response = await Session().get(
        '${ApiConfig.currentBaseUrl}/counselor/follow-up/availability?date=$date',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          _counselorAvailability = CounselorAvailability.fromJson(data);
          notifyListeners();
        } else {
          _error = data['message'] ?? 'Failed to load counselor availability';
        }
      } else {
        _error =
            'Failed to load counselor availability: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error loading counselor availability: $e';
    }
  }

  Future<void> createFollowUp({
    required int parentAppointmentId,
    required String studentId,
    required String preferredDate,
    required String preferredTime,
    required String consultationType,
    String? description,
    String? reason,
  }) async {
    try {
      final formData = {
        'parent_appointment_id': parentAppointmentId.toString(),
        'student_id': studentId,
        'preferred_date': preferredDate,
        'preferred_time': preferredTime,
        'consultation_type': consultationType,
        if (description != null && description.isNotEmpty)
          'description': description,
        if (reason != null && reason.isNotEmpty) 'reason': reason,
      };

      final response = await Session().post(
        '${ApiConfig.currentBaseUrl}/counselor/follow-up/create',
        body: formData,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          // Reload follow-up sessions to reflect the change
          if (_currentParentAppointmentId != null) {
            await loadFollowUpSessions(_currentParentAppointmentId!);
          }
          notifyListeners();
        } else {
          throw Exception(
            data['message'] ?? 'Failed to create follow-up session',
          );
        }
      } else {
        throw Exception(
          'Failed to create follow-up session: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markSessionCompleted(int sessionId) async {
    try {
      final formData = {'id': sessionId.toString()};

      final response = await Session().post(
        '${ApiConfig.currentBaseUrl}/counselor/follow-up/complete',
        body: formData,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          // Reload follow-up sessions to reflect the change
          if (_currentParentAppointmentId != null) {
            await loadFollowUpSessions(_currentParentAppointmentId!);
          }
          notifyListeners();
        } else {
          throw Exception(
            data['message'] ?? 'Failed to mark session as completed',
          );
        }
      } else {
        throw Exception(
          'Failed to mark session as completed: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelFollowUp(int sessionId, String reason) async {
    try {
      final formData = {'id': sessionId.toString(), 'reason': reason};

      final response = await Session().post(
        '${ApiConfig.currentBaseUrl}/counselor/follow-up/cancel',
        body: formData,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          // Reload follow-up sessions to reflect the change
          if (_currentParentAppointmentId != null) {
            await loadFollowUpSessions(_currentParentAppointmentId!);
          }
          notifyListeners();
        } else {
          throw Exception(
            data['message'] ?? 'Failed to cancel follow-up session',
          );
        }
      } else {
        throw Exception(
          'Failed to cancel follow-up session: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  void setCurrentAppointment(int parentAppointmentId, String studentId) {
    _currentParentAppointmentId = parentAppointmentId;
    _currentStudentId = studentId;
  }

  bool canCreateNewFollowUp() {
    return _followUpSessions.isEmpty;
  }

  bool canCreateNextFollowUp() {
    if (_followUpSessions.isEmpty) return false;

    final lastSession = _followUpSessions.last;
    return lastSession.status == 'completed' ||
        lastSession.status == 'cancelled';
  }

  Future<void> refresh() async {
    await loadCompletedAppointments(searchTerm: _searchTerm);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
