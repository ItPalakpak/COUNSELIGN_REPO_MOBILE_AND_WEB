import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'state/counselor_reports_viewmodel.dart';
import 'models/appointment_report.dart';
import 'widgets/appointment_report_card.dart';
import 'widgets/export_filters_dialog.dart';
import 'widgets/counselor_screen_wrapper.dart';

class CounselorReportsScreen extends StatefulWidget {
  const CounselorReportsScreen({super.key});

  @override
  State<CounselorReportsScreen> createState() => _CounselorReportsScreenState();
}

class _CounselorReportsScreenState extends State<CounselorReportsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  Timer? _searchTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _dateController.dispose();
    _searchTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final viewModel = CounselorReportsViewModel();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          viewModel.initialize();
        });
        return viewModel;
      },
      child: CounselorScreenWrapper(
        currentBottomNavIndex: 0,
        child: Consumer<CounselorReportsViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${viewModel.error}',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => viewModel.initialize(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReportHeader(viewModel),
                  const SizedBox(height: 20),
                  _buildTimeRangeFilter(viewModel),
                  const SizedBox(height: 20),
                  _buildStatisticsSummary(viewModel),
                  const SizedBox(height: 20),
                  _buildChartsSection(viewModel),
                  const SizedBox(height: 20),
                  _buildAppointmentsSection(viewModel),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildReportHeader(CounselorReportsViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                FontAwesomeIcons.chartLine,
                color: Color(0xFF0d6efd),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Appointment Reports',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0d6efd),
                      ),
                    ),
                    Text(
                      'Counselor: ${viewModel.reportData?.counselorName ?? 'Loading...'}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'View and analyze your appointment statistics',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeFilter(CounselorReportsViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            FontAwesomeIcons.calendar,
            color: Color(0xFF0d6efd),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<TimeRange>(
              initialValue: viewModel.selectedTimeRange,
              decoration: const InputDecoration(
                labelText: 'Report Period',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: TimeRange.values.map((range) {
                return DropdownMenuItem(
                  value: range,
                  child: Text(range.displayName),
                );
              }).toList(),
              onChanged: (TimeRange? value) {
                if (value != null) {
                  viewModel.updateTimeRange(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSummary(CounselorReportsViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistics Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0d6efd),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildStatCard(
                'Completed',
                viewModel.totalCompleted,
                FontAwesomeIcons.circleCheck,
                const Color(0xFF0d6efd),
              ),
              _buildStatCard(
                'Approved',
                viewModel.totalApproved,
                FontAwesomeIcons.thumbsUp,
                const Color(0xFF198754),
              ),
              _buildStatCard(
                'Rejected',
                viewModel.totalRejected,
                FontAwesomeIcons.circleXmark,
                const Color(0xFFdc3545),
              ),
              _buildStatCard(
                'Pending',
                viewModel.totalPending,
                FontAwesomeIcons.clock,
                const Color(0xFFffc107),
              ),
              _buildStatCard(
                'Cancelled',
                viewModel.totalCancelled,
                FontAwesomeIcons.ban,
                const Color(0xFF6c757d),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, int count, IconData icon, Color color) {
    return Container(
      width: (MediaQuery.of(context).size.width - 80) / 2,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection(CounselorReportsViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Data Visualization',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0d6efd),
            ),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final isMobile = screenWidth < 600;

              if (isMobile) {
                return Column(
                  children: [
                    _buildTrendChart(viewModel),
                    const SizedBox(height: 20),
                    _buildPieChart(viewModel),
                  ],
                );
              } else {
                return Row(
                  children: [
                    Expanded(flex: 2, child: _buildTrendChart(viewModel)),
                    const SizedBox(width: 20),
                    Expanded(flex: 1, child: _buildPieChart(viewModel)),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTrendChart(CounselorReportsViewModel viewModel) {
    final chartData = viewModel.chartData;
    if (chartData == null) {
      return const Center(child: Text('No chart data available'));
    }

    // Determine Y-axis max value based on time range (matching web version)
    double maxY;
    double interval;
    switch (viewModel.selectedTimeRange) {
      case TimeRange.daily:
        maxY = 8;
        interval = 2;
        break;
      case TimeRange.weekly:
        maxY = 40;
        interval = 10;
        break;
      case TimeRange.monthly:
        maxY = 100;
        interval = 20;
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              FontAwesomeIcons.chartLine,
              color: Color(0xFF0d6efd),
              size: 16,
            ),
            const SizedBox(width: 8),
            const Text(
              'Appointment Trends',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 400,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: chartData.labels.length * 60.0,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    drawHorizontalLine: true,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.black.withValues(alpha: 0.1),
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.black.withValues(alpha: 0.1),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: interval,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < chartData.labels.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Transform.rotate(
                                angle: -0.785398, // 45 degrees
                                child: Text(
                                  chartData.labels[value.toInt()],
                                  style: const TextStyle(fontSize: 9),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.2),
                    ),
                  ),
                  minX: 0,
                  maxX: (chartData.labels.length - 1).toDouble(),
                  minY: 0,
                  maxY: maxY,
                  lineBarsData: [
                    _buildLineChartBarData(
                      chartData.completed,
                      const Color(0xFF0d6efd),
                    ),
                    _buildLineChartBarData(
                      chartData.approved,
                      const Color(0xFF198754),
                    ),
                    _buildLineChartBarData(
                      chartData.rejected,
                      const Color(0xFFdc3545),
                    ),
                    _buildLineChartBarData(
                      chartData.pending,
                      const Color(0xFFffc107),
                    ),
                    _buildLineChartBarData(
                      chartData.cancelled,
                      const Color(0xFF6c757d),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          final flSpot = barSpot;
                          return LineTooltipItem(
                            '${flSpot.y.toInt()}',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Legend
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _buildLegendItem('Completed', const Color(0xFF0d6efd)),
            _buildLegendItem('Approved', const Color(0xFF198754)),
            _buildLegendItem('Rejected', const Color(0xFFdc3545)),
            _buildLegendItem('Pending', const Color(0xFFffc107)),
            _buildLegendItem('Cancelled', const Color(0xFF6c757d)),
          ],
        ),
      ],
    );
  }

  LineChartBarData _buildLineChartBarData(List<int> data, Color color) {
    return LineChartBarData(
      spots: data
          .asMap()
          .entries
          .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
          .toList(),
      isCurved: true,
      color: color,
      barWidth: 4,
      curveSmoothness: 0.4,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 4,
            color: color,
            strokeWidth: 2,
            strokeColor: Colors.white,
          );
        },
      ),
      belowBarData: BarAreaData(show: false),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildPieChart(CounselorReportsViewModel viewModel) {
    final pieData = viewModel.pieChartData;
    if (pieData.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isMobile = screenWidth < 600;

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.chartPie,
                    color: Color(0xFF0d6efd),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Status Distribution',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 30,
                        sections: pieData.map((data) {
                          return PieChartSectionData(
                            color: data.color,
                            value: data.value.toDouble(),
                            title: data.value > 0 ? '${data.value}' : '',
                            radius: 40,
                            titleStyle: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: pieData
                          .map(
                            (data) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: data.color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      data.label,
                                      style: const TextStyle(fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.chartPie,
                    color: Color(0xFF0d6efd),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Status Distribution',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: pieData.map((data) {
                      return PieChartSectionData(
                        color: data.color,
                        value: data.value.toDouble(),
                        title: '${data.value}',
                        radius: 50,
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...pieData.map(
                (data) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: data.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(data.label, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildAppointmentsSection(CounselorReportsViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'List of All Your Appointments',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0d6efd),
            ),
          ),
          const SizedBox(height: 16),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: const Color(0xFF0d6efd),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFF0d6efd),
            onTap: (index) {
              final status = AppointmentStatus.values[index];
              viewModel.updateStatusFilter(status);
            },
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Follow-up'),
              Tab(text: 'Approved'),
              Tab(text: 'Rejected'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
          const SizedBox(height: 16),
          _buildSearchAndFilterControls(viewModel),
          const SizedBox(height: 16),
          _buildAppointmentsList(viewModel),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterControls(CounselorReportsViewModel viewModel) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search appointments...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                onChanged: (value) {
                  _searchTimer?.cancel();
                  _searchTimer = Timer(const Duration(milliseconds: 300), () {
                    viewModel.updateSearchQuery(value);
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _dateController,
                decoration: const InputDecoration(
                  hintText: 'Filter by month',
                  prefixIcon: Icon(Icons.calendar_month),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    final monthString =
                        '${date.year}-${date.month.toString().padLeft(2, '0')}';
                    _dateController.text = monthString;
                    viewModel.updateDateFilter(monthString);
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showExportFiltersDialog(viewModel, 'PDF'),
                icon: const Icon(FontAwesomeIcons.filePdf, size: 16),
                label: const Text('Export PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0d6efd),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showExportFiltersDialog(viewModel, 'Excel'),
                icon: const Icon(FontAwesomeIcons.fileExcel, size: 16),
                label: const Text('Export Excel'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF198754),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAppointmentsList(CounselorReportsViewModel viewModel) {
    final appointments = viewModel.filteredAppointments;

    if (appointments.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(Icons.info_outline, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No appointments found.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return AppointmentReportCard(
          appointment: appointment,
          onTap: () => _showAppointmentDetails(appointment),
        );
      },
    );
  }

  void _showExportFiltersDialog(
    CounselorReportsViewModel viewModel,
    String exportType,
  ) {
    showDialog(
      context: context,
      builder: (context) => ExportFiltersDialog(
        exportType: exportType,
        onExportPDF: (filters) => viewModel.exportToPDF(filters),
        onExportExcel: (filters) => viewModel.exportToExcel(filters),
        isExporting: viewModel.isExporting,
      ),
    );
  }

  void _showAppointmentDetails(AppointmentReportItem appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Appointment Details - ${appointment.userId}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Student Name', appointment.studentName),
              _buildDetailRow('Date', appointment.formattedDate),
              _buildDetailRow('Time', appointment.appointedTime),
              if (appointment.methodType != null &&
                  appointment.methodType!.isNotEmpty)
                _buildDetailRow('Method Type', appointment.methodType!),
              _buildDetailRow(
                'Consultation Type',
                appointment.consultationType,
              ),
              _buildDetailRow('Session Type', appointment.sessionTypeDisplay),
              _buildDetailRow('Purpose', appointment.purpose),
              _buildDetailRow('Counselor', appointment.counselorName),
              _buildDetailRow('Status', appointment.status),
              if (appointment.reason != null)
                _buildDetailRow('Reason', appointment.reason!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
