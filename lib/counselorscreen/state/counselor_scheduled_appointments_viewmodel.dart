import 'package:flutter/material.dart';
import 'dart:convert';
import '../../api/config.dart';
import '../../utils/session.dart';
import '../models/scheduled_appointment.dart';
import '../models/counselor_schedule.dart';

class CounselorScheduledAppointmentsViewModel extends ChangeNotifier {
  final Session _session = Session();

  List<CounselorScheduledAppointment> _appointments = [];
  List<CounselorScheduledAppointment> get appointments => _appointments;

  List<CounselorSchedule> _counselorSchedule = [];
  List<CounselorSchedule> get counselorSchedule => _counselorSchedule;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> initialize() async {
    await Future.wait([loadAppointments(), loadCounselorSchedule()]);
  }

  Future<void> loadAppointments() async {
    _setLoading(true);
    _error = null;

    try {
      debugPrint(
        '🔍 Fetching scheduled appointments from: ${ApiConfig.currentBaseUrl}/counselor/appointments/scheduled/get',
      );

      final response = await _session.get(
        '${ApiConfig.currentBaseUrl}/counselor/appointments/scheduled/get',
        headers: ApiConfig.defaultHeaders,
      );

      debugPrint(
        'Scheduled Appointments API Response Status: ${response.statusCode}',
      );
      debugPrint('Scheduled Appointments API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          final appointmentsList = data['appointments'] as List<dynamic>? ?? [];
          _appointments = appointmentsList
              .map((json) => CounselorScheduledAppointment.fromJson(json))
              .toList();
        } else {
          _error = data['message'] ?? 'Failed to load appointments';
        }
      } else if (response.statusCode == 401) {
        _error = 'Session expired - Please log in again';
      } else {
        _error = 'Failed to load appointments: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error loading appointments: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadCounselorSchedule() async {
    try {
      debugPrint(
        '🔍 Fetching counselor schedule from: ${ApiConfig.currentBaseUrl}/counselor/appointments/schedule',
      );

      final response = await _session.get(
        '${ApiConfig.currentBaseUrl}/counselor/appointments/schedule',
        headers: ApiConfig.defaultHeaders,
      );

      debugPrint(
        'Counselor Schedule API Response Status: ${response.statusCode}',
      );
      debugPrint('Counselor Schedule API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          final scheduleList = data['schedule'] as List<dynamic>? ?? [];
          _counselorSchedule = scheduleList
              .map((json) => CounselorSchedule.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      // Schedule loading failure shouldn't block the main functionality
      debugPrint('Error loading counselor schedule: $e');
    }
  }

  Future<void> updateAppointmentStatus(
    String appointmentId,
    String status, {
    String? rejectionReason,
  }) async {
    try {
      debugPrint('🔍 Updating appointment status: $appointmentId to $status');

      // Prepare form data
      final formData = <String, String>{
        'appointment_id': appointmentId,
        'status': status,
        if (rejectionReason != null && rejectionReason.isNotEmpty)
          'rejection_reason': rejectionReason,
      };

      final response = await _session.post(
        '${ApiConfig.currentBaseUrl}/counselor/appointments/updateAppointmentStatus',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: formData.entries
            .map(
              (e) =>
                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
            )
            .join('&'),
      );

      debugPrint(
        'Update Appointment Status API Response Status: ${response.statusCode}',
      );
      debugPrint(
        'Update Appointment Status API Response Body: ${response.body}',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          // Reload appointments to reflect the change
          await loadAppointments();
        } else {
          throw Exception(
            data['message'] ?? 'Failed to update appointment status',
          );
        }
      } else {
        throw Exception(
          'Failed to update appointment status: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> refresh() async {
    await Future.wait([loadAppointments(), loadCounselorSchedule()]);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Get appointments for a specific date
  List<CounselorScheduledAppointment> getAppointmentsForDate(DateTime date) {
    return _appointments.where((appointment) {
      if (appointment.effectiveDate == null) return false;
      try {
        final appointmentDate = DateTime.parse(appointment.effectiveDate!);
        return appointmentDate.year == date.year &&
            appointmentDate.month == date.month &&
            appointmentDate.day == date.day;
      } catch (e) {
        return false;
      }
    }).toList();
  }

  // Get appointment count for a specific date
  int getAppointmentCountForDate(DateTime date) {
    return getAppointmentsForDate(date).length;
  }

  // Check if a date has appointments
  bool hasAppointmentsOnDate(DateTime date) {
    return getAppointmentCountForDate(date) > 0;
  }
}
