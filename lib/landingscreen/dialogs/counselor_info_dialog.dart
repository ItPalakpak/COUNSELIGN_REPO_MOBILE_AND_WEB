import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CounselorInfoDialog extends StatelessWidget {
  final TextEditingController counselorIdController;
  final TextEditingController nameController;
  final TextEditingController degreeController;
  final TextEditingController emailController;
  final TextEditingController contactController;
  final TextEditingController addressController;
  final TextEditingController birthdateController;
  final String? civilStatus;
  final String? sex;
  final ValueChanged<String?> onCivilStatusChanged;
  final ValueChanged<String?> onSexChanged;
  final String warning;
  final bool isLoading;
  final VoidCallback onSavePressed;
  final VoidCallback onCancelPressed;

  const CounselorInfoDialog({
    super.key,
    required this.counselorIdController,
    required this.nameController,
    required this.degreeController,
    required this.emailController,
    required this.contactController,
    required this.addressController,
    required this.birthdateController,
    required this.civilStatus,
    required this.sex,
    required this.onCivilStatusChanged,
    required this.onSexChanged,
    required this.warning,
    required this.isLoading,
    required this.onSavePressed,
    required this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Counselor Information'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: counselorIdController,
              decoration: const InputDecoration(labelText: 'Counselor ID'),
              readOnly: true,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: degreeController,
              decoration: const InputDecoration(
                labelText: 'Degree (e.g., RGC, RPm)',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              readOnly: true,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: contactController,
              decoration: const InputDecoration(
                labelText: 'Contact Number (09XXXXXXXXX)',
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Address'),
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: birthdateController,
              decoration: InputDecoration(
                labelText: 'Birthdate (YYYY-MM-DD, optional)',
                hintText: 'YYYY-MM-DD',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final now = DateTime.now();
                    final initial =
                        _parseYyyyMmDd(birthdateController.text) ??
                        DateTime(now.year - 18, now.month, now.day);
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: initial,
                      firstDate: DateTime(1900, 1, 1),
                      lastDate: now,
                    );
                    if (picked != null) {
                      final y = picked.year.toString().padLeft(4, '0');
                      final m = picked.month.toString().padLeft(2, '0');
                      final d = picked.day.toString().padLeft(2, '0');
                      birthdateController.text = '$y-$m-$d';
                    }
                  },
                ),
              ),
              keyboardType: TextInputType.datetime,
              inputFormatters: const [_YyyyMmDdFormatter()],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: civilStatus?.isEmpty == true
                        ? null
                        : civilStatus,
                    items: const [
                      DropdownMenuItem(value: '', child: Text('Select')),
                      DropdownMenuItem(value: 'Single', child: Text('Single')),
                      DropdownMenuItem(
                        value: 'Married',
                        child: Text('Married'),
                      ),
                      DropdownMenuItem(
                        value: 'Widowed',
                        child: Text('Widowed'),
                      ),
                      DropdownMenuItem(
                        value: 'Legally Separated',
                        child: Text('Legally Separated'),
                      ),
                      DropdownMenuItem(
                        value: 'Annulled',
                        child: Text('Annulled'),
                      ),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Civil Status (optional)',
                    ),
                    onChanged: onCivilStatusChanged,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: sex?.isEmpty == true ? null : sex,
                    items: const [
                      DropdownMenuItem(value: '', child: Text('Select')),
                      DropdownMenuItem(value: 'Male', child: Text('Male')),
                      DropdownMenuItem(value: 'Female', child: Text('Female')),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Sex (optional)',
                    ),
                    onChanged: onSexChanged,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (warning.isNotEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(warning, style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : onCancelPressed,
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: isLoading ? null : onSavePressed,
          child: isLoading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save Information'),
        ),
      ],
    );
  }
}

DateTime? _parseYyyyMmDd(String input) {
  final parts = input.split('-');
  if (parts.length != 3) return null;
  final y = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  final d = int.tryParse(parts[2]);
  if (y == null || m == null || d == null) return null;
  try {
    return DateTime(y, m, d);
  } catch (_) {
    return null;
  }
}

class _YyyyMmDdFormatter extends TextInputFormatter {
  const _YyyyMmDdFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Keep only digits
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length && i < 8; i++) {
      buffer.write(digits[i]);
      if (i == 3 || i == 5) {
        buffer.write('-');
      }
    }

    final formatted = buffer.toString();

    // Place cursor at the end of the new string
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
