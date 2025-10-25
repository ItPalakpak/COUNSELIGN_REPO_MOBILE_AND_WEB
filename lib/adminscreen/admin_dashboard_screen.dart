import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/admin_dashboard_viewmodel.dart';
import 'widgets/admin_header.dart';
import 'widgets/admin_footer.dart';
import 'widgets/messages_card.dart';
import 'widgets/appointments_card.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late AdminDashboardViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = AdminDashboardViewModel();
    _viewModel.initialize();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Column(
          children: [
            const AdminHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: _buildMainContent(context),
              ),
            ),
            const AdminFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : isTablet ? 20 : 24,
        vertical: isMobile ? 20 : 24,
      ),
      child: Column(
        children: [
          _buildProfileSection(context),
          SizedBox(height: isMobile ? 20 : 30),
          _buildDashboardCards(context),
        ],
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Consumer<AdminDashboardViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(isMobile ? 20 : 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.05 * 255).round()),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Profile Avatar
              GestureDetector(
                onTap: () => _navigateToAdminManagement(context),
                child: Container(
                  width: isMobile ? 70 : 90,
                  height: isMobile ? 70 : 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    image: DecorationImage(
                      image: AssetImage(viewModel.adminProfile?.profileImageUrl ?? 'Photos/UGC-Logo.png'),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.1 * 255).round()),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: viewModel.isLoadingProfile
                      ? const CircularProgressIndicator()
                      : null,
                ),
              ),

              SizedBox(width: isMobile ? 15 : 20),

              // Profile Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello! ${viewModel.adminProfile?.name ?? 'Admin'}',
                      style: TextStyle(
                        fontSize: isMobile ? 18 : 22,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF003366),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Last login: ${viewModel.lastLogin ?? 'Loading...'}',
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Announcement Icon
              IconButton(
                onPressed: () => _navigateToAnnouncements(context),
                icon: const Icon(
                  Icons.campaign,
                  color: Color(0xFF073C8A),
                  size: 24,
                ),
                tooltip: 'Manage Announcements',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadowColor: Colors.black.withAlpha((0.1 * 255).round()),
                  elevation: 2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDashboardCards(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              MessagesCard(),
              if (isMobile) const SizedBox(height: 20),
            ],
          ),
        ),
        if (!isMobile) const SizedBox(width: 20),
        Expanded(
          child: AppointmentsCard(),
        ),
      ],
    );
  }

  void _navigateToAdminManagement(BuildContext context) {
    Navigator.of(context).pushNamed('/admin/admins-management');
  }

  void _navigateToAnnouncements(BuildContext context) {
    Navigator.of(context).pushNamed('/admin/announcements');
  }
}