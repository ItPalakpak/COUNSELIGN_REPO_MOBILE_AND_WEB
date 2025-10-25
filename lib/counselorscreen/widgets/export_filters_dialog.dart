import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/appointment_report.dart';

class ExportFiltersDialog extends StatefulWidget {
  final Function(ExportFilters?) onExportPDF;
  final Function(ExportFilters?) onExportExcel;
  final bool isExporting;

  const ExportFiltersDialog({
    super.key,
    required this.onExportPDF,
    required this.onExportExcel,
    required this.isExporting,
  });

  @override
  State<ExportFiltersDialog> createState() => _ExportFiltersDialogState();
}

class _ExportFiltersDialogState extends State<ExportFiltersDialog> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _studentController = TextEditingController();

  String? _selectedCourse;
  String? _selectedYearLevel;

  final List<String> _courses = [
    'BSIT',
    'BSABE',
    'BSEnE',
    'BSHM',
    'BFPT',
    'BSA',
    'BTHM',
    'BSSW',
    'BSAF',
    'BTLED',
    'DAT-BAT',
  ];

  final List<String> _yearLevels = ['I', 'II', 'III', 'IV'];

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _studentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(
            FontAwesomeIcons.filter,
            color: Color(0xFF0d6efd),
            size: 20,
          ),
          const SizedBox(width: 8),
          const Text('Export Filters'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Range Filters
            const Text(
              'Date Range',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _startDateController,
                    decoration: const InputDecoration(
                      labelText: 'Start Date',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    readOnly: true,
                    onTap: () =>
                        _selectDate(_startDateController, 'Start Date'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _endDateController,
                    decoration: const InputDecoration(
                      labelText: 'End Date',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(_endDateController, 'End Date'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Leave dates empty to export all appointments from the selected status tab.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),

            // Additional Filters
            const Text(
              'Additional Filters',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _studentController,
                    decoration: const InputDecoration(
                      labelText: 'Student ID',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedCourse,
                    decoration: const InputDecoration(
                      labelText: 'Course',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All Courses'),
                      ),
                      ..._courses.map(
                        (course) => DropdownMenuItem(
                          value: course,
                          child: Text(course),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCourse = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedYearLevel,
              decoration: const InputDecoration(
                labelText: 'Year Level',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('All Year Levels'),
                ),
                ..._yearLevels.map(
                  (year) => DropdownMenuItem(value: year, child: Text(year)),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedYearLevel = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _clearAllFilters,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.clear_all, size: 16),
              SizedBox(width: 4),
              Text('Clear All'),
            ],
          ),
        ),
        TextButton(
          onPressed: _clearDateRange,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calendar_today, size: 16),
              SizedBox(width: 4),
              Text('Clear Dates'),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: widget.isExporting ? null : () => _export('PDF'),
          icon: const Icon(Icons.picture_as_pdf, size: 16),
          label: const Text('Export PDF'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0d6efd),
            foregroundColor: Colors.white,
          ),
        ),
        ElevatedButton.icon(
          onPressed: widget.isExporting ? null : () => _export('Excel'),
          icon: const Icon(Icons.table_chart, size: 16),
          label: const Text('Export Excel'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF198754),
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(
    TextEditingController controller,
    String label,
  ) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      controller.text =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }

  void _clearAllFilters() {
    setState(() {
      _startDateController.clear();
      _endDateController.clear();
      _studentController.clear();
      _selectedCourse = null;
      _selectedYearLevel = null;
    });
  }

  void _clearDateRange() {
    setState(() {
      _startDateController.clear();
      _endDateController.clear();
    });
  }

  void _export(String type) {
    final filters = ExportFilters(
      startDate: _startDateController.text.isNotEmpty
          ? _startDateController.text
          : null,
      endDate: _endDateController.text.isNotEmpty
          ? _endDateController.text
          : null,
      studentId: _studentController.text.isNotEmpty
          ? _studentController.text
          : null,
      course: _selectedCourse,
      yearLevel: _selectedYearLevel,
    );

    if (type == 'PDF') {
      widget.onExportPDF(filters);
    } else {
      widget.onExportExcel(filters);
    }

    Navigator.pop(context);
  }
}
