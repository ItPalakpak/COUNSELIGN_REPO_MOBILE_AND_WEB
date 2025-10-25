import 'package:flutter/material.dart';

Widget buildVerificationSuccessDialog({
  required BuildContext context,
  required String role,
  required VoidCallback onGoToDashboardPressed,
  required VoidCallback onStayPressed,
}) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 400,
        ),
        child: Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
      constraints: const BoxConstraints(maxWidth: 500),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Account Verification',
                  style: TextStyle(
                    color: Color(0xFF0D6EFD),
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Account verified successfully. You can now log in.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),

                // Buttons responsive layout
                LayoutBuilder(
                  builder: (context, constraints) {
                    bool isMobile = constraints.maxWidth < 576;
                    if (isMobile) {
                      return Column(
                        children: [
                          ElevatedButton(
                            onPressed: onGoToDashboardPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0D6EFD),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            child: const Text('Go to Dashboard'),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton(
                            onPressed: onStayPressed,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.grey),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            child: const Text('Stay'),
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: onGoToDashboardPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0D6EFD),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              minimumSize: const Size(150, 48),
                            ),
                            child: const Text('Go to Dashboard'),
                          ),
                          const SizedBox(width: 10),
                          OutlinedButton(
                            onPressed: onStayPressed,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.grey),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              minimumSize: const Size(150, 48),
                            ),
                            child: const Text('Stay'),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    ),
  );
}
