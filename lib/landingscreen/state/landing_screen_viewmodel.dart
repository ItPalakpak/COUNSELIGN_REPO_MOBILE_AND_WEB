import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:counselign/api/config.dart';
import '../../routes.dart';
import '../../utils/session.dart';

class LandingScreenViewModel extends ChangeNotifier {
  // Session management
  final Session _session = Session();

  // Dialog visibility states
  bool _showLoginDialog = false;
  bool _showSignUpDialog = false;
  bool _showForgotPasswordDialog = false;
  bool _showCodeEntryDialog = false;
  bool _showNewPasswordDialog = false;
  bool _showTermsDialog = false;
  bool _showContactDialog = false;
  bool _showVerificationDialog = false;
  bool _showVerificationSuccessDialog = false;
  bool _showAdminLoginDialog = false;

  // Loading states
  bool _isLoginLoading = false;
  bool _isSignUpLoading = false;
  bool _isForgotPasswordLoading = false;
  bool _isCodeEntryLoading = false;
  bool _isNewPasswordLoading = false;
  bool _isContactLoading = false;
  bool _isVerificationLoading = false;
  bool _isResendVerificationLoading = false;
  bool _isAdminLoginLoading = false;
  final bool _isForgotPasswordNavigating = false;
  final bool _isSignUpNavigating = false;

  // Error messages
  String _loginError = '';
  String _signUpError = '';
  String _forgotPasswordError = '';
  String _codeEntryError = '';
  String _newPasswordError = '';
  String _contactError = '';
  String _verificationError = '';
  String _adminLoginError = '';

  // Individual field errors
  String _loginUserIdError = '';
  String _loginPasswordError = '';
  String _signUpUserIdError = '';
  String _signUpUsernameError = '';
  String _signUpEmailError = '';
  String _signUpPasswordError = '';
  String _signUpConfirmPasswordError = '';
  String _forgotPasswordInputError = '';
  String _resetCodeError = '';
  String _newPasswordErrorField = '';
  String _confirmNewPasswordError = '';

  // Verification state
  String _verificationMessage =
      'A verification email has been sent to your registered email address. Please enter the token below to verify your account.';
  String _redirectUrl = '';
  String _verificationRole = '';

  // Controllers for form fields
  final TextEditingController loginUserIdController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  final TextEditingController signUpUserIdController = TextEditingController();
  final TextEditingController signUpUsernameController =
      TextEditingController();
  final TextEditingController signUpEmailController = TextEditingController();
  final TextEditingController signUpPasswordController =
      TextEditingController();
  final TextEditingController signUpConfirmPasswordController =
      TextEditingController();
  final TextEditingController forgotPasswordController =
      TextEditingController();
  final TextEditingController resetCodeController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();
  final TextEditingController contactNameController = TextEditingController();
  final TextEditingController contactEmailController = TextEditingController();
  final TextEditingController contactSubjectController =
      TextEditingController();
  final TextEditingController contactMessageController =
      TextEditingController();
  final TextEditingController verificationTokenController =
      TextEditingController();
  final TextEditingController adminUserIdController = TextEditingController();
  final TextEditingController adminPasswordController = TextEditingController();

  // Dropdown values
  String? _loginRole;
  String? _signUpRole;

  // Password visibility
  bool _loginPasswordVisible = false;
  bool _signUpPasswordVisible = false;
  bool _signUpConfirmPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmNewPasswordVisible = false;

  // Terms checkbox
  bool _termsAccepted = false;

  // Verified code for password reset
  String _verifiedResetCode = '';
  String _forgotPasswordIdentifier = '';

  // Getters for state
  bool get showLoginDialog => _showLoginDialog;
  bool get showSignUpDialog => _showSignUpDialog;
  bool get showForgotPasswordDialog => _showForgotPasswordDialog;
  bool get showCodeEntryDialog => _showCodeEntryDialog;
  bool get showNewPasswordDialog => _showNewPasswordDialog;
  bool get showTermsDialog => _showTermsDialog;
  bool get showContactDialog => _showContactDialog;
  bool get showVerificationDialog => _showVerificationDialog;
  bool get showAdminLoginDialog => _showAdminLoginDialog;

  bool get isLoginLoading => _isLoginLoading;
  bool get isSignUpLoading => _isSignUpLoading;
  bool get isForgotPasswordLoading => _isForgotPasswordLoading;
  bool get isCodeEntryLoading => _isCodeEntryLoading;
  bool get isNewPasswordLoading => _isNewPasswordLoading;
  bool get isContactLoading => _isContactLoading;
  bool get isVerificationLoading => _isVerificationLoading;
  bool get isResendVerificationLoading => _isResendVerificationLoading;
  bool get isAdminLoginLoading => _isAdminLoginLoading;
  bool get isForgotPasswordNavigating => _isForgotPasswordNavigating;
  bool get isSignUpNavigating => _isSignUpNavigating;

  String get loginError => _loginError;
  String get signUpError => _signUpError;
  String get forgotPasswordError => _forgotPasswordError;
  String get codeEntryError => _codeEntryError;
  String get newPasswordError => _newPasswordError;
  String get contactError => _contactError;
  String get verificationError => _verificationError;
  String get adminLoginError => _adminLoginError;

  // Individual field error getters
  String get loginUserIdError => _loginUserIdError;
  String get loginPasswordError => _loginPasswordError;
  String get signUpUserIdError => _signUpUserIdError;
  String get signUpUsernameError => _signUpUsernameError;
  String get signUpEmailError => _signUpEmailError;
  String get signUpPasswordError => _signUpPasswordError;
  String get signUpConfirmPasswordError => _signUpConfirmPasswordError;
  String get forgotPasswordInputError => _forgotPasswordInputError;
  String get resetCodeError => _resetCodeError;
  String get newPasswordErrorField => _newPasswordErrorField;
  String get confirmNewPasswordError => _confirmNewPasswordError;

  String get verificationMessage => _verificationMessage;
  bool get showVerificationSuccessDialog => _showVerificationSuccessDialog;
  String get verificationRole => _verificationRole;

  String? get loginRole => _loginRole;
  String? get signUpRole => _signUpRole;

  bool get loginPasswordVisible => _loginPasswordVisible;
  bool get signUpPasswordVisible => _signUpPasswordVisible;
  bool get signUpConfirmPasswordVisible => _signUpConfirmPasswordVisible;
  bool get newPasswordVisible => _newPasswordVisible;
  bool get confirmNewPasswordVisible => _confirmNewPasswordVisible;

  bool get termsAccepted => _termsAccepted;

  // Setters for state
  set loginRole(String? value) {
    _loginRole = value;
    notifyListeners();
  }

  set signUpRole(String? value) {
    _signUpRole = value;
    notifyListeners();
  }

  set loginPasswordVisible(bool value) {
    _loginPasswordVisible = value;
    notifyListeners();
  }

  set signUpPasswordVisible(bool value) {
    _signUpPasswordVisible = value;
    notifyListeners();
  }

  set signUpConfirmPasswordVisible(bool value) {
    _signUpConfirmPasswordVisible = value;
    notifyListeners();
  }

  set newPasswordVisible(bool value) {
    _newPasswordVisible = value;
    notifyListeners();
  }

  set confirmNewPasswordVisible(bool value) {
    _confirmNewPasswordVisible = value;
    notifyListeners();
  }

  set termsAccepted(bool value) {
    _termsAccepted = value;
    notifyListeners();
  }

  // Initialization
  void initialize() {
    loginUserIdController.addListener(_filterLoginUserId);
    signUpUserIdController.addListener(_filterSignUpUserId);
  }

  @override
  void dispose() {
    loginUserIdController.dispose();
    loginPasswordController.dispose();
    signUpUserIdController.dispose();
    signUpUsernameController.dispose();
    signUpEmailController.dispose();
    signUpPasswordController.dispose();
    signUpConfirmPasswordController.dispose();
    forgotPasswordController.dispose();
    resetCodeController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    contactNameController.dispose();
    contactEmailController.dispose();
    contactSubjectController.dispose();
    contactMessageController.dispose();
    verificationTokenController.dispose();
    adminUserIdController.dispose();
    adminPasswordController.dispose();
    super.dispose();
  }

  void _filterLoginUserId() {
    String value = loginUserIdController.text.replaceAll(RegExp(r'\D'), '');
    if (_loginRole == 'student' || _loginRole == 'counselor') {
      if (value.length > 10) value = value.substring(0, 10);
    }
    if (loginUserIdController.text != value) {
      loginUserIdController.value = TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
      );
    }
  }

  void _filterSignUpUserId() {
    String value = signUpUserIdController.text.replaceAll(RegExp(r'\D'), '');
    if (_signUpRole == 'student') {
      if (value.length > 10) value = value.substring(0, 10);
    }
    if (signUpUserIdController.text != value) {
      signUpUserIdController.value = TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
      );
    }
  }

  // Dialog management methods
  void setShowLoginDialog(bool value) {
    _showLoginDialog = value;
    notifyListeners();
  }

  void setShowSignUpDialog(bool value) {
    _showSignUpDialog = value;
    notifyListeners();
  }

  void setShowForgotPasswordDialog(bool value) {
    _showForgotPasswordDialog = value;
    notifyListeners();
  }

  void setShowCodeEntryDialog(bool value) {
    _showCodeEntryDialog = value;
    notifyListeners();
  }

  void setShowNewPasswordDialog(bool value) {
    _showNewPasswordDialog = value;
    notifyListeners();
  }

  void setShowTermsDialog(bool value) {
    _showTermsDialog = value;
    notifyListeners();
  }

  void setShowContactDialog(bool value) {
    _showContactDialog = value;
    notifyListeners();
  }

  void setShowVerificationDialog(
    bool value, {
    String message =
        "A verification email has been sent to your registered email address. Please enter the token below to verify your account.",
    String role = '',
  }) {
    _verificationMessage = message;
    _verificationError = '';
    verificationTokenController.clear();
    _verificationRole = role;
    _showVerificationDialog = value;
    notifyListeners();
  }

  void setShowVerificationSuccessDialog(bool value) {
    _showVerificationSuccessDialog = value;
    notifyListeners();
  }

  void setShowAdminLoginDialog(bool value) {
    _showAdminLoginDialog = value;
    if (value) {
      // Copy user ID from login form to admin form
      adminUserIdController.text = loginUserIdController.text;
      _adminLoginError = '';
    }
    notifyListeners();
  }

  void hideAllDialogs() {
    _showLoginDialog = false;
    _showSignUpDialog = false;
    _showForgotPasswordDialog = false;
    _showCodeEntryDialog = false;
    _showNewPasswordDialog = false;
    _showTermsDialog = false;
    _showContactDialog = false;
    _showVerificationDialog = false;
    _showVerificationSuccessDialog = false;
    _showAdminLoginDialog = false;
    notifyListeners();
  }

  // Navigation methods
  void navigateToServices(BuildContext context) {
    AppRoutes.navigateToServices(context);
  }

  void navigateToDashboard(BuildContext context) {
    AppRoutes.navigateToDashboard(context);
  }

  // Helper methods to safely handle context operations
  void _safePop(BuildContext context) {
    AppRoutes.safePop(context);
  }

  void _showSnackBar(BuildContext context, String message) {
    AppRoutes.showSnackBar(context, message);
  }

  void _log(String message) {
    // Replace with your preferred logging solution
    // For now, using debugPrint which is safe for production
    debugPrint(message);
  }

  // API methods
  Future<void> handleLogin(BuildContext context) async {
    _loginError = '';
    _loginUserIdError = '';
    _loginPasswordError = '';
    _isLoginLoading = true;
    _log('🔄 Setting login loading to true');
    notifyListeners();

    String userId = loginUserIdController.text.trim();
    String password = loginPasswordController.text.trim();

    bool isValid = true;
    if (userId.isEmpty) {
      _loginUserIdError = 'Please enter your User ID.';
      isValid = false;
    } else if (_loginRole == 'student' &&
        !RegExp(r'^\d{10}$').hasMatch(userId)) {
      _loginUserIdError = 'User ID must be exactly 10 digits.';
      isValid = false;
    } else if (_loginRole == 'admin' && userId.length > 10) {
      _loginUserIdError = 'Admin User ID cannot exceed 10 characters.';
      isValid = false;
    }

    if (password.isEmpty) {
      _loginPasswordError = 'Please enter your password.';
      isValid = false;
    }

    if (!isValid) {
      // Add a longer delay to show loading state before showing error
      _log('❌ Validation failed, waiting 1000ms before hiding loading');
      await Future.delayed(const Duration(milliseconds: 1000));
      _isLoginLoading = false;
      _log('🔄 Setting login loading to false after validation failure');
      notifyListeners();
      return;
    }

    try {
      _log('🔐 Starting login for userId=$_loginRole:$userId');
      final response = await _session.post(
        '${ApiConfig.currentBaseUrl}/auth/login',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'X-Requested-With': 'XMLHttpRequest',
        },
        body: {
          'user_id': userId,
          'password': password,
          if (_loginRole != null) 'role': _loginRole!,
        }.entries.map((e) => '${e.key}=${e.value}').join('&'),
      );

      _log('✅ Login Response Status: ${response.statusCode}');
      _log('📨 Login Response Body: ${response.body}');

      if (response.statusCode != 200) {
        _loginError =
            'Server error (${response.statusCode}). Please try again.';
        return;
      }

      final data = json.decode(response.body);
      final status = data['status'];
      final message = data['message'];
      final role = (_loginRole ?? '').toLowerCase();

      if (status == 'success') {
        _log('🎉 Login success for role=$role');
        if (context.mounted) {
          _safePop(context);
          _showSnackBar(context, 'Login successful!');
          if (role == 'student' || role == 'student') {
            navigateToDashboard(context);
          } else if (role == 'counselor') {
            AppRoutes.navigateToCounselorDashboard(context);
          } else if (role == 'admin') {
            AppRoutes.navigateToAdminDashboard(context);
          } else {
            // default to user dashboard if role ambiguous
            _log('ℹ️ Unknown role "$role". Defaulting to user dashboard.');
            navigateToDashboard(context);
          }
        }
      } else if (status == 'unverified') {
        _log('⚠️ Account unverified for userId=$userId');
        if (context.mounted) {
          _safePop(context);
          setShowVerificationDialog(
            true,
            message:
                message ??
                'Your account is not verified. Please enter the token to verify your account or resend the verification email.',
            role: _loginRole ?? 'student',
          );
        }
      } else {
        _log('❌ Login failed: ${message ?? 'Unknown error'}');
        _loginError =
            message ??
            'Invalid credentials. Please check your User ID and password.';
      }
    } catch (e) {
      _log('💥 Login Error: $e');
      _loginError =
          'Network error. Please check your connection and try again.';
    } finally {
      _isLoginLoading = false;
      notifyListeners();
    }
  }

  // Admin login method
  Future<void> handleAdminLogin(BuildContext context) async {
    _adminLoginError = '';
    _isAdminLoginLoading = true;
    notifyListeners();

    String adminUserId = adminUserIdController.text.trim();
    String adminPassword = adminPasswordController.text.trim();

    bool isValid = true;
    if (adminUserId.isEmpty) {
      _adminLoginError = 'Please enter your Admin ID.';
      isValid = false;
    }

    if (adminPassword.isEmpty) {
      _adminLoginError = 'Please enter your password.';
      isValid = false;
    }

    if (!isValid) {
      _isAdminLoginLoading = false;
      notifyListeners();
      return;
    }

    try {
      _log('🔐 Starting admin login for adminId=$adminUserId');
      final response = await _session.post(
        '${ApiConfig.currentBaseUrl}/auth/verify-admin',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'X-Requested-With': 'XMLHttpRequest',
        },
        body: {
          'user_id': adminUserId,
          'password': adminPassword,
        }.entries.map((e) => '${e.key}=${e.value}').join('&'),
      );

      _log('✅ Admin Login Response Status: ${response.statusCode}');
      _log('📨 Admin Login Response Body: ${response.body}');

      if (response.statusCode != 200) {
        _adminLoginError =
            'Server error (${response.statusCode}). Please try again.';
        return;
      }

      final data = json.decode(response.body);
      final status = data['status'];
      final message = data['message'];

      if (status == 'success') {
        _log('🎉 Admin login success');
        if (context.mounted) {
          _safePop(context);
          _showSnackBar(context, 'Admin login successful!');
          AppRoutes.navigateToAdminDashboard(context);
        }
      } else if (status == 'unverified') {
        _log('⚠️ Admin account unverified for adminId=$adminUserId');
        if (context.mounted) {
          _safePop(context);
          setShowVerificationDialog(
            true,
            message:
                message ??
                'Your admin account is not verified. Please enter the token to verify your account or resend the verification email.',
            role: 'admin',
          );
        }
      } else {
        _log('❌ Admin login failed: ${message ?? 'Unknown error'}');
        _adminLoginError = message ?? 'Invalid Admin ID or password.';
      }
    } catch (e) {
      _log('💥 Admin Login Error: $e');
      _adminLoginError =
          'Network error. Please check your connection and try again.';
    } finally {
      _isAdminLoginLoading = false;
      notifyListeners();
    }
  }

  Future<void> handleSignUp(BuildContext context) async {
    _signUpError = '';
    _signUpUserIdError = '';
    _signUpUsernameError = '';
    _signUpEmailError = '';
    _signUpPasswordError = '';
    _signUpConfirmPasswordError = '';
    _isSignUpLoading = true;
    notifyListeners();

    String userId = signUpUserIdController.text.trim();
    String username = signUpUsernameController.text.trim();
    String email = signUpEmailController.text.trim();
    String password = signUpPasswordController.text.trim();
    String confirmPassword = signUpConfirmPasswordController.text.trim();

    bool isValid = true;
    if (userId.isEmpty) {
      _signUpUserIdError = 'Please enter your User ID.';
      isValid = false;
    } else if (_signUpRole == 'student' &&
        !RegExp(r'^\d{10}$').hasMatch(userId)) {
      _signUpUserIdError = 'User ID must be exactly 10 digits.';
      isValid = false;
    }

    if (username.isEmpty) {
      _signUpUsernameError = 'Please enter your username.';
      isValid = false;
    }

    if (email.isEmpty ||
        !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      _signUpEmailError = 'Please enter a valid email.';
      isValid = false;
    }

    if (password.isEmpty || password.length < 8) {
      _signUpPasswordError = 'Password must be at least 8 characters.';
      isValid = false;
    }

    if (password != confirmPassword) {
      _signUpConfirmPasswordError = 'Passwords do not match.';
      isValid = false;
    }

    if (!_termsAccepted) {
      _signUpError = 'Please agree to the Terms and Conditions.';
      isValid = false;
    }

    if (!isValid) {
      // Add a longer delay to show loading state before showing error
      await Future.delayed(const Duration(milliseconds: 1000));
      _isSignUpLoading = false;
      notifyListeners();
      return;
    }

    try {
      final response = await _session.post(
        '${ApiConfig.currentBaseUrl}/auth/signup',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'X-Requested-With': 'XMLHttpRequest',
        },
        body: {
          'role': _signUpRole ?? 'student',
          'userId': userId,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
          'username': username,
        }.entries.map((e) => '${e.key}=${e.value}').join('&'),
      );

      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        signUpUserIdController.clear();
        signUpUsernameController.clear();
        signUpEmailController.clear();
        signUpPasswordController.clear();
        signUpConfirmPasswordController.clear();
        _termsAccepted = false;

        if (context.mounted) {
          _safePop(context);
          setShowVerificationDialog(
            true,
            message:
                data['message'] ??
                'A verification email has been sent to your registered email address. Please enter the token below to verify your account.',
            role: _signUpRole ?? 'student',
          );
        }
      } else {
        _signUpError = data['message'] ?? 'Sign up failed.';
      }
    } catch (e) {
      _signUpError = 'An error occurred. Please try again.';
    } finally {
      _isSignUpLoading = false;
      notifyListeners();
    }
  }

  Future<void> handleForgotPassword(BuildContext context) async {
    _forgotPasswordError = '';
    _forgotPasswordInputError = '';
    _isForgotPasswordLoading = true;
    notifyListeners();

    String input = forgotPasswordController.text.trim();

    if (input.isEmpty) {
      _forgotPasswordInputError = 'Please enter your email or user ID.';
      // Add a longer delay to show loading state before showing error
      await Future.delayed(const Duration(milliseconds: 1000));
      _isForgotPasswordLoading = false;
      notifyListeners();
      return;
    }

    try {
      _log('🚀 Starting forgot password for: $input');
      _forgotPasswordIdentifier = input;

      _session.clearCookies();

      final response = await _session.post(
        '${ApiConfig.currentBaseUrl}/forgot-password/send-code',
        headers: {
          'Content-Type': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
        body: json.encode({'input': input}),
      );

      _log('✅ Forgot Password Response Status: ${response.statusCode}');
      _log('📨 Forgot Password Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          _log('🎉 Reset code sent successfully');
          _log('🍪 Session after send-code: ${_session.cookies}');

          forgotPasswordController.clear();
          if (context.mounted) {
            _safePop(context);
            setShowCodeEntryDialog(true);
            _showSnackBar(context, 'Reset code sent! Check your email.');
          }
        } else {
          _log('❌ Backend error: ${data['message']}');
          _forgotPasswordError =
              data['message'] ?? 'Failed to send reset code.';
        }
      } else {
        _log('❌ HTTP Error: ${response.statusCode}');
        _forgotPasswordError =
            'Server error (${response.statusCode}). Please try again.';
      }
    } catch (e) {
      _log('💥 Forgot Password Error: $e');
      _forgotPasswordError = 'An error occurred. Please try again.';
    } finally {
      _log('🏁 Forgot Password process completed');
      _isForgotPasswordLoading = false;
      notifyListeners();
    }
  }

  Future<void> handleVerifyCode(BuildContext context) async {
    _codeEntryError = '';
    _resetCodeError = '';
    _isCodeEntryLoading = true;
    notifyListeners();

    String code = resetCodeController.text.trim();

    if (code.isEmpty) {
      _resetCodeError = 'Please enter the reset code.';
      // Add a longer delay to show loading state before showing error
      await Future.delayed(const Duration(milliseconds: 1000));
      _isCodeEntryLoading = false;
      notifyListeners();
      return;
    }

    try {
      _log('🔐 Verifying code: $code');
      _log('🍪 Session before verify-code: ${_session.cookies}');

      final response = await _session.post(
        '${ApiConfig.currentBaseUrl}/forgot-password/verify-code',
        headers: {
          'Content-Type': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
        body: json.encode({'code': code}),
      );

      _log('✅ Verify Code Response Status: ${response.statusCode}');
      _log('📨 Verify Code Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          _log('🎉 Code verified successfully');
          _log('🍪 Session after verify-code: ${_session.cookies}');
          _log('🍪 Has session: ${_session.hasSession}');

          _verifiedResetCode = code;
          resetCodeController.clear();
          if (context.mounted) {
            _safePop(context);
            setShowNewPasswordDialog(true);
            _showSnackBar(context, 'Code verified! Set your new password.');
          }
        } else {
          _log('❌ Code verification failed: ${data['message']}');
          _codeEntryError = data['message'] ?? 'Invalid code.';
        }
      } else {
        _log('❌ HTTP Error: ${response.statusCode}');
        _codeEntryError =
            'Server error (${response.statusCode}). Please try again.';
      }
    } catch (e) {
      _log('💥 Verify Code Error: $e');
      _codeEntryError = 'An error occurred. Please try again.';
    } finally {
      _log('🏁 Code verification process completed');
      _isCodeEntryLoading = false;
      notifyListeners();
    }
  }

  Future<void> handleSetNewPassword(BuildContext context) async {
    _newPasswordError = '';
    _newPasswordErrorField = '';
    _confirmNewPasswordError = '';
    _isNewPasswordLoading = true;
    notifyListeners();

    String password = newPasswordController.text.trim();
    String confirmPassword = confirmNewPasswordController.text.trim();

    bool isValid = true;
    if (password.isEmpty || password.length < 8) {
      _newPasswordErrorField = 'Password must be at least 8 characters.';
      isValid = false;
    }

    if (password != confirmPassword) {
      _confirmNewPasswordError = 'Passwords do not match.';
      isValid = false;
    }

    if (!isValid) {
      // Add a longer delay to show loading state before showing error
      await Future.delayed(const Duration(milliseconds: 1000));
      _isNewPasswordLoading = false;
      notifyListeners();
      return;
    }

    try {
      _log('🔑 Setting new password');
      _log('🍪 Session before set-password: ${_session.cookies}');
      _log('🍪 Has active session: ${_session.hasSession}');

      final response = await _session.post(
        '${ApiConfig.currentBaseUrl}/forgot-password/set-password',
        headers: {
          'Content-Type': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
        body: json.encode({
          'password': password,
          'code': _verifiedResetCode,
          'input': _forgotPasswordIdentifier,
        }),
      );

      _log('✅ Set Password Response Status: ${response.statusCode}');
      _log('📨 Set Password Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          _log('🎉 Password reset successfully');

          newPasswordController.clear();
          confirmNewPasswordController.clear();
          _verifiedResetCode = '';
          _forgotPasswordIdentifier = '';

          _session.clearCookies();

          if (context.mounted) {
            _safePop(context);
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Success'),
                content: const Text(
                  'Password reset successful! You can now log in with your new password.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => _safePop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        } else {
          _log('❌ Password reset failed: ${data['message']}');
          _newPasswordError = data['message'] ?? 'Failed to reset password.';

          if (data['message']?.toLowerCase().contains('session expired') ==
              true) {
            _session.clearCookies();
            _newPasswordError =
                'Session expired. Please start the reset process again.';
          }
        }
      } else {
        _log('❌ HTTP Error: ${response.statusCode}');
        _newPasswordError =
            'Server error (${response.statusCode}). Please try again.';
      }
    } catch (e) {
      _log('💥 Set Password Error: $e');
      _newPasswordError = 'An error occurred. Please try again.';
    } finally {
      _log('🏁 Password reset process completed');
      _isNewPasswordLoading = false;
      notifyListeners();
    }
  }

  Future<void> handleContact(BuildContext context) async {
    _contactError = '';
    _isContactLoading = true;
    notifyListeners();

    String name = contactNameController.text.trim();
    String email = contactEmailController.text.trim();
    String subject = contactSubjectController.text.trim();
    String message = contactMessageController.text.trim();

    bool isValid = true;
    if (name.isEmpty) {
      _contactError = 'Please enter your name.';
      isValid = false;
    }

    if (email.isEmpty ||
        !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      _contactError = 'Please enter a valid email.';
      isValid = false;
    }

    if (subject.isEmpty) {
      _contactError = 'Please enter a subject.';
      isValid = false;
    }

    if (message.isEmpty) {
      _contactError = 'Please enter a message.';
      isValid = false;
    }

    if (!isValid) {
      // Add a longer delay to show loading state before showing error
      await Future.delayed(const Duration(milliseconds: 1000));
      _isContactLoading = false;
      notifyListeners();
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.currentBaseUrl}/email/sendContactEmail'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'X-Requested-With': 'XMLHttpRequest',
        },
        body: {
          'name': name,
          'email': email,
          'subject': subject,
          'message': message,
        },
      );

      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        contactNameController.clear();
        contactEmailController.clear();
        contactSubjectController.clear();
        contactMessageController.clear();
        if (context.mounted) {
          _safePop(context);
          _showSnackBar(
            context,
            data['message'] ?? 'Message sent successfully!',
          );
        }
      } else {
        _contactError = data['message'] ?? 'Failed to send message.';
      }
    } catch (e) {
      _contactError = 'An error occurred. Please try again.';
    } finally {
      _isContactLoading = false;
      notifyListeners();
    }
  }

  Future<void> handleVerification(BuildContext context) async {
    _verificationError = '';
    _isVerificationLoading = true;
    notifyListeners();

    String token = verificationTokenController.text.trim().toUpperCase();

    if (token.isEmpty) {
      _verificationError = 'Please enter the verification token.';
      _isVerificationLoading = false;
      notifyListeners();
      return;
    }

    // Validate token: must be 6 characters, uppercase letters and/or numbers
    final tokenRegex = RegExp(r'^[A-Z0-9]{6}$');
    if (!tokenRegex.hasMatch(token)) {
      _verificationError = 'Invalid token. Enter 6 characters (A-Z, 0-9).';
      _isVerificationLoading = false;
      notifyListeners();
      return;
    }

    try {
      _log('Sending verification request for token: $token');

      final response = await _session.post(
        '${ApiConfig.currentBaseUrl}/verify-account',
        headers: {
          'Content-Type': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
        body: json.encode({'token': token}),
      );

      _log('Verification Response Status: ${response.statusCode}');
      _log('Verification Response Body: ${response.body}');

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        if (data['status'] == 'success') {
          _redirectUrl =
              data['redirect'] ?? '${ApiConfig.currentBaseUrl}/user/dashboard';
          if (context.mounted) {
            _safePop(context);
            setShowVerificationSuccessDialog(true);
          }
        } else {
          _verificationError = data['message'] ?? 'Verification failed.';
        }
      } else {
        if (response.statusCode == 400) {
          _verificationError = data['message'] ?? 'Invalid token.';
        } else if (response.statusCode == 404) {
          _verificationError =
              'Service temporarily unavailable. Please try again later.';
        } else {
          _verificationError =
              data['message'] ?? 'Verification failed. Please try again.';
        }
      }
    } catch (e) {
      _log('Verification Error: $e');
      _verificationError =
          'Network error. Please check your connection and try again.';
    } finally {
      _isVerificationLoading = false;
      notifyListeners();
    }
  }

  Future<void> handleResendVerification(BuildContext context) async {
    _verificationError = '';
    _isResendVerificationLoading = true;
    notifyListeners();

    String identifier = signUpEmailController.text.trim();

    if (identifier.isEmpty) {
      final result = await showDialog<String>(
        context: context,
        builder: (context) {
          String inputIdentifier = '';
          return AlertDialog(
            title: const Text('Resend Verification Email'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Please enter your registered email address or user ID:',
                ),
                const SizedBox(height: 15),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Email or User ID',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => inputIdentifier = value,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => _safePop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, inputIdentifier),
                child: const Text('Submit'),
              ),
            ],
          );
        },
      );

      if (result == null || result.isEmpty) {
        _isResendVerificationLoading = false;
        notifyListeners();
        return;
      }
      identifier = result;
    }

    try {
      _log('Resending verification for identifier: $identifier');

      final response = await _session.post(
        '${ApiConfig.currentBaseUrl}/resend-verification-email',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'X-Requested-With': 'XMLHttpRequest',
        },
        body: 'identifier=$identifier',
      );

      _log('Resend Verification Response: ${response.statusCode}');
      _log('Resend Verification Body: ${response.body}');

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        if (data['status'] == 'success') {
          _verificationMessage =
              data['message'] ??
              'Verification email sent successfully. Please check your inbox.';
          if (context.mounted) {
            _showSnackBar(
              context,
              data['message'] ?? 'Verification email sent successfully.',
            );
          }
        } else if (data['status'] == 'already_verified') {
          _verificationMessage =
              data['message'] ?? 'Account is already verified.';
          if (context.mounted) {
            _showSnackBar(
              context,
              data['message'] ?? 'Account is already verified.',
            );
            Future.delayed(const Duration(seconds: 2), () {
              if (context.mounted) {
                _safePop(context);
                setShowLoginDialog(true);
              }
            });
          }
        } else {
          _verificationError =
              data['message'] ?? 'Failed to resend verification email.';
        }
      } else {
        _verificationError =
            data['message'] ?? 'Failed to resend verification email.';
      }
    } catch (e) {
      _log('Resend Verification Error: $e');
      _verificationError = 'Network error. Please try again.';
    } finally {
      _isResendVerificationLoading = false;
      notifyListeners();
    }
  }

  void goToDashboard(BuildContext context) {
    if (context.mounted) {
      _safePop(context);
      _showSnackBar(
        context,
        'Verification successful! Welcome to your dashboard.',
      );
      navigateToDashboard(context);
      _log('Redirecting to: $_redirectUrl');
    }
  }

  void stayOnLandingPage(BuildContext context) {
    if (context.mounted) {
      _safePop(context);
    }
  }
}
