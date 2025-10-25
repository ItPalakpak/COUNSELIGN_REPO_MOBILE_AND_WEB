import 'package:flutter/material.dart';
import '../../routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../api/config.dart';
import '../../utils/session.dart';
import '../models/appointment.dart';
import '../models/counselor_availability.dart';
import '../models/counselor_schedule.dart';

class MyAppointmentsViewModel extends ChangeNotifier {
  final Session _session = Session();

  // Appointments data
  List<Appointment> _allAppointments = [];
  List<Appointment> get allAppointments => _allAppointments;

  List<Counselor> _counselors = [];
  List<Counselor> get counselors => _counselors;

  // Loading states
  bool _isLoadingAppointments = true;
  bool get isLoadingAppointments => _isLoadingAppointments;

  bool _isLoadingCounselors = false;
  bool get isLoadingCounselors => _isLoadingCounselors;

  bool _isUpdatingAppointment = false;
  bool get isUpdatingAppointment => _isUpdatingAppointment;

  bool _isCancellingAppointment = false;
  bool get isCancellingAppointment => _isCancellingAppointment;

  bool _isDeletingAppointment = false;
  bool get isDeletingAppointment => _isDeletingAppointment;

  // Filter states
  String _searchTerm = '';
  String get searchTerm => _searchTerm;

  String _dateFilter = '';
  String get dateFilter => _dateFilter;

  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  // Calendar state
  bool _isCalendarVisible = false;
  bool get isCalendarVisible => _isCalendarVisible;

  DateTime _currentCalendarDate = DateTime.now();
  DateTime get currentCalendarDate => _currentCalendarDate;

  // Modal states
  bool _showEditModal = false;
  bool get showEditModal => _showEditModal;

  bool _showCancelModal = false;
  bool get showCancelModal => _showCancelModal;

  bool _showSaveChangesModal = false;
  bool get showSaveChangesModal => _showSaveChangesModal;

  bool _showCancellationReasonModal = false;
  bool get showCancellationReasonModal => _showCancellationReasonModal;

  bool _showDeleteModal = false;
  bool get showDeleteModal => _showDeleteModal;

  // Current appointment being edited
  Appointment? _currentAppointment;
  Appointment? get currentAppointment => _currentAppointment;

  // Form controllers
  final TextEditingController searchController = TextEditingController();
  final TextEditingController dateFilterController = TextEditingController();
  final TextEditingController editDateController = TextEditingController();
  final TextEditingController editTimeController = TextEditingController();
  final TextEditingController editConsultationTypeController =
      TextEditingController();
  final TextEditingController editDescriptionController =
      TextEditingController();
  final TextEditingController cancelReasonController = TextEditingController();
  final TextEditingController cancellationReasonController =
      TextEditingController();

  // Pending appointment editing
  final Map<int, bool> _editingStates = {};
  final Map<String, TextEditingController> _pendingControllers = {};

  void initialize() {
    fetchAppointments();
    fetchCounselors();
  }

  @override
  void dispose() {
    searchController.dispose();
    dateFilterController.dispose();
    editDateController.dispose();
    editTimeController.dispose();
    editConsultationTypeController.dispose();
    editDescriptionController.dispose();
    cancelReasonController.dispose();
    cancellationReasonController.dispose();
    for (var controller in _pendingControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // Fetch appointments
  Future<void> fetchAppointments() async {
    try {
      _isLoadingAppointments = true;
      notifyListeners();

      final url =
          '${ApiConfig.currentBaseUrl}/student/appointments/get-my-appointments';
      debugPrint('Fetching appointments from: $url');

      final response = await _session.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('Parsed data: $data');

        if (data['success'] == true) {
          _allAppointments =
              (data['appointments'] as List?)
                  ?.map((a) => Appointment.fromJson(a))
                  .toList() ??
              [];
          debugPrint('Loaded ${_allAppointments.length} appointments');
        } else {
          debugPrint(
            'API returned success: false, message: ${data['message']}',
          );
        }
      } else {
        debugPrint('HTTP error: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error fetching appointments: $e');
    } finally {
      _isLoadingAppointments = false;
      notifyListeners();
    }
  }

  // Fetch counselors
  Future<void> fetchCounselors() async {
    if (_counselors.isNotEmpty) return;

    try {
      _isLoadingCounselors = true;
      notifyListeners();

      final url = '${ApiConfig.currentBaseUrl}/student/get-counselors';
      debugPrint('Fetching counselors from: $url');

      final response = await _session.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
      );

      debugPrint('Counselors response status: ${response.statusCode}');
      debugPrint('Counselors response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          _counselors =
              (data['counselors'] as List?)
                  ?.map((c) => Counselor.fromJson(c))
                  .toList() ??
              [];
          debugPrint('Loaded ${_counselors.length} counselors');
        } else {
          debugPrint(
            'Counselors API returned status: ${data['status']}, message: ${data['message']}',
          );
        }
      } else {
        debugPrint('Counselors HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching counselors: $e');
    } finally {
      _isLoadingCounselors = false;
      notifyListeners();
    }
  }

  // Fetch counselors by availability for specific date and time
  Future<void> fetchCounselorsByAvailability(String date, String time) async {
    try {
      _isLoadingCounselors = true;
      notifyListeners();

      final dayOfWeek = _getDayOfWeek(date);
      final timeBounds = _extractTimeBounds(time);

      final uri =
          Uri.parse(
            '${ApiConfig.currentBaseUrl}/student/get-counselors-by-availability',
          ).replace(
            queryParameters: {
              'date': date,
              'day': dayOfWeek,
              'time': time,
              if (timeBounds != null) ...{
                'from': timeBounds['start'],
                'to': timeBounds['end'],
                'timeMode': 'overlap',
              },
            },
          );

      final response = await _session.get(
        uri.toString(),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          _counselors =
              (data['counselors'] as List?)
                  ?.map((c) => Counselor.fromJson(c))
                  .toList() ??
              [];
          debugPrint(
            'Found ${_counselors.length} available counselors for $date $time',
          );
        } else {
          debugPrint(
            'Error fetching counselors by availability: ${data['message']}',
          );
        }
      } else {
        debugPrint(
          'Error fetching counselors by availability: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Error fetching counselors by availability: $e');
    } finally {
      _isLoadingCounselors = false;
      notifyListeners();
    }
  }

  // Extract time bounds from time string (e.g., "8:00 AM - 9:00 AM")
  Map<String, String>? _extractTimeBounds(String timeString) {
    if (timeString.isEmpty) return null;

    final parts = timeString.split(' - ');
    if (parts.length != 2) return null;

    final start = _convertTo24Hour(parts[0].trim());
    final end = _convertTo24Hour(parts[1].trim());

    if (start == null || end == null) return null;

    return {'start': start, 'end': end};
  }

  // Convert 12-hour time to 24-hour format
  String? _convertTo24Hour(String time12) {
    final regex = RegExp(
      r'^(\d{1,2}):(\d{2})\s*(AM|PM)$',
      caseSensitive: false,
    );
    final match = regex.firstMatch(time12);

    if (match == null) return null;

    final hour = int.parse(match.group(1)!);
    final minute = match.group(2)!;
    final period = match.group(3)!.toUpperCase();

    int hour24 = hour;
    if (period == 'AM' && hour == 12) {
      hour24 = 0;
    } else if (period == 'PM' && hour != 12) {
      hour24 = hour + 12;
    }

    return '${hour24.toString().padLeft(2, '0')}:$minute';
  }

  // Filter appointments
  void updateSearchTerm(String term) {
    _searchTerm = term;
    notifyListeners();
  }

  void updateDateFilter(String date) {
    _dateFilter = date;
    notifyListeners();
  }

  void updateSelectedTab(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  List<Appointment> getFilteredAppointments() {
    List<Appointment> filtered = _allAppointments;

    // Apply search filter
    if (_searchTerm.isNotEmpty) {
      filtered = filtered.where((appointment) {
        return appointment.consultationType?.toLowerCase().contains(
                  _searchTerm.toLowerCase(),
                ) ==
                true ||
            appointment.counselorName?.toLowerCase().contains(
                  _searchTerm.toLowerCase(),
                ) ==
                true ||
            appointment.description?.toLowerCase().contains(
                  _searchTerm.toLowerCase(),
                ) ==
                true;
      }).toList();
    }

    // Apply date filter
    if (_dateFilter.isNotEmpty) {
      filtered = filtered.where((appointment) {
        return appointment.preferredDate?.startsWith(_dateFilter) == true;
      }).toList();
    }

    // Apply status filter based on selected tab
    switch (_selectedTabIndex) {
      case 1: // Completed
        filtered = filtered
            .where((a) => a.status?.toUpperCase() == 'COMPLETED')
            .toList();
        break;
      case 2: // Cancelled
        filtered = filtered
            .where((a) => a.status?.toUpperCase() == 'CANCELLED')
            .toList();
        break;
      case 3: // Rejected
        filtered = filtered
            .where((a) => a.status?.toUpperCase() == 'REJECTED')
            .toList();
        break;
      default: // All
        break;
    }

    return filtered;
  }

  List<Appointment> getPendingAppointments() {
    return _allAppointments
        .where((a) => a.status?.toUpperCase() == 'PENDING')
        .toList();
  }

  List<Appointment> getApprovedAppointments() {
    return _allAppointments
        .where((a) => a.status?.toUpperCase() == 'APPROVED')
        .toList();
  }

  // Calendar functionality
  void toggleCalendar() {
    _isCalendarVisible = !_isCalendarVisible;
    notifyListeners();
  }

  void setCalendarDate(DateTime date) {
    _currentCalendarDate = date;
    notifyListeners();
  }

  // Fetch counselor availability for calendar date
  Future<List<CounselorAvailability>> fetchCounselorAvailabilityForDate(
    DateTime date,
  ) async {
    try {
      final formattedDate =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final dayOfWeek = _getDayOfWeek(formattedDate);

      // First, get available counselors for the date
      final uri =
          Uri.parse(
            '${ApiConfig.currentBaseUrl}/student/get-counselors-by-availability',
          ).replace(
            queryParameters: {
              'date': formattedDate,
              'day': dayOfWeek,
              'time': '00:00-23:59',
              'from': '00:00',
              'to': '23:59',
              'timeMode': 'overlap',
            },
          );

      final response = await _session.get(
        uri.toString(),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('Counselor availability response: $data');
        if (data['status'] == 'success') {
          final counselors = (data['counselors'] as List?) ?? [];
          debugPrint(
            'Found ${counselors.length} counselors for date: $formattedDate',
          );

          // Now fetch individual counselor availability with schedule
          final counselorsWithSchedule = <CounselorAvailability>[];

          for (var counselor in counselors) {
            try {
              // Fetch individual counselor availability using the counselor availability endpoint
              final counselorId = counselor['counselor_id'] ?? counselor['id'];
              if (counselorId != null) {
                final availabilityUri =
                    Uri.parse(
                      '${ApiConfig.currentBaseUrl}/counselor/profile/availability',
                    ).replace(
                      queryParameters: {'counselorId': counselorId.toString()},
                    );

                final availabilityResponse = await _session.get(
                  availabilityUri.toString(),
                  headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest',
                  },
                );

                if (availabilityResponse.statusCode == 200) {
                  final availabilityData = json.decode(
                    availabilityResponse.body,
                  );
                  debugPrint(
                    'Counselor $counselorId availability: $availabilityData',
                  );

                  if (availabilityData['success'] == true &&
                      availabilityData['availability'] != null) {
                    final availability = availabilityData['availability'];
                    final dayAvailability = availability[dayOfWeek] ?? [];

                    // Extract time_scheduled from the day's availability
                    String? timeSchedule;
                    if (dayAvailability.isNotEmpty) {
                      final timeSlots = dayAvailability
                          .map((slot) => slot['time_scheduled'])
                          .where(
                            (time) =>
                                time != null && time.toString().isNotEmpty,
                          )
                          .toList();

                      if (timeSlots.isNotEmpty) {
                        timeSchedule = timeSlots.join(', ');
                      }
                    }

                    final counselorWithSchedule = CounselorAvailability(
                      counselorId: counselorId.toString(),
                      name: counselor['name'] ?? '',
                      specialization:
                          counselor['specialization'] ?? 'General Counseling',
                      timeSchedule: timeSchedule,
                    );

                    counselorsWithSchedule.add(counselorWithSchedule);
                  }
                }
              }
            } catch (e) {
              debugPrint(
                'Error fetching availability for counselor ${counselor['name']}: $e',
              );
            }
          }

          return counselorsWithSchedule;
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching counselor availability for date: $e');
      return [];
    }
  }

  String _getDayOfWeek(String dateString) {
    final date = DateTime.parse(dateString);
    const days = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    return days[date.weekday % 7];
  }

  // Fetch counselor schedules organized by weekday
  Future<Map<String, List<CounselorSchedule>>> fetchCounselorSchedules() async {
    try {
      final response = await _session.get(
        '${ApiConfig.currentBaseUrl}/student/get-counselor-schedules',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('Counselor schedules response: $data');

        if (data['status'] == 'success' && data['schedules'] != null) {
          final schedules = <String, List<CounselorSchedule>>{};
          final schedulesData = data['schedules'] as Map<String, dynamic>;

          // Process each weekday
          for (final entry in schedulesData.entries) {
            final day = entry.key;
            final daySchedules =
                (entry.value as List?)
                    ?.map((schedule) => CounselorSchedule.fromJson(schedule))
                    .toList() ??
                [];
            schedules[day] = daySchedules;
          }

          debugPrint('Loaded counselor schedules for ${schedules.length} days');
          return schedules;
        } else {
          debugPrint('API returned error: ${data['message']}');
        }
      } else {
        debugPrint('HTTP error: ${response.statusCode}');
      }
      return {};
    } catch (e) {
      debugPrint('Error fetching counselor schedules: $e');
      return {};
    }
  }

  // Modal management
  void openEditModal(Appointment appointment) {
    _currentAppointment = appointment;
    editDateController.text = appointment.preferredDate ?? '';
    editTimeController.text = appointment.preferredTime ?? '';
    editConsultationTypeController.text = appointment.consultationType ?? '';
    editDescriptionController.text = appointment.description ?? '';
    _showEditModal = true;
    notifyListeners();
  }

  void closeEditModal() {
    _showEditModal = false;
    _currentAppointment = null;
    notifyListeners();
  }

  void openCancelModal(Appointment appointment) {
    _currentAppointment = appointment;
    cancelReasonController.clear();
    _showCancelModal = true;
    notifyListeners();
  }

  void closeCancelModal() {
    _showCancelModal = false;
    _currentAppointment = null;
    notifyListeners();
  }

  void openSaveChangesModal() {
    _showSaveChangesModal = true;
    notifyListeners();
  }

  void closeSaveChangesModal() {
    _showSaveChangesModal = false;
    notifyListeners();
  }

  void openCancellationReasonModal() {
    _showCancellationReasonModal = true;
    notifyListeners();
  }

  void closeCancellationReasonModal() {
    _showCancellationReasonModal = false;
    notifyListeners();
  }

  void openDeleteModal(Appointment appointment) {
    _currentAppointment = appointment;
    _showDeleteModal = true;
    notifyListeners();
  }

  void closeDeleteModal() {
    _showDeleteModal = false;
    _currentAppointment = null;
    notifyListeners();
  }

  // Pending appointment editing
  bool isEditing(int appointmentId) {
    return _editingStates[appointmentId] ?? false;
  }

  void toggleEditing(int appointmentId) {
    _editingStates[appointmentId] = !(_editingStates[appointmentId] ?? false);
    notifyListeners();
  }

  TextEditingController getPendingController(
    int appointmentId,
    String field,
    String initialValue,
  ) {
    final key = '${appointmentId}_$field';
    if (!_pendingControllers.containsKey(key)) {
      _pendingControllers[key] = TextEditingController(text: initialValue);
    }
    return _pendingControllers[key]!;
  }

  // Handle date and time changes for pending appointments
  void onPendingDateChanged(int appointmentId, String date) {
    final timeController = getPendingController(
      appointmentId,
      'preferred_time',
      '',
    );
    if (timeController.text.isNotEmpty) {
      fetchCounselorsByAvailability(date, timeController.text);
    }
  }

  void onPendingTimeChanged(int appointmentId, String time) {
    final dateController = getPendingController(
      appointmentId,
      'preferred_date',
      '',
    );
    if (dateController.text.isNotEmpty) {
      fetchCounselorsByAvailability(dateController.text, time);
    }
  }

  // API operations
  Future<bool> updateAppointment(BuildContext context) async {
    if (_currentAppointment == null) return false;

    try {
      _isUpdatingAppointment = true;
      notifyListeners();

      final formData = {
        'appointment_id': _currentAppointment!.id.toString(),
        'preferred_date': editDateController.text,
        'preferred_time': editTimeController.text,
        'consultation_type': editConsultationTypeController.text,
        'description': editDescriptionController.text,
      };

      final response = await _session.post(
        '${ApiConfig.currentBaseUrl}/student/appointments/update',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
        body: formData,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          closeEditModal();
          await fetchAppointments();
          if (context.mounted) {
            _showSnackBar(context, 'Appointment updated successfully');
          }
          return true;
        } else {
          if (context.mounted) {
            _showSnackBar(
              context,
              data['message'] ?? 'Failed to update appointment',
            );
          }
          return false;
        }
      }
    } catch (e) {
      debugPrint('Error updating appointment: $e');
      if (context.mounted) {
        _showSnackBar(
          context,
          'Failed to update appointment. Please try again later.',
        );
      }
      return false;
    } finally {
      _isUpdatingAppointment = false;
      notifyListeners();
    }
    return false;
  }

  Future<bool> updatePendingAppointment(
    BuildContext context,
    int appointmentId,
    Map<String, dynamic> formData,
  ) async {
    try {
      _isUpdatingAppointment = true;
      notifyListeners();

      final data = {
        'appointment_id': appointmentId.toString(),
        ...formData,
        'status': 'pending',
      };

      final response = await _session.post(
        '${ApiConfig.currentBaseUrl}/student/appointments/update',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          await fetchAppointments();
          return true;
        } else {
          debugPrint('Update failed: ${responseData['message']}');
          return false;
        }
      } else {
        debugPrint('Update failed with status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('Error updating pending appointment: $e');
      return false;
    } finally {
      _isUpdatingAppointment = false;
      notifyListeners();
    }
  }

  Future<bool> cancelAppointment(
    BuildContext context,
    int appointmentId,
    String reason,
  ) async {
    try {
      debugPrint(
        'Starting cancellation for appointment $appointmentId with reason: $reason',
      );
      _isCancellingAppointment = true;
      notifyListeners();

      final formData = {
        'appointment_id': appointmentId.toString(),
        'reason': reason,
      };

      debugPrint('Sending cancellation request with data: $formData');

      final response = await _session.post(
        '${ApiConfig.currentBaseUrl}/student/appointments/cancel',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
        body: json.encode(formData),
      );

      debugPrint('Cancellation response status: ${response.statusCode}');
      debugPrint('Cancellation response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          await fetchAppointments();
          return true;
        } else {
          debugPrint('Cancellation failed: ${data['message']}');
          return false;
        }
      } else {
        debugPrint(
          'Cancellation failed with status code: ${response.statusCode}',
        );
        return false;
      }
    } catch (e) {
      debugPrint('Error cancelling appointment: $e');
      return false;
    } finally {
      _isCancellingAppointment = false;
      notifyListeners();
    }
  }

  Future<bool> deleteAppointment(
    BuildContext context,
    int appointmentId,
  ) async {
    try {
      _isDeletingAppointment = true;
      notifyListeners();

      // Use regular http.delete with session cookies
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      };

      // Add session cookies if available
      if (_session.cookies.isNotEmpty) {
        final cookieString = _session.cookies.entries
            .map((entry) => '${entry.key}=${entry.value}')
            .join('; ');
        headers['Cookie'] = cookieString;
      }

      final response = await http.delete(
        Uri.parse(
          '${ApiConfig.currentBaseUrl}/student/appointments/delete/$appointmentId',
        ),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          closeDeleteModal();
          await fetchAppointments();
          if (context.mounted) {
            _showSnackBar(context, 'Appointment deleted successfully');
          }
          return true;
        } else {
          if (context.mounted) {
            _showSnackBar(
              context,
              data['message'] ?? 'Failed to delete appointment',
            );
          }
          return false;
        }
      }
    } catch (e) {
      debugPrint('Error deleting appointment: $e');
      if (context.mounted) {
        _showSnackBar(
          context,
          'Failed to delete appointment. Please try again later.',
        );
      }
      return false;
    } finally {
      _isDeletingAppointment = false;
      notifyListeners();
    }
    return false;
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // Navigation
  void navigateToScheduleAppointment(BuildContext context) {
    Navigator.of(context).pushNamed('/user/schedule-appointment');
  }

  void navigateToDashboard(BuildContext context) {
    AppRoutes.navigateToDashboard(context);
  }
}
