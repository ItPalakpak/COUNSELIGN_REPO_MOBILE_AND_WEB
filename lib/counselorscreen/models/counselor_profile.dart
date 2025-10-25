import 'package:flutter/foundation.dart';

class CounselorProfile {
  final int id;
  final String userId;
  final String username;
  final String email;
  final String role;
  final String? lastLogin;
  final String? profilePicture;
  final CounselorDetails? counselor;

  // Backward compatibility fields for dashboard
  String get name => counselor?.name ?? username;
  String get profileImageUrl => buildImageUrl('');

  CounselorProfile({
    required this.id,
    required this.userId,
    required this.username,
    required this.email,
    required this.role,
    this.lastLogin,
    this.profilePicture,
    this.counselor,
  });

  factory CounselorProfile.fromJson(Map<String, dynamic> json) {
    return CounselorProfile(
      id: _parseInt(json['id']) ?? _parseInt(json['user_id']) ?? 0,
      userId: json['user_id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      lastLogin: json['last_login']?.toString(),
      profilePicture:
          json['profile_picture']?.toString() ??
          json['profile_image_url']?.toString(),
      counselor: json['counselor'] != null
          ? CounselorDetails.fromJson(json['counselor'])
          : null,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'username': username,
      'email': email,
      'role': role,
      'last_login': lastLogin,
      'profile_picture': profilePicture,
      'counselor': counselor?.toJson(),
    };
  }

  // Helper method to build full image URL
  String buildImageUrl(String baseUrl) {
    debugPrint('🖼️ Model: Building image URL with baseUrl: $baseUrl');
    debugPrint('🖼️ Model: Profile picture field: $profilePicture');

    if (profilePicture == null || profilePicture!.isEmpty) {
      debugPrint(
        '🖼️ Model: No profile picture, using default: $baseUrl/Photos/profile.png',
      );
      return '$baseUrl/Photos/profile.png';
    }

    final trimmed = profilePicture!.trim();
    debugPrint('🖼️ Model: Trimmed profile picture: $trimmed');

    if (trimmed.startsWith('http')) {
      debugPrint('🖼️ Model: Already full URL: $trimmed');
      return trimmed;
    }

    // Fix: Remove /index.php from baseUrl if it exists
    String cleanBaseUrl = baseUrl;
    if (cleanBaseUrl.endsWith('/index.php')) {
      cleanBaseUrl = cleanBaseUrl.replaceAll('/index.php', '');
    }

    if (trimmed.startsWith('/')) {
      final url = '$cleanBaseUrl$trimmed';
      debugPrint('🖼️ Model: Building URL with leading slash: $url');
      return url;
    }
    final url = '$cleanBaseUrl/$trimmed';
    debugPrint('🖼️ Model: Building URL: $url');
    return url;
  }
}

class CounselorDetails {
  final String? counselorId;
  final String? name;
  final String? degree;
  final String? email;
  final String? contactNumber;
  final String? address;
  final String? profilePicture;
  final String? civilStatus;
  final String? sex;
  final String? birthdate;

  CounselorDetails({
    this.counselorId,
    this.name,
    this.degree,
    this.email,
    this.contactNumber,
    this.address,
    this.profilePicture,
    this.civilStatus,
    this.sex,
    this.birthdate,
  });

  factory CounselorDetails.fromJson(Map<String, dynamic> json) {
    return CounselorDetails(
      counselorId: json['counselor_id']?.toString(),
      name: json['name']?.toString(),
      degree: json['degree']?.toString(),
      email: json['email']?.toString(),
      contactNumber: json['contact_number']?.toString(),
      address: json['address']?.toString(),
      profilePicture: json['profile_picture']?.toString(),
      civilStatus: json['civil_status']?.toString(),
      sex: json['sex']?.toString(),
      birthdate: json['birthdate']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'counselor_id': counselorId,
      'name': name,
      'degree': degree,
      'email': email,
      'contact_number': contactNumber,
      'address': address,
      'profile_picture': profilePicture,
      'civil_status': civilStatus,
      'sex': sex,
      'birthdate': birthdate,
    };
  }
}
