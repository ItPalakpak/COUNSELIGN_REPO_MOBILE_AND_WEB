import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/appointment_report.dart';
import '../../utils/session.dart';
import '../../api/config.dart';

class CounselorReportsViewModel extends ChangeNotifier {
  // State variables
  bool _isLoading = false;
  bool _isExporting = false;
  String? _error;
  AppointmentReport? _reportData;
  TimeRange _selectedTimeRange = TimeRange.weekly;
  AppointmentStatus _selectedStatus = AppointmentStatus.all;
  String _searchQuery = '';
  String? _selectedDate;
  List<AppointmentReportItem> _filteredAppointments = [];
  List<AppointmentReportItem> _allAppointments = [];

  // Getters
  bool get isLoading => _isLoading;
  bool get isExporting => _isExporting;
  String? get error => _error;
  AppointmentReport? get reportData => _reportData;
  TimeRange get selectedTimeRange => _selectedTimeRange;
  AppointmentStatus get selectedStatus => _selectedStatus;
  String get searchQuery => _searchQuery;
  String? get selectedDate => _selectedDate;
  List<AppointmentReportItem> get filteredAppointments => _filteredAppointments;
  List<AppointmentReportItem> get allAppointments => _allAppointments;

  // Statistics getters
  int get totalCompleted => _reportData?.totalCompleted ?? 0;
  int get totalApproved => _reportData?.totalApproved ?? 0;
  int get totalRejected => _reportData?.totalRejected ?? 0;
  int get totalPending => _reportData?.totalPending ?? 0;
  int get totalCancelled => _reportData?.totalCancelled ?? 0;

  // Chart data getters
  ChartData? get chartData {
    if (_reportData == null) return null;
    return ChartData(
      labels: _reportData!.labels,
      completed: _reportData!.completed,
      approved: _reportData!.approved,
      rejected: _reportData!.rejected,
      pending: _reportData!.pending,
      cancelled: _reportData!.cancelled,
    );
  }

  List<AppointmentPieChartData> get pieChartData {
    return [
      AppointmentPieChartData(
        'Completed',
        totalCompleted,
        const Color(0xFF0d6efd),
      ),
      AppointmentPieChartData(
        'Approved',
        totalApproved,
        const Color(0xFF198754),
      ),
      AppointmentPieChartData(
        'Rejected',
        totalRejected,
        const Color(0xFFdc3545),
      ),
      AppointmentPieChartData('Pending', totalPending, const Color(0xFFffc107)),
      AppointmentPieChartData(
        'Cancelled',
        totalCancelled,
        const Color(0xFF6c757d),
      ),
    ];
  }

  // Initialize and load data
  Future<void> initialize() async {
    await loadReportData();
  }

  // Load report data from API
  Future<void> loadReportData() async {
    _setLoading(true);
    _clearError();

    try {
      final session = Session();
      final url =
          '${ApiConfig.currentBaseUrl}/counselor/appointments/get_all_appointments?timeRange=${_selectedTimeRange.value}';

      debugPrint('Loading report data from: $url');

      final response = await session.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('Report data received: ${data.keys}');

        if (data['success'] == true || data['appointments'] != null) {
          _reportData = AppointmentReport.fromJson(data);
          _allAppointments = _reportData!.appointments;
          _applyFilters();
          debugPrint(
            'Report data loaded successfully: ${_allAppointments.length} appointments',
          );
        } else {
          throw Exception(data['message'] ?? 'Failed to load report data');
        }
      } else {
        throw Exception(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      debugPrint('Error loading report data: $e');
      _setError('Failed to load report data: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Update time range and reload data
  Future<void> updateTimeRange(TimeRange timeRange) async {
    if (_selectedTimeRange != timeRange) {
      _selectedTimeRange = timeRange;
      notifyListeners();
      await loadReportData();
    }
  }

  // Update status filter
  void updateStatusFilter(AppointmentStatus status) {
    _selectedStatus = status;
    _applyFilters();
    notifyListeners();
  }

  // Update search query
  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  // Update date filter
  void updateDateFilter(String? date) {
    _selectedDate = date;
    _applyFilters();
    notifyListeners();
  }

  // Apply all filters
  void _applyFilters() {
    List<AppointmentReportItem> filtered = List.from(_allAppointments);

    // Apply status filter
    if (_selectedStatus != AppointmentStatus.all) {
      filtered = filtered.where((appointment) {
        return appointment.status.toLowerCase() == _selectedStatus.value;
      }).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((appointment) {
        return appointment.userId.toLowerCase().contains(_searchQuery) ||
            appointment.studentName.toLowerCase().contains(_searchQuery) ||
            appointment.consultationType.toLowerCase().contains(_searchQuery) ||
            appointment.purpose.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // Apply date filter
    if (_selectedDate != null && _selectedDate!.isNotEmpty) {
      filtered = filtered.where((appointment) {
        return appointment.appointedDate.startsWith(_selectedDate!);
      }).toList();
    }

    // Sort appointments from oldest to newest
    filtered.sort((a, b) {
      final dateTimeA = '${a.appointedDate} ${a.appointedTime}';
      final dateTimeB = '${b.appointedDate} ${b.appointedTime}';
      return dateTimeA.compareTo(dateTimeB);
    });

    _filteredAppointments = filtered;
  }

  // Clear all filters
  void clearFilters() {
    _searchQuery = '';
    _selectedDate = null;
    _selectedStatus = AppointmentStatus.all;
    _applyFilters();
    notifyListeners();
  }

  // Export to PDF
  Future<void> exportToPDF(ExportFilters? filters) async {
    _setExporting(true);
    _clearError();

    try {
      final appointments = _getFilteredAppointmentsForExport(filters);
      final reportTitle = _getReportTitle();
      final counselorName = _reportData?.counselorName ?? 'Unknown Counselor';

      final pdf = pw.Document();

      // Add header with logo
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Row(
                  children: [
                    pw.Container(
                      width: 25,
                      height: 19,
                      decoration: pw.BoxDecoration(color: PdfColors.blue),
                      child: pw.Center(
                        child: pw.Text(
                          'C',
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 10),
                    pw.Text(
                      'Counselign - The USTP Guidance Counseling Sanctuary',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Divider(),
                pw.SizedBox(height: 10),

                // Report title
                pw.Center(
                  child: pw.Text(
                    '$reportTitle - Counselor: $counselorName',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),

                // Table
                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: const pw.FixedColumnWidth(60),
                    1: const pw.FixedColumnWidth(80),
                    2: const pw.FixedColumnWidth(60),
                    3: const pw.FixedColumnWidth(60),
                    4: const pw.FixedColumnWidth(80),
                    5: const pw.FixedColumnWidth(100),
                    6: const pw.FixedColumnWidth(60),
                    7: const pw.FlexColumnWidth(),
                  },
                  children: [
                    // Header row
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(color: PdfColors.blue),
                      children: [
                        _buildTableCell('User ID', isHeader: true),
                        _buildTableCell('Full Name', isHeader: true),
                        _buildTableCell('Date', isHeader: true),
                        _buildTableCell('Time', isHeader: true),
                        _buildTableCell('Type', isHeader: true),
                        _buildTableCell('Purpose', isHeader: true),
                        _buildTableCell('Status', isHeader: true),
                        _buildTableCell('Reason', isHeader: true),
                      ],
                    ),
                    // Data rows
                    ...appointments.map(
                      (appointment) => pw.TableRow(
                        children: [
                          _buildTableCell(appointment.userId),
                          _buildTableCell(appointment.studentName),
                          _buildTableCell(appointment.formattedDate),
                          _buildTableCell(appointment.appointedTime),
                          _buildTableCell(appointment.consultationType),
                          _buildTableCell(appointment.purpose),
                          _buildTableCell(appointment.status),
                          _buildTableCell(appointment.reason ?? ''),
                        ],
                      ),
                    ),
                  ],
                ),

                pw.SizedBox(height: 20),

                // Footer
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Confidential Document',
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(
                      'Prepared by the University Guidance Counseling Office',
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(
                      'Generated: ${DateTime.now().toLocal().toString().split('.')[0]}',
                      style: pw.TextStyle(fontSize: 8),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );

      // Save PDF
      final directory = await getApplicationDocumentsDirectory();
      final file = File(
        '${directory.path}/appointment_report_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      await file.writeAsBytes(await pdf.save());

      // Open PDF
      await OpenFile.open(file.path);
    } catch (e) {
      debugPrint('Error exporting PDF: $e');
      _setError('Failed to export PDF: $e');
    } finally {
      _setExporting(false);
    }
  }

  // Export to Excel (placeholder - Excel package has dependency conflicts)
  Future<void> exportToExcel(ExportFilters? filters) async {
    _setExporting(true);
    _clearError();

    try {
      // For now, show a message that Excel export is not available
      _setError(
        'Excel export is temporarily unavailable due to dependency conflicts. Please use PDF export instead.',
      );
    } catch (e) {
      debugPrint('Error exporting Excel: $e');
      _setError('Failed to export Excel: $e');
    } finally {
      _setExporting(false);
    }
  }

  // Helper methods
  List<AppointmentReportItem> _getFilteredAppointmentsForExport(
    ExportFilters? filters,
  ) {
    List<AppointmentReportItem> appointments = List.from(_filteredAppointments);

    if (filters != null) {
      // Apply additional export filters
      if (filters.startDate != null) {
        appointments = appointments.where((app) {
          return app.appointedDate.compareTo(filters.startDate!) >= 0;
        }).toList();
      }

      if (filters.endDate != null) {
        appointments = appointments.where((app) {
          return app.appointedDate.compareTo(filters.endDate!) <= 0;
        }).toList();
      }

      if (filters.studentId != null) {
        appointments = appointments.where((app) {
          return app.userId == filters.studentId;
        }).toList();
      }
    }

    return appointments;
  }

  String _getReportTitle() {
    switch (_selectedStatus) {
      case AppointmentStatus.approved:
        return 'Approved Consultation Records';
      case AppointmentStatus.rejected:
        return 'Rejected Consultation Records';
      case AppointmentStatus.completed:
        return 'Completed Consultation Records';
      case AppointmentStatus.cancelled:
        return 'Cancelled Consultation Records';
      default:
        return 'All Consultation Records';
    }
  }

  pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 10 : 8,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: isHeader ? PdfColors.white : PdfColors.black,
        ),
      ),
    );
  }

  // State management methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setExporting(bool exporting) {
    _isExporting = exporting;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
