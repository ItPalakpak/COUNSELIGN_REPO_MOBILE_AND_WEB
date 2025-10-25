class StudentProfile {
  final String userId;
  final String username;
  final String email;
  final String? profilePicture;

  StudentProfile({
    required this.userId,
    required this.username,
    required this.email,
    this.profilePicture,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      userId: json['user_id']?.toString() ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      profilePicture: json['profile_picture'],
    );
  }

  String buildImageUrl(String baseUrl) {
    if (profilePicture == null || profilePicture!.isEmpty) {
      return '$baseUrl/Photos/profile.png';
    }
    
    // Remove /index.php from base URL if present
    String cleanBaseUrl = baseUrl.replaceAll('/index.php', '');
    
    if (profilePicture!.startsWith('http')) {
      return profilePicture!;
    }
    
    if (profilePicture!.startsWith('/')) {
      return '$cleanBaseUrl${profilePicture!.substring(1)}';
    }
    
    return '$cleanBaseUrl/$profilePicture';
  }
}

class PDSData {
  final AcademicInfo? academic;
  final PersonalInfo? personal;
  final AddressInfo? address;
  final FamilyInfo? family;
  final SpecialCircumstances? circumstances;
  final List<ServiceItem>? servicesNeeded;
  final List<ServiceItem>? servicesAvailed;
  final ResidenceInfo? residence;
  final String? userEmail;

  PDSData({
    this.academic,
    this.personal,
    this.address,
    this.family,
    this.circumstances,
    this.servicesNeeded,
    this.servicesAvailed,
    this.residence,
    this.userEmail,
  });

  factory PDSData.fromJson(Map<String, dynamic> json) {
    return PDSData(
      academic: json['academic'] != null ? AcademicInfo.fromJson(json['academic']) : null,
      personal: json['personal'] != null ? PersonalInfo.fromJson(json['personal']) : null,
      address: json['address'] != null ? AddressInfo.fromJson(json['address']) : null,
      family: json['family'] != null ? FamilyInfo.fromJson(json['family']) : null,
      circumstances: json['circumstances'] != null ? SpecialCircumstances.fromJson(json['circumstances']) : null,
      servicesNeeded: json['services_needed'] != null 
          ? (json['services_needed'] as List).map((item) => ServiceItem.fromJson(item)).toList()
          : null,
      servicesAvailed: json['services_availed'] != null 
          ? (json['services_availed'] as List).map((item) => ServiceItem.fromJson(item)).toList()
          : null,
      residence: json['residence'] != null ? ResidenceInfo.fromJson(json['residence']) : null,
      userEmail: json['user_email'],
    );
  }
}

class AcademicInfo {
  final String studentId;
  final String course;
  final String yearLevel;
  final String academicStatus;

  AcademicInfo({
    required this.studentId,
    required this.course,
    required this.yearLevel,
    required this.academicStatus,
  });

  factory AcademicInfo.fromJson(Map<String, dynamic> json) {
    return AcademicInfo(
      studentId: json['student_id']?.toString() ?? '',
      course: json['course'] ?? '',
      yearLevel: json['year_level'] ?? '',
      academicStatus: json['academic_status'] ?? '',
    );
  }
}

class PersonalInfo {
  final String studentId;
  final String lastName;
  final String firstName;
  final String middleName;
  final String? dateOfBirth;
  final String? age;
  final String sex;
  final String civilStatus;
  final String contactNumber;
  final String fbAccountName;

  PersonalInfo({
    required this.studentId,
    required this.lastName,
    required this.firstName,
    required this.middleName,
    this.dateOfBirth,
    this.age,
    required this.sex,
    required this.civilStatus,
    required this.contactNumber,
    required this.fbAccountName,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      studentId: json['student_id']?.toString() ?? '',
      lastName: json['last_name'] ?? '',
      firstName: json['first_name'] ?? '',
      middleName: json['middle_name'] ?? '',
      dateOfBirth: json['date_of_birth'],
      age: json['age']?.toString(),
      sex: json['sex'] ?? '',
      civilStatus: json['civil_status'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      fbAccountName: json['fb_account_name'] ?? '',
    );
  }
}

class AddressInfo {
  final String studentId;
  final String permanentZone;
  final String permanentBarangay;
  final String permanentCity;
  final String permanentProvince;
  final String presentZone;
  final String presentBarangay;
  final String presentCity;
  final String presentProvince;

  AddressInfo({
    required this.studentId,
    required this.permanentZone,
    required this.permanentBarangay,
    required this.permanentCity,
    required this.permanentProvince,
    required this.presentZone,
    required this.presentBarangay,
    required this.presentCity,
    required this.presentProvince,
  });

  factory AddressInfo.fromJson(Map<String, dynamic> json) {
    return AddressInfo(
      studentId: json['student_id']?.toString() ?? '',
      permanentZone: json['permanent_zone'] ?? '',
      permanentBarangay: json['permanent_barangay'] ?? '',
      permanentCity: json['permanent_city'] ?? '',
      permanentProvince: json['permanent_province'] ?? '',
      presentZone: json['present_zone'] ?? '',
      presentBarangay: json['present_barangay'] ?? '',
      presentCity: json['present_city'] ?? '',
      presentProvince: json['present_province'] ?? '',
    );
  }
}

class FamilyInfo {
  final String studentId;
  final String fatherName;
  final String fatherOccupation;
  final String motherName;
  final String motherOccupation;
  final String spouse;
  final String guardianContactNumber;

  FamilyInfo({
    required this.studentId,
    required this.fatherName,
    required this.fatherOccupation,
    required this.motherName,
    required this.motherOccupation,
    required this.spouse,
    required this.guardianContactNumber,
  });

  factory FamilyInfo.fromJson(Map<String, dynamic> json) {
    return FamilyInfo(
      studentId: json['student_id']?.toString() ?? '',
      fatherName: json['father_name'] ?? '',
      fatherOccupation: json['father_occupation'] ?? '',
      motherName: json['mother_name'] ?? '',
      motherOccupation: json['mother_occupation'] ?? '',
      spouse: json['spouse'] ?? '',
      guardianContactNumber: json['guardian_contact_number'] ?? '',
    );
  }
}

class SpecialCircumstances {
  final String studentId;
  final String isSoloParent;
  final String isIndigenous;
  final String isBreastfeeding;
  final String isPwd;
  final String pwdDisabilityType;
  final String pwdProofFile;

  SpecialCircumstances({
    required this.studentId,
    required this.isSoloParent,
    required this.isIndigenous,
    required this.isBreastfeeding,
    required this.isPwd,
    required this.pwdDisabilityType,
    required this.pwdProofFile,
  });

  factory SpecialCircumstances.fromJson(Map<String, dynamic> json) {
    return SpecialCircumstances(
      studentId: json['student_id']?.toString() ?? '',
      isSoloParent: json['is_solo_parent'] ?? '',
      isIndigenous: json['is_indigenous'] ?? '',
      isBreastfeeding: json['is_breastfeeding'] ?? '',
      isPwd: json['is_pwd'] ?? '',
      pwdDisabilityType: json['pwd_disability_type'] ?? '',
      pwdProofFile: json['pwd_proof_file'] ?? '',
    );
  }
}

class ServiceItem {
  final String type;
  final String? other;

  ServiceItem({
    required this.type,
    this.other,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      type: json['type'] ?? '',
      other: json['other'],
    );
  }
}

class ResidenceInfo {
  final String studentId;
  final String residenceType;
  final String residenceOtherSpecify;
  final int hasConsent;

  ResidenceInfo({
    required this.studentId,
    required this.residenceType,
    required this.residenceOtherSpecify,
    required this.hasConsent,
  });

  factory ResidenceInfo.fromJson(Map<String, dynamic> json) {
    return ResidenceInfo(
      studentId: json['student_id']?.toString() ?? '',
      residenceType: json['residence_type'] ?? '',
      residenceOtherSpecify: json['residence_other_specify'] ?? '',
      hasConsent: int.tryParse(json['has_consent']?.toString() ?? '0') ?? 0,
    );
  }
}


