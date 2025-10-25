import 'package:flutter/material.dart';

class CounselorNavigationDrawer extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onClose;
  final VoidCallback onNavigateToAnnouncements;
  final VoidCallback onNavigateToProfile;
  final VoidCallback onLogout;

  const CounselorNavigationDrawer({
    super.key,
    required this.isOpen,
    required this.onClose,
    required this.onNavigateToAnnouncements,
    required this.onNavigateToProfile,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      top: 0,
      right: isOpen ? 0 : -280,
      width: 280,
      height: MediaQuery.of(context).size.height,
      child: Container(
        color: const Color(0xFF060E57),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.white24, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Counselor Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Menu items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  _buildMenuItem(
                    icon: Icons.campaign,
                    title: 'Announcements',
                    onTap: () {
                      onClose();
                      onNavigateToAnnouncements();
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.person,
                    title: 'Profile',
                    onTap: () {
                      onClose();
                      onNavigateToProfile();
                    },
                  ),
                  const Divider(color: Colors.white24, height: 32),
                  _buildMenuItem(
                    icon: Icons.logout,
                    title: 'Log Out',
                    onTap: () {
                      onClose();
                      onLogout();
                    },
                    color: Colors.redAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.white),
      title: Text(
        title,
        style: TextStyle(color: color ?? Colors.white, fontSize: 16),
      ),
      onTap: onTap,
      hoverColor: Colors.white.withAlpha((0.1 * 255).round()),
    );
  }
}
