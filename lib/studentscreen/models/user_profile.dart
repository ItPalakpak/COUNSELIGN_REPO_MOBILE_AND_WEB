class UserProfile {
  final String userId;
  final String? username;
  final String? email;
  final String? lastLogin;
  final String? profileImage;
  final String? courseYear;

  UserProfile({
    required this.userId,
    this.username,
    this.email,
    this.lastLogin,
    this.profileImage,
    this.courseYear,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['user_id'] ?? json['id'] ?? '',
      username: json['username'],
      email: json['email'],
      lastLogin: json['last_login'],
      profileImage: json['profile_picture'] ?? json['profile_image'],
      courseYear: json['courseYear'],
    );
  }

  String get displayName => username ?? userId;
  String get profileImageUrl {
    if (profileImage == null || profileImage!.isEmpty) {
      return 'Photos/profile.png';
    }

    // If it's already a full URL, return as is
    if (profileImage!.startsWith('http')) {
      return profileImage!;
    }

    // If it starts with Photos/, return as is
    if (profileImage!.startsWith('Photos/')) {
      return profileImage!;
    }

    // Otherwise, prepend Photos/ if not already there
    return profileImage!.startsWith('/')
        ? profileImage!.substring(1)
        : profileImage!;
  }
}
