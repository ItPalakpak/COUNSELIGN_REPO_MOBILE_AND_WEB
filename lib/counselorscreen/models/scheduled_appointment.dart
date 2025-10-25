import 'dart:convert';

class CounselorScheduledAppointment {
  final int id;
  final int studentId;
  final String studentName;
  final String studentEmail;
  final String courseYear;
  final String course;
  final String yearLevel;
  final String? appointedDate;
  final String? preferredDate;
  final String? time;
  final String? preferredTime;
  final String consultationType;
  final String purpose;
  final String status;
  final String? counselorPreference;
  final String? reason;
  final DateTime createdAt;
  final DateTime updatedAt;

  CounselorScheduledAppointment({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.studentEmail,
    required this.courseYear,
    required this.course,
    required this.yearLevel,
    this.appointedDate,
    this.preferredDate,
    this.time,
    this.preferredTime,
    required this.consultationType,
    required this.purpose,
    required this.status,
    this.counselorPreference,
    this.reason,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CounselorScheduledAppointment.fromJson(Map<String, dynamic> json) {
    return CounselorScheduledAppointment(
      id: _parseInt(json['id']),
      studentId: _parseInt(json['student_id']),
      studentName: json['student_name'] ?? 'Unknown',
      studentEmail: json['user_email'] ?? json['email'] ?? '',
      courseYear: json['course_year'] ?? '',
      course: json['course'] ?? '',
      yearLevel: json['year_level'] ?? '',
      appointedDate: json['appointed_date'],
      preferredDate: json['preferred_date'],
      time: json['time'],
      preferredTime: json['preferred_time'],
      consultationType: json['consultation_type'] ?? 'In-person',
      purpose: json['purpose'] ?? 'Not specified',
      status: json['status'] ?? 'pending',
      counselorPreference:
          json['counselorPreference'] ?? json['counselor_name'],
      reason: json['reason'],
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'student_name': studentName,
      'user_email': studentEmail,
      'course_year': courseYear,
      'course': course,
      'year_level': yearLevel,
      'appointed_date': appointedDate,
      'preferred_date': preferredDate,
      'time': time,
      'preferred_time': preferredTime,
      'consultation_type': consultationType,
      'purpose': purpose,
      'status': status,
      'counselorPreference': counselorPreference,
      'reason': reason,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Helper method to parse integer values safely
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  // Helper method to parse datetime values safely
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  // Get the effective date (appointed_date or preferred_date)
  String? get effectiveDate => appointedDate ?? preferredDate;

  // Get the effective time (time or preferred_time)
  String? get effectiveTime => time ?? preferredTime;

  // Check if appointment is today
  bool get isToday {
    if (effectiveDate == null) return false;
    try {
      final appointmentDate = DateTime.parse(effectiveDate!);
      final today = DateTime.now();
      return appointmentDate.year == today.year &&
          appointmentDate.month == today.month &&
          appointmentDate.day == today.day;
    } catch (e) {
      return false;
    }
  }

  // Check if appointment is completed
  bool get isCompleted => status.toLowerCase() == 'completed';

  // Check if appointment is cancelled
  bool get isCancelled => status.toLowerCase() == 'cancelled';

  // Check if appointment is approved
  bool get isApproved => status.toLowerCase() == 'approved';

  // Get formatted date string
  String get formattedDate {
    if (effectiveDate == null) return 'Not scheduled';
    try {
      final date = DateTime.parse(effectiveDate!);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  // Get formatted time string - time is already in 12-hour format with meridian labels
  String get formattedTime {
    if (effectiveTime == null) return 'Not specified';

    // Time is already in 12-hour format with AM/PM, return as is
    return effectiveTime!;
  }

  // Get status color for UI
  String get statusColor {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'success';
      case 'cancelled':
        return 'danger';
      case 'approved':
        return 'primary';
      case 'rejected':
        return 'danger';
      case 'pending':
      default:
        return 'warning';
    }
  }

  // Get status text for display
  String get statusText {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'pending':
      default:
        return 'Pending';
    }
  }
}
