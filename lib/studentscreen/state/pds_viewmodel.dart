import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../models/student_profile.dart';
import '../../api/config.dart';
import '../../utils/session.dart';

class PDSViewModel extends ChangeNotifier {
  final Session _session = Session();

  // PDS data
  PDSData? _pdsData;

  // Loading states
  bool _isLoadingPDS = false;
  bool _isSavingPDS = false;

  // Error states
  String? _pdsError;
  String? _saveError;

  // PDS editing state
  bool _isPdsEditingEnabled = false;

  // Form controllers for PDS
  final Map<String, TextEditingController> _pdsControllers = {};

  // Radio button states for PDS
  final Map<String, String> _radioValues = {};

  // Checkbox states for PDS
  final Map<String, bool> _checkboxValues = {};

  // PWD proof file handling
  PlatformFile? _selectedPwdProofFile;

  PlatformFile? get selectedPwdProofFile => _selectedPwdProofFile;

  void setPwdProofFile(PlatformFile? file) {
    _selectedPwdProofFile = file;
    notifyListeners();
  }

  // Getters
  PDSData? get pdsData => _pdsData;

  bool get isLoadingPDS => _isLoadingPDS;
  bool get isSavingPDS => _isSavingPDS;

  String? get pdsError => _pdsError;
  String? get saveError => _saveError;

  bool get isPdsEditingEnabled => _isPdsEditingEnabled;

  // PDS getters
  String get course => _pdsData?.academic?.course ?? '';
  String get yearLevel => _pdsData?.academic?.yearLevel ?? '';
  String get academicStatus => _pdsData?.academic?.academicStatus ?? '';

  String get lastName => _pdsData?.personal?.lastName ?? '';
  String get firstName => _pdsData?.personal?.firstName ?? '';
  String get middleName => _pdsData?.personal?.middleName ?? '';
  String get dateOfBirth => _pdsData?.personal?.dateOfBirth ?? '';
  String get age => _pdsData?.personal?.age ?? '';
  String get sex => _pdsData?.personal?.sex ?? '';
  String get civilStatus => _pdsData?.personal?.civilStatus ?? '';
  String get contactNumber => _pdsData?.personal?.contactNumber ?? '';
  String get fbAccountName => _pdsData?.personal?.fbAccountName ?? '';
  String get personalEmail => _pdsData?.userEmail ?? '';

  String get permanentZone => _pdsData?.address?.permanentZone ?? '';
  String get permanentBarangay => _pdsData?.address?.permanentBarangay ?? '';
  String get permanentCity => _pdsData?.address?.permanentCity ?? '';
  String get permanentProvince => _pdsData?.address?.permanentProvince ?? '';
  String get presentZone => _pdsData?.address?.presentZone ?? '';
  String get presentBarangay => _pdsData?.address?.presentBarangay ?? '';
  String get presentCity => _pdsData?.address?.presentCity ?? '';
  String get presentProvince => _pdsData?.address?.presentProvince ?? '';

  String get fatherName => _pdsData?.family?.fatherName ?? '';
  String get fatherOccupation => _pdsData?.family?.fatherOccupation ?? '';
  String get motherName => _pdsData?.family?.motherName ?? '';
  String get motherOccupation => _pdsData?.family?.motherOccupation ?? '';
  String get spouse => _pdsData?.family?.spouse ?? '';
  String get guardianContactNumber =>
      _pdsData?.family?.guardianContactNumber ?? '';

  String get isSoloParent => _pdsData?.circumstances?.isSoloParent ?? '';
  String get isIndigenous => _pdsData?.circumstances?.isIndigenous ?? '';
  String get isBreastfeeding => _pdsData?.circumstances?.isBreastfeeding ?? '';
  String get isPwd => _pdsData?.circumstances?.isPwd ?? '';
  String get pwdDisabilityType =>
      _pdsData?.circumstances?.pwdDisabilityType ?? '';
  String get pwdProofFile => _pdsData?.circumstances?.pwdProofFile ?? '';

  String get residenceType => _pdsData?.residence?.residenceType ?? '';
  String get residenceOtherSpecify =>
      _pdsData?.residence?.residenceOtherSpecify ?? '';
  bool get hasConsent => _pdsData?.residence?.hasConsent == 1;

  List<ServiceItem> get servicesNeeded => _pdsData?.servicesNeeded ?? [];
  List<ServiceItem> get servicesAvailed => _pdsData?.servicesAvailed ?? [];

  String get userEmail => _pdsData?.userEmail ?? '';

  // Initialize the PDS viewmodel
  Future<void> initialize(String userId, String email) async {
    await loadPDSData();
  }

  // Load PDS data
  Future<void> loadPDSData() async {
    _isLoadingPDS = true;
    _pdsError = null;
    notifyListeners();

    try {
      final response = await _session.get(
        '${ApiConfig.currentBaseUrl}/student/pds/load',
      );

      debugPrint('PDS Load Response Status: ${response.statusCode}');
      debugPrint('PDS Load Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          _pdsData = PDSData.fromJson(data['data']);
          _initializePDSControllers();
          debugPrint('PDS data loaded successfully');
        } else {
          _pdsError = data['message'] ?? 'Failed to load PDS data';
          debugPrint('PDS Load Error: $_pdsError');
        }
      } else {
        _pdsError = 'Failed to load PDS data: ${response.statusCode}';
        debugPrint('PDS Load HTTP Error: $_pdsError');
      }
    } catch (e) {
      _pdsError = 'Error loading PDS data: $e';
      debugPrint('PDS load error: $e');
    } finally {
      _isLoadingPDS = false;
      notifyListeners();
    }
  }

  // Initialize PDS form controllers
  void _initializePDSControllers() {
    if (_pdsData == null) return;

    // Clear existing controllers first
    _pdsControllers.clear();

    // Academic
    _pdsControllers['course'] = TextEditingController(
      text: course.isNotEmpty ? course : '',
    );
    _pdsControllers['yearLevel'] = TextEditingController(
      text: yearLevel.isNotEmpty ? yearLevel : '',
    );
    _pdsControllers['academicStatus'] = TextEditingController(
      text: academicStatus.isNotEmpty ? academicStatus : '',
    );

    // Personal
    _pdsControllers['lastName'] = TextEditingController(
      text: lastName.isNotEmpty ? lastName : '',
    );
    _pdsControllers['firstName'] = TextEditingController(
      text: firstName.isNotEmpty ? firstName : '',
    );
    _pdsControllers['middleName'] = TextEditingController(
      text: middleName.isNotEmpty ? middleName : '',
    );
    _pdsControllers['dateOfBirth'] = TextEditingController(
      text: dateOfBirth.isNotEmpty ? _formatDateForUI(dateOfBirth) : '',
    );
    _pdsControllers['age'] = TextEditingController(
      text: age.isNotEmpty ? age : '',
    );
    _pdsControllers['sex'] = TextEditingController(
      text: sex.isNotEmpty ? sex : '',
    );
    _pdsControllers['civilStatus'] = TextEditingController(
      text: civilStatus.isNotEmpty ? civilStatus : '',
    );
    _pdsControllers['contactNumber'] = TextEditingController(
      text: contactNumber.isNotEmpty ? contactNumber : '',
    );
    _pdsControllers['fbAccountName'] = TextEditingController(
      text: fbAccountName.isNotEmpty ? fbAccountName : '',
    );

    // Address
    _pdsControllers['permanentZone'] = TextEditingController(
      text: permanentZone.isNotEmpty ? permanentZone : '',
    );
    _pdsControllers['permanentBarangay'] = TextEditingController(
      text: permanentBarangay.isNotEmpty ? permanentBarangay : '',
    );
    _pdsControllers['permanentCity'] = TextEditingController(
      text: permanentCity.isNotEmpty ? permanentCity : '',
    );
    _pdsControllers['permanentProvince'] = TextEditingController(
      text: permanentProvince.isNotEmpty ? permanentProvince : '',
    );
    _pdsControllers['presentZone'] = TextEditingController(
      text: presentZone.isNotEmpty ? presentZone : '',
    );
    _pdsControllers['presentBarangay'] = TextEditingController(
      text: presentBarangay.isNotEmpty ? presentBarangay : '',
    );
    _pdsControllers['presentCity'] = TextEditingController(
      text: presentCity.isNotEmpty ? presentCity : '',
    );
    _pdsControllers['presentProvince'] = TextEditingController(
      text: presentProvince.isNotEmpty ? presentProvince : '',
    );

    // Family
    _pdsControllers['fatherName'] = TextEditingController(
      text: fatherName.isNotEmpty ? fatherName : '',
    );
    _pdsControllers['fatherOccupation'] = TextEditingController(
      text: fatherOccupation.isNotEmpty ? fatherOccupation : '',
    );
    _pdsControllers['motherName'] = TextEditingController(
      text: motherName.isNotEmpty ? motherName : '',
    );
    _pdsControllers['motherOccupation'] = TextEditingController(
      text: motherOccupation.isNotEmpty ? motherOccupation : '',
    );
    _pdsControllers['spouse'] = TextEditingController(
      text: spouse.isNotEmpty ? spouse : '',
    );
    _pdsControllers['guardianContactNumber'] = TextEditingController(
      text: guardianContactNumber.isNotEmpty ? guardianContactNumber : '',
    );

    // Special circumstances
    _pdsControllers['pwdDisabilityType'] = TextEditingController(
      text: pwdDisabilityType.isNotEmpty ? pwdDisabilityType : '',
    );
    _pdsControllers['residenceOtherSpecify'] = TextEditingController(
      text: residenceOtherSpecify.isNotEmpty ? residenceOtherSpecify : '',
    );

    // Services other fields
    final svcOtherText =
        servicesNeeded.where((s) => s.type == 'other').isNotEmpty
        ? servicesNeeded.firstWhere((s) => s.type == 'other').other
        : '';
    final availedOtherText =
        servicesAvailed.where((s) => s.type == 'other').isNotEmpty
        ? servicesAvailed.firstWhere((s) => s.type == 'other').other
        : '';
    _pdsControllers['svcOther'] = TextEditingController(
      text: svcOtherText != null && svcOtherText.isNotEmpty ? svcOtherText : '',
    );
    _pdsControllers['availedOther'] = TextEditingController(
      text: availedOtherText != null && availedOtherText.isNotEmpty
          ? availedOtherText
          : '',
    );

    // Personal email field - auto-populate with user's email
    _pdsControllers['personalEmail'] = TextEditingController(
      text: userEmail.isNotEmpty ? userEmail : '',
    );

    // Initialize radio button values
    _radioValues['soloParent'] = isSoloParent.isNotEmpty ? isSoloParent : 'No';
    _radioValues['indigenous'] = isIndigenous.isNotEmpty ? isIndigenous : 'No';
    _radioValues['breastFeeding'] = isBreastfeeding.isNotEmpty
        ? isBreastfeeding
        : 'N/A';
    _radioValues['pwd'] = isPwd.isNotEmpty ? isPwd : 'No';
    _radioValues['residence'] = residenceType.isNotEmpty
        ? residenceType
        : 'at home';

    // Initialize checkbox values
    _initializeCheckboxValues();
  }

  // Initialize checkbox values from services data
  void _initializeCheckboxValues() {
    // Services needed checkboxes
    _checkboxValues['svcCounseling'] = servicesNeeded.any(
      (service) => service.type == 'counseling',
    );
    _checkboxValues['svcInsurance'] = servicesNeeded.any(
      (service) => service.type == 'insurance',
    );
    _checkboxValues['svcSpecialLanes'] = servicesNeeded.any(
      (service) => service.type == 'special_lanes',
    );
    _checkboxValues['svcSafeLearning'] = servicesNeeded.any(
      (service) => service.type == 'safe_learning',
    );
    _checkboxValues['svcEqualAccess'] = servicesNeeded.any(
      (service) => service.type == 'equal_access',
    );
    _checkboxValues['svcOther'] = servicesNeeded.any(
      (service) => service.type == 'other',
    );

    // Services availed checkboxes
    _checkboxValues['availedCounseling'] = servicesAvailed.any(
      (service) => service.type == 'counseling',
    );
    _checkboxValues['availedInsurance'] = servicesAvailed.any(
      (service) => service.type == 'insurance',
    );
    _checkboxValues['availedSpecialLanes'] = servicesAvailed.any(
      (service) => service.type == 'special_lanes',
    );
    _checkboxValues['availedSafeLearning'] = servicesAvailed.any(
      (service) => service.type == 'safe_learning',
    );
    _checkboxValues['availedEqualAccess'] = servicesAvailed.any(
      (service) => service.type == 'equal_access',
    );
    _checkboxValues['availedOther'] = servicesAvailed.any(
      (service) => service.type == 'other',
    );

    // Consent checkbox
    _checkboxValues['consentAgree'] = hasConsent;
  }

  // Toggle PDS editing
  void togglePdsEditing() {
    _isPdsEditingEnabled = !_isPdsEditingEnabled;
    notifyListeners();
  }

  // Save PDS data - matching PHP backend expectations exactly
  Future<bool> savePDSData(String email) async {
    _isSavingPDS = true;
    _saveError = null;
    notifyListeners();

    try {
      // Create payload matching PHP preparePDSData method exactly
      final payload = <String, dynamic>{
        // Academic Information
        'course': _pdsControllers['course']?.text ?? 'N/A',
        'yearLevel': _pdsControllers['yearLevel']?.text ?? 'N/A',
        'academicStatus': _pdsControllers['academicStatus']?.text ?? 'N/A',

        // Personal Information
        'lastName': _pdsControllers['lastName']?.text ?? 'N/A',
        'firstName': _pdsControllers['firstName']?.text ?? 'N/A',
        'middleName': _pdsControllers['middleName']?.text ?? 'N/A',
        'dateOfBirth': _pdsControllers['dateOfBirth']?.text.isNotEmpty == true
            ? _formatDateForBackend(_pdsControllers['dateOfBirth']!.text)
            : '',
        'age': _pdsControllers['age']?.text.isNotEmpty == true
            ? _pdsControllers['age']!.text
            : null,
        'sex': _pdsControllers['sex']?.text ?? 'N/A',
        'civilStatus': _pdsControllers['civilStatus']?.text ?? 'Single',
        'contactNumber':
            _pdsControllers['contactNumber']?.text.isNotEmpty == true
            ? _pdsControllers['contactNumber']!.text
            : 'N/A',
        'fbAccountName': _pdsControllers['fbAccountName']?.text ?? 'N/A',

        // Address Information
        'permanentZone': _pdsControllers['permanentZone']?.text ?? 'N/A',
        'permanentBarangay':
            _pdsControllers['permanentBarangay']?.text ?? 'N/A',
        'permanentCity': _pdsControllers['permanentCity']?.text ?? 'N/A',
        'permanentProvince':
            _pdsControllers['permanentProvince']?.text ?? 'N/A',
        'presentZone': _pdsControllers['presentZone']?.text ?? 'N/A',
        'presentBarangay': _pdsControllers['presentBarangay']?.text ?? 'N/A',
        'presentCity': _pdsControllers['presentCity']?.text ?? 'N/A',
        'presentProvince': _pdsControllers['presentProvince']?.text ?? 'N/A',

        // Family Information
        'fatherName': _pdsControllers['fatherName']?.text ?? 'N/A',
        'fatherOccupation': _pdsControllers['fatherOccupation']?.text ?? 'N/A',
        'motherName': _pdsControllers['motherName']?.text ?? 'N/A',
        'motherOccupation': _pdsControllers['motherOccupation']?.text ?? 'N/A',
        'spouse': _pdsControllers['spouse']?.text ?? 'N/A',
        'guardianContactNumber':
            _pdsControllers['guardianContactNumber']?.text.isNotEmpty == true
            ? _pdsControllers['guardianContactNumber']!.text
            : 'N/A',
        // Special Circumstances
        'soloParent': _radioValues['soloParent'] ?? 'No',
        'indigenous': _radioValues['indigenous'] ?? 'No',
        'breastFeeding': _radioValues['breastFeeding'] ?? 'N/A',
        'pwd': _radioValues['pwd'] ?? 'No',
        'pwdSpecify': _pdsControllers['pwdDisabilityType']?.text ?? 'N/A',
        // Services Needed
        'services_needed': _buildServicesJson('needed'),

        // Services Availed
        'services_availed': _buildServicesJson('availed'),

        // Residence Information
        'residence': _radioValues['residence'] ?? 'at home',
        'resOtherText': _pdsControllers['residenceOtherSpecify']?.text ?? 'N/A',
        'consentAgree': _checkboxValues['consentAgree'] == true ? '1' : '0',
      };

      // Debug: Log the data being sent
      debugPrint('PDS Save - Sending data:');
      payload.forEach((key, value) {
        debugPrint('$key: $value');
      });

      // Prepare files for upload if PWD proof file is selected
      Map<String, List<int>>? files;
      if (_selectedPwdProofFile != null) {
        try {
          final file = File(_selectedPwdProofFile!.path!);
          final fileBytes = await file.readAsBytes();
          files = {'pwdProof': fileBytes};
          debugPrint(
            'PDS Save - Including PWD proof file: ${_selectedPwdProofFile!.name}',
          );
        } catch (e) {
          debugPrint('PDS Save - Error reading PWD proof file: $e');
          _saveError = 'Error reading PWD proof file: $e';
          return false;
        }
      }

      final response = await _session.post(
        '${ApiConfig.currentBaseUrl}/student/pds/save',
        fields: payload.map((key, value) => MapEntry(key, value.toString())),
        files: files,
      );

      debugPrint('PDS Save Response Status: ${response.statusCode}');
      debugPrint('PDS Save Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          _isPdsEditingEnabled = false;
          await loadPDSData(); // Reload data
          debugPrint('PDS data saved successfully');
          return true;
        } else {
          _saveError = data['message'] ?? 'Failed to save PDS data';
          debugPrint('PDS Save Error: $_saveError');
        }
      } else {
        _saveError = 'Failed to save PDS data: ${response.statusCode}';
        debugPrint('PDS Save HTTP Error: $_saveError');
      }
    } catch (e) {
      _saveError = 'Error saving PDS data: $e';
      debugPrint('PDS save error: $e');
    } finally {
      _isSavingPDS = false;
      notifyListeners();
    }

    return false;
  }

  // Helper method to format date for UI display
  String _formatDateForUI(String dateString) {
    try {
      // Check if the date is already in dd/MM/yyyy format (from UI)
      if (RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(dateString)) {
        return dateString;
      }

      // Check if the date is in yyyy-MM-dd format (from backend)
      if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(dateString)) {
        final parsedDate = DateFormat('yyyy-MM-dd').parse(dateString);
        return DateFormat('dd/MM/yyyy').format(parsedDate);
      }

      // If neither format matches, return empty string
      debugPrint(
        'PDS Date Format Error: Unrecognized date format: $dateString',
      );
      return '';
    } catch (e) {
      debugPrint(
        'PDS Date Format Error: Failed to parse date "$dateString": $e',
      );
      return '';
    }
  }

  // Helper method to format date for backend
  String _formatDateForBackend(String dateString) {
    try {
      // Check if the date is already in yyyy-MM-dd format (from backend)
      if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(dateString)) {
        return dateString;
      }

      // Check if the date is in dd/MM/yyyy format (from UI)
      if (RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(dateString)) {
        final parsedDate = DateFormat('dd/MM/yyyy').parse(dateString);
        return DateFormat('yyyy-MM-dd').format(parsedDate);
      }

      // If neither format matches, return empty string
      debugPrint(
        'PDS Date Format Error: Unrecognized date format: $dateString',
      );
      return '';
    } catch (e) {
      debugPrint(
        'PDS Date Format Error: Failed to parse date "$dateString": $e',
      );
      return '';
    }
  }

  // Helper method to build services JSON
  String _buildServicesJson(String type) {
    final services = <Map<String, dynamic>>[];
    final checkboxes = type == 'needed'
        ? [
            {'id': 'svcCounseling', 'type': 'counseling'},
            {'id': 'svcInsurance', 'type': 'insurance'},
            {'id': 'svcSpecialLanes', 'type': 'special_lanes'},
            {'id': 'svcSafeLearning', 'type': 'safe_learning'},
            {'id': 'svcEqualAccess', 'type': 'equal_access'},
          ]
        : [
            {'id': 'availedCounseling', 'type': 'counseling'},
            {'id': 'availedInsurance', 'type': 'insurance'},
            {'id': 'availedSpecialLanes', 'type': 'special_lanes'},
            {'id': 'availedSafeLearning', 'type': 'safe_learning'},
            {'id': 'availedEqualAccess', 'type': 'equal_access'},
          ];

    for (final service in checkboxes) {
      if (_checkboxValues[service['id']] == true) {
        services.add({'type': service['type'], 'other': null});
      }
    }

    final otherText =
        _pdsControllers[type == 'needed' ? 'svcOther' : 'availedOther']?.text ??
        '';
    if (_checkboxValues[type == 'needed' ? 'svcOther' : 'availedOther'] ==
            true &&
        otherText.isNotEmpty) {
      services.add({'type': 'other', 'other': otherText});
    }

    return services.isNotEmpty ? json.encode(services) : '[]';
  }

  // Get controller for PDS field
  TextEditingController? getController(String fieldName) {
    return _pdsControllers[fieldName];
  }

  // Get radio button value
  String getRadioValue(String fieldName) {
    return _radioValues[fieldName] ?? '';
  }

  // Set radio button value
  void setRadioValue(String fieldName, String value) {
    _radioValues[fieldName] = value;
    notifyListeners();
  }

  // Get checkbox value
  bool getCheckboxValue(String fieldName) {
    return _checkboxValues[fieldName] ?? false;
  }

  // Set checkbox value
  void setCheckboxValue(String fieldName, bool value) {
    _checkboxValues[fieldName] = value;
    notifyListeners();
  }

  // Clear errors
  void clearErrors() {
    _pdsError = null;
    _saveError = null;
    notifyListeners();
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (final controller in _pdsControllers.values) {
      controller.dispose();
    }
    _pdsControllers.clear();
    super.dispose();
  }
}
