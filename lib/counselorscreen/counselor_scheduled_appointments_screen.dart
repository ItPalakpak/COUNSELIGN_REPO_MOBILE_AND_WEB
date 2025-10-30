import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/counselor_scheduled_appointments_viewmodel.dart';
import 'widgets/counselor_screen_wrapper.dart';
import 'widgets/appointments_cards.dart';
import 'widgets/weekly_schedule.dart';
import 'widgets/mini_calendar.dart';
import 'widgets/cancellation_reason_dialog.dart';
import 'models/scheduled_appointment.dart';

class CounselorScheduledAppointmentsScreen extends StatefulWidget {
  const CounselorScheduledAppointmentsScreen({super.key});

  @override
  State<CounselorScheduledAppointmentsScreen> createState() =>
      _CounselorScheduledAppointmentsScreenState();
}

class _CounselorScheduledAppointmentsScreenState
    extends State<CounselorScheduledAppointmentsScreen> {
  late CounselorScheduledAppointmentsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = CounselorScheduledAppointmentsViewModel();
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
      child: CounselorScreenWrapper(
        currentBottomNavIndex: 1, // Scheduled Appointments (index 1)
        child: _buildMainContent(context),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile
            ? 16
            : isTablet
            ? 20
            : 24,
        vertical: isMobile ? 16 : 20,
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: isMobile ? 20 : 30),
              _buildContent(context, isMobile, isTablet, isDesktop),
            ],
          ),
          // Floating toggle button (calendar/schedules) - positioned below header
          Positioned(
            top: -5, // 10-20px below header
            right: 0,
            child: ElevatedButton(
              onPressed: () {
                _showSchedulesModal(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF060E57),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 4,
              ),
              child: const Icon(Icons.calendar_month, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.calendar_today, color: Color(0xFF060E57), size: 24),
        const SizedBox(width: 12),
        const Text(
          'Consultation Schedule Queries',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF060E57),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    bool isMobile,
    bool isTablet,
    bool isDesktop,
  ) {
    return Consumer<CounselorScheduledAppointmentsViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return _buildLoadingState();
        }

        if (viewModel.error != null) {
          return _buildErrorState(viewModel.error!);
        }

        // Always show appointments section only - sidebar is now a modal
        return _buildAppointmentsSection(context, viewModel);
      },
    );
  }

  Widget _buildLoadingState() {
    return const SizedBox(
      height: 200,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF060E57)),
              ),
              SizedBox(height: 16),
              Text(
                'Loading appointments...',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return SizedBox(
      height: 300, // Increased height to accommodate all content
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading appointments',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error,
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _viewModel.refresh(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF060E57),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Retry'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentsSection(
    BuildContext context,
    CounselorScheduledAppointmentsViewModel viewModel,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7FBFF),
        border: Border.all(color: const Color(0xFFCFE1EF)),
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (viewModel.appointments.isEmpty)
            _buildEmptyAppointmentsState()
          else
            AppointmentsCards(
              appointments: viewModel.appointments,
              onUpdateStatus: (appointment, status) =>
                  _handleUpdateStatus(appointment, status),
              onCancelAppointment: (appointment) =>
                  _handleCancelAppointment(appointment),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyAppointmentsState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: const Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Icon(Icons.info_outline, size: 48, color: Colors.blue),
              SizedBox(height: 16),
              Text(
                'No scheduled appointments found.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSchedulesModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Modal header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF060E57),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Weekly Schedules & Calendar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            // Modal content - using viewModel directly instead of Consumer
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    WeeklySchedule(schedule: _viewModel.counselorSchedule),
                    const SizedBox(height: 24),
                    MiniCalendar(
                      viewModel: _viewModel,
                      onDateSelected: (date) {
                        debugPrint('Selected date: $date');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleUpdateStatus(
    CounselorScheduledAppointment appointment,
    String status,
  ) async {
    try {
      await _viewModel.updateAppointmentStatus(
        appointment.id.toString(),
        status,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Appointment ${status.toLowerCase()} successfully'),
            backgroundColor: status == 'completed' ? Colors.green : Colors.blue,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update appointment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleCancelAppointment(
    CounselorScheduledAppointment appointment,
  ) async {
    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (context) => CancellationReasonDialog(
        appointmentId: appointment.id.toString(),
        studentName: appointment.studentName,
        onConfirm: (reason) async {
          try {
            await _viewModel.updateAppointmentStatus(
              appointment.id.toString(),
              'cancelled',
              rejectionReason: reason,
            );

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Appointment cancelled successfully! An email notification has been sent to the user.',
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } catch (e) {
            // Re-throw the error so the dialog can handle it
            rethrow;
          }
        },
      ),
    );
  }
}
