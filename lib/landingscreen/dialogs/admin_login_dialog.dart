import 'package:flutter/material.dart';
import '../../utils/async_button.dart';

class AdminLoginDialog extends StatefulWidget {
  final TextEditingController adminUserIdController;
  final TextEditingController adminPasswordController;
  final String error;
  final bool isLoading;
  final VoidCallback onAdminLoginPressed;
  final VoidCallback onBackToLoginPressed;

  const AdminLoginDialog({
    super.key,
    required this.adminUserIdController,
    required this.adminPasswordController,
    required this.error,
    required this.isLoading,
    required this.onAdminLoginPressed,
    required this.onBackToLoginPressed,
  });

  @override
  State<AdminLoginDialog> createState() => _AdminLoginDialogState();
}

class _AdminLoginDialogState extends State<AdminLoginDialog>
    with SingleTickerProviderStateMixin {
  bool passwordVisible = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 400,
        ),
        child: Stack(
        children: [
          // Close Button
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.grey),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      const Text(
                        'Admin Verification',
                        style: TextStyle(
                          color: Color(0xFF0D6EFD),
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Admin User ID
                      TextField(
                        controller: widget.adminUserIdController,
                        decoration: InputDecoration(
                          labelText: 'Admin ID',
                          hintText: 'Enter your Admin ID',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF86B7FE),
                            ),
                          ),
                        ),
                        maxLength: 10,
                      ),
                      const SizedBox(height: 15),

                      // Admin Password
                      TextField(
                        controller: widget.adminPasswordController,
                        obscureText: !passwordVisible,
                        decoration: InputDecoration(
                          labelText: 'Enter admin password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF86B7FE),
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () => setState(
                              () => passwordVisible = !passwordVisible,
                            ),
                          ),
                        ),
                      ),

                      // Error message
                      if (widget.error.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          widget.error,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),

                      // Admin Login Button
                      AsyncButton(
                        onPressed: widget.onAdminLoginPressed,
                        isLoading: widget.isLoading,
                        child: const Text(
                          'Continue to Admin',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Back to Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: widget.onBackToLoginPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: const Color(0xFF6C757D),
                            side: const BorderSide(color: Color(0xFFDEE2E6)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Back to Login',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
