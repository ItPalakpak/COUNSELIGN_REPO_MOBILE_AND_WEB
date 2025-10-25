import 'package:flutter/material.dart';

class AdminHeader extends StatelessWidget {
  const AdminHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

    return Container(
      color: const Color(0xFF060E57),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : isTablet ? 20 : 24,
        vertical: isMobile ? 12 : 16,
      ),
      child: Row(
        children: [
          // Logo and title
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'Photos/UGC-Logo.png',
                  width: isMobile ? 32 : isTablet ? 36 : 40,
                  height: isMobile ? 32 : isTablet ? 36 : 40,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: isMobile ? 32 : isTablet ? 36 : 40,
                      height: isMobile ? 32 : isTablet ? 36 : 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.admin_panel_settings,
                        color: const Color(0xFF060E57),
                        size: isMobile ? 16 : isTablet ? 18 : 20,
                      ),
                    );
                  },
                ),
                SizedBox(width: isMobile ? 8 : 12),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'University Guidance Counseling',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 18 : isTablet ? 20 : 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Logout button
          if (!isMobile || screenWidth > 400) ...[
            ElevatedButton(
              onPressed: () => _logout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF060E57),
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 12 : 16,
                  vertical: isMobile ? 8 : 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.logout,
                    size: isMobile ? 16 : 18,
                  ),
                  SizedBox(width: isMobile ? 4 : 6),
                  Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    // Navigate to login screen
    Navigator.of(context).pushReplacementNamed('/');
  }
}