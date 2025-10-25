import 'package:flutter/material.dart';
import '../../widgets/app_header.dart';
import '../../widgets/bottom_navigation_bar.dart';

class CounselorScreenWrapper extends StatefulWidget {
  final Widget child;
  final int currentBottomNavIndex;
  final ValueChanged<int>? onBottomNavTap;

  const CounselorScreenWrapper({
    super.key,
    required this.child,
    this.currentBottomNavIndex = 0,
    this.onBottomNavTap,
  });

  @override
  State<CounselorScreenWrapper> createState() => _CounselorScreenWrapperState();
}

class _CounselorScreenWrapperState extends State<CounselorScreenWrapper> {
  bool _isDrawerOpen = false;

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  void _closeDrawer() {
    setState(() {
      _isDrawerOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppHeader(onMenu: _toggleDrawer),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: widget.child,
          ),
          // Drawer overlay
          if (_isDrawerOpen)
            GestureDetector(
              onTap: _closeDrawer,
              child: Container(
                color: const Color.fromRGBO(0, 0, 0, 0.5),
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          // Modern navigation drawer matching student dashboard design
          if (_isDrawerOpen)
            Positioned(
              top: 0,
              right: 0,
              child: Transform.translate(
                offset: const Offset(0, 0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  width: 320,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF060E57),
                        Color(0xFF0A1875),
                        Color(0xFF1E3A8A),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF060E57).withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(-4, 0),
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: const Color(0xFF060E57).withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(-2, 0),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header with modern styling
                      Container(
                        padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white.withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Counselign',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Counselor Menu',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.white.withValues(
                                            alpha: 0.7,
                                          ),
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                onPressed: _closeDrawer,
                                padding: const EdgeInsets.all(8),
                              ),
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
                              icon: Icons.campaign_rounded,
                              title: 'Announcements',
                              onTap: () {
                                _closeDrawer();
                                Navigator.of(context).pushReplacementNamed(
                                  '/counselor/announcements',
                                );
                              },
                            ),
                            _buildMenuItem(
                              icon: Icons.person_rounded,
                              title: 'Profile',
                              onTap: () {
                                _closeDrawer();
                                Navigator.of(
                                  context,
                                ).pushReplacementNamed('/counselor/profile');
                              },
                            ),

                            const SizedBox(height: 16),

                            // Divider with modern styling
                            Container(
                              height: 1,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.white.withValues(alpha: 0.2),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            _buildMenuItem(
                              icon: Icons.logout_rounded,
                              title: 'Log Out',
                              onTap: () {
                                _closeDrawer();
                                Navigator.of(context).pushReplacementNamed('/');
                              },
                              isDestructive: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: ModernBottomNavigationBar(
        currentIndex: widget.currentBottomNavIndex,
        onTap:
            widget.onBottomNavTap ??
            (int index) {
              // Default navigation logic for counselors
              switch (index) {
                case 0: // Home - Dashboard
                  Navigator.of(
                    context,
                  ).pushReplacementNamed('/counselor/dashboard');
                  break;
                case 1: // Scheduled Appointments
                  Navigator.of(
                    context,
                  ).pushReplacementNamed('/counselor/appointments/scheduled');
                  break;
                case 2: // Follow-up Sessions
                  Navigator.of(
                    context,
                  ).pushReplacementNamed('/counselor/follow-up');
                  break;
              }
            },
        isStudent: false,
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDestructive
                        ? Colors.red.withValues(alpha: 0.2)
                        : Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: isDestructive ? Colors.red[300] : Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isDestructive ? Colors.red[300] : Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDestructive
                      ? Colors.red[300]
                      : Colors.white.withValues(alpha: 0.6),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
