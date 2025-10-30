import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../api/config.dart';
import '../../utils/session.dart';
import '../models/appointment.dart';
import '../models/follow_up_appointment.dart';
import '../models/counselor_availability.dart';
import '../models/counselor_schedule.dart';

class ScheduleAppointmentViewModel extends ChangeNotifier {
  final Session _session = Session();
  bool _disposed = false;

  // Form controllers
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController consultationTypeController =
      TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController counselorController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Loading states
  bool _isLoadingCounselors = false;
  bool get isLoadingCounselors => _isLoadingCounselors;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  bool _isCheckingPending = false;
  bool get isCheckingPending => _isCheckingPending;

  // Data
  List<Counselor> _counselors = [];
  List<Counselor> get counselors => _counselors;

  bool _hasPendingAppointment = false;
  bool get hasPendingAppointment => _hasPendingAppointment;

  bool _hasApprovedAppointment = false;
  bool get hasApprovedAppointment => _hasApprovedAppointment;

  bool _hasPendingFollowUp = false;
  bool get hasPendingFollowUp => _hasPendingFollowUp;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool _hasLoginError = false;
  bool get hasLoginError => _hasLoginError;

  String? _pendingAppointmentMessage;
  String? get pendingAppointmentMessage => _pendingAppointmentMessage;

  // Calendar state
  bool _isCalendarVisible = false;
  bool get isCalendarVisible => _isCalendarVisible;

  DateTime _currentCalendarDate = DateTime.now();
  DateTime get currentCalendarDate => _currentCalendarDate;

  // Form validation
  String? _dateError;
  String? get dateError => _dateError;

  String? _timeError;
  String? get timeError => _timeError;

  String? _consultationTypeError;
  String? get consultationTypeError => _consultationTypeError;

  String? _purposeError;
  String? get purposeError => _purposeError;

  String? _counselorError;
  String? get counselorError => _counselorError;

  // Consent validation
  bool _consentRead = false;
  bool get consentRead => _consentRead;

  bool _consentAccept = false;
  bool get consentAccept => _consentAccept;

  bool _showConsentError = false;
  bool get showConsentError => _showConsentError;

  // Message display
  String? _message;
  String? get message => _message;

  bool _isMessageError = false;
  bool get isMessageError => _isMessageError;

  void initialize() {
    _setMinimumDate();
    // Run eligibility check immediately and wait for it to complete
    checkAppointmentEligibility();
  }

  @override
  void dispose() {
    _disposed = true;
    dateController.dispose();
    timeController.dispose();
    consultationTypeController.dispose();
    purposeController.dispose();
    counselorController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  void _setMinimumDate() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final formattedDate =
        '${tomorrow.year}-${tomorrow.month.toString().padLeft(2, '0')}-${tomorrow.day.toString().padLeft(2, '0')}';
    dateController.text = formattedDate;
    _safeNotifyListeners();
  }

  // Check appointment eligibility (pending, approved, pending follow-up)
  Future<void> checkAppointmentEligibility() async {
    try {
      _isCheckingPending = true;
      _safeNotifyListeners();

      final response = await _session.get(
        '${ApiConfig.currentBaseUrl}/student/check-appointment-eligibility',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('Eligibility check response: $data');
        if (data['status'] == 'success') {
          _isLoggedIn = true;
          _hasLoginError = false; // Clear login error when successful
          _hasPendingAppointment = data['hasPending'] ?? false;
          _hasApprovedAppointment = data['hasApproved'] ?? false;
          _hasPendingFollowUp = data['hasPendingFollowUp'] ?? false;
          debugPrint(
            'Appointment status - Pending: $_hasPendingAppointment, Approved: $_hasApprovedAppointment, Follow-up: $_hasPendingFollowUp',
          );
          debugPrint(
            'Login status: $_isLoggedIn, Login error: $_hasLoginError',
          );
          debugPrint('Current message: $_message');
          debugPrint(
            'Pending appointment message: $_pendingAppointmentMessage',
          );

          // Set appropriate message based on priority - only show appointment-specific messages
          if (_hasPendingFollowUp) {
            _pendingAppointmentMessage =
                'You have a pending follow-up session. Please complete or resolve it before scheduling a new appointment.';
            _message = _pendingAppointmentMessage;
            _isMessageError = true;
          } else if (_hasPendingAppointment) {
            _pendingAppointmentMessage =
                'You already have a pending appointment. Please wait for it to be approved before scheduling another one.';
            _message = _pendingAppointmentMessage;
            _isMessageError = true;
          } else if (_hasApprovedAppointment) {
            _pendingAppointmentMessage =
                'You already have an approved upcoming appointment. You cannot schedule another at this time.';
            _message = _pendingAppointmentMessage;
            _isMessageError = true;
          } else {
            // Clear any previous messages if user is eligible
            _message = null;
            _isMessageError = false;
          }

          // Only fetch counselors if eligible to book
          if (!_hasPendingAppointment &&
              !_hasApprovedAppointment &&
              !_hasPendingFollowUp) {
            await fetchCounselors();
          }
        } else {
          // If API returns error, show login message and disable form
          _isLoggedIn = false;
          _hasLoginError = true;
          _message =
              data['message'] ??
              'You must be logged in to schedule an appointment.';
          _isMessageError = true;
          // Don't set appointment flags for login errors
        }
      } else if (response.statusCode == 401) {
        _isLoggedIn = false;
        _hasLoginError = true;
        _message = 'You must be logged in to schedule an appointment.';
        _isMessageError = true;
        // Don't set appointment flags for login errors
      } else {
        _isLoggedIn = false;
        _hasLoginError = true;
        _message = 'Error checking appointment eligibility. Please try again.';
        _isMessageError = true;
        // Don't set appointment flags for errors
      }
    } catch (e) {
      debugPrint('Error checking appointment eligibility: $e');
      _isLoggedIn = false;
      _hasLoginError = true;
      _message = 'Error checking appointment eligibility. Please try again.';
      _isMessageError = true;
      // Don't set appointment flags for errors
    } finally {
      _isCheckingPending = false;
      _safeNotifyListeners();
    }
  }

  // Fetch counselors
  Future<void> fetchCounselors() async {
    try {
      _isLoadingCounselors = true;
      _safeNotifyListeners();

      final response = await _session.get(
        '${ApiConfig.currentBaseUrl}/student/get-counselors',
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
        } else {
          debugPrint('Error fetching counselors: ${data['message']}');
        }
      } else {
        debugPrint('Error fetching counselors: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching counselors: $e');
    } finally {
      _isLoadingCounselors = false;
      _safeNotifyListeners();
    }
  }

  // Fetch counselors by availability for specific date and time
  Future<void> fetchCounselorsByAvailability(String date, String time) async {
    try {
      _isLoadingCounselors = true;
      _safeNotifyListeners();

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
      _safeNotifyListeners();
    }
  }

  // Get day of week from date string
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

    int hour = int.parse(match.group(1)!);
    final minute = match.group(2)!;
    final period = match.group(3)!.toUpperCase();

    if (period == 'AM') {
      if (hour == 12) hour = 0;
    } else {
      if (hour != 12) hour += 12;
    }

    return '${hour.toString().padLeft(2, '0')}:$minute';
  }

  // Consent validation methods
  void setConsentRead(bool value) {
    _consentRead = value;
    _updateConsentError();
    _safeNotifyListeners();
  }

  void setConsentAccept(bool value) {
    _consentAccept = value;
    _updateConsentError();
    _safeNotifyListeners();
  }

  void _updateConsentError() {
    _showConsentError = !_consentRead || !_consentAccept;
  }

  bool _validateConsent() {
    return _consentRead && _consentAccept;
  }

  // Form validation
  bool validateForm() {
    bool isValid = true;

    // Reset errors
    _dateError = null;
    _timeError = null;
    _consultationTypeError = null;
    _purposeError = null;
    _counselorError = null;

    // Validate date
    if (dateController.text.isEmpty) {
      _dateError = 'Please select a preferred date.';
      isValid = false;
    } else {
      final selectedDate = DateTime.tryParse(dateController.text);
      final today = DateTime.now();
      today.subtract(
        Duration(
          hours: today.hour,
          minutes: today.minute,
          seconds: today.second,
          milliseconds: today.millisecond,
          microseconds: today.microsecond,
        ),
      );

      if (selectedDate != null &&
          selectedDate.isBefore(today.add(const Duration(days: 1)))) {
        _dateError = 'Please select a future date for your appointment.';
        isValid = false;
      }
    }

    // Validate time
    if (timeController.text.isEmpty) {
      _timeError = 'Please select a preferred time.';
      isValid = false;
    }

    // Validate consultation type
    if (consultationTypeController.text.isEmpty) {
      _consultationTypeError = 'Please select a consultation type.';
      isValid = false;
    }

    // Validate purpose
    if (purposeController.text.isEmpty) {
      _purposeError = 'Please select the purpose of your consultation.';
      isValid = false;
    }

    // Validate consent
    if (!_validateConsent()) {
      _showConsentError = true;
      isValid = false;
    } else {
      _showConsentError = false;
    }

    _safeNotifyListeners();
    return isValid;
  }

  // Submit appointment
  Future<bool> submitAppointment(BuildContext context) async {
    if (!validateForm()) return false;

    try {
      _isSubmitting = true;
      _message = null;
      _safeNotifyListeners();

      final formData = {
        'preferredDate': dateController.text,
        'preferredTime': timeController.text,
        'consultationType': consultationTypeController.text,
        'purpose': purposeController.text,
        'counselorPreference': counselorController.text.isEmpty
            ? 'No preference'
            : counselorController.text,
        'description': descriptionController.text,
        'consentRead': _consentRead ? '1' : '0',
        'consentAccept': _consentAccept ? '1' : '0',
      };

      final response = await _session.post(
        '${ApiConfig.currentBaseUrl}/student/appointment/save',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
        body: formData,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          _message = data['message'] ?? 'Appointment scheduled successfully!';
          _isMessageError = false;

          // Show confirmation dialog
          // ignore: use_build_context_synchronously
          if (context.mounted) {
            _showConfirmationDialog(context);
          }

          // Reset form
          _resetForm();

          return true;
        } else {
          _message = data['message'] ?? 'Failed to schedule appointment.';
          _isMessageError = true;
          return false;
        }
      } else {
        final data = json.decode(response.body);
        _message = data['message'] ?? 'Failed to schedule appointment.';
        _isMessageError = true;
        return false;
      }
    } catch (e) {
      debugPrint('Error submitting appointment: $e');
      _message = 'A server error occurred. Please try again later.';
      _isMessageError = true;
      return false;
    } finally {
      _isSubmitting = false;
      _safeNotifyListeners();
    }
  }

  void _resetForm() {
    _setMinimumDate();
    timeController.clear();
    consultationTypeController.clear();
    purposeController.clear();
    counselorController.clear();
    descriptionController.clear();
    _consentRead = false;
    _consentAccept = false;
    _showConsentError = false;
  }

  // Calendar functionality
  void toggleCalendar() {
    _isCalendarVisible = !_isCalendarVisible;
    debugPrint('Calendar visibility toggled to: $_isCalendarVisible');
    debugPrint(
      'Current appointment status - Pending: $_hasPendingAppointment, Approved: $_hasApprovedAppointment, Follow-up: $_hasPendingFollowUp',
    );
    _safeNotifyListeners();
  }

  void setCalendarDate(DateTime date) {
    _currentCalendarDate = date;
    _safeNotifyListeners();
  }

  // Handle date and time changes to filter counselors
  void onDateChanged(String date) {
    if (timeController.text.isNotEmpty) {
      fetchCounselorsByAvailability(date, timeController.text);
    }
  }

  void onTimeChanged(String time) {
    if (dateController.text.isNotEmpty) {
      fetchCounselorsByAvailability(dateController.text, time);
    }
  }

  // Fetch counselor availability with time schedule for calendar modal
  Future<List<CounselorAvailability>> fetchCounselorAvailabilityWithSchedule(
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
                    debugPrint(
                      'Counselor: ${counselorWithSchedule.name}, TimeSchedule: ${counselorWithSchedule.timeSchedule}',
                    );
                  }
                }
              }
            } catch (e) {
              debugPrint('Error fetching availability for counselor: $e');
              // Add counselor without schedule as fallback
              counselorsWithSchedule.add(
                CounselorAvailability(
                  counselorId: counselor['counselor_id']?.toString() ?? '',
                  name: counselor['name'] ?? '',
                  specialization:
                      counselor['specialization'] ?? 'General Counseling',
                  timeSchedule: null,
                ),
              );
            }
          }

          return counselorsWithSchedule;
        } else {
          debugPrint('API returned error: ${data['message']}');
        }
      } else {
        debugPrint('HTTP error: ${response.statusCode}');
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching counselor availability with schedule: $e');
      return [];
    }
  }

  // Fetch counselor availability for calendar date
  Future<List<Counselor>> fetchCounselorAvailabilityForDate(
    DateTime date,
  ) async {
    try {
      final formattedDate =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final dayOfWeek = _getDayOfWeek(formattedDate);

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
          final counselors =
              (data['counselors'] as List?)
                  ?.map((c) => Counselor.fromJson(c))
                  .toList() ??
              [];
          debugPrint(
            'Found ${counselors.length} counselors for date: $formattedDate',
          );
          return counselors;
        } else {
          debugPrint('API returned error: ${data['message']}');
        }
      } else {
        debugPrint('HTTP error: ${response.statusCode}');
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching counselor availability for date: $e');
      return [];
    }
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

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 20),
              const Text(
                'Booking Successful!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const Text(
                'Your booking entry has been passed to the Admin. Please wait for confirmation before proceeding. Thank you for your patience!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigate to dashboard after a short delay
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (context.mounted) {
                      Navigator.of(
                        context,
                      ).pushReplacementNamed('/user/dashboard');
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22D3EE),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Navigation
  void navigateToDashboard(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/user/dashboard');
  }

  void navigateToMyAppointments(BuildContext context) {
    Navigator.of(context).pushNamed('/user/my-appointments');
  }
}
