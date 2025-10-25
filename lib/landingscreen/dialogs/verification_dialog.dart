import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/async_button.dart';

Widget buildVerificationDialog({
  required BuildContext context,
  required TextEditingController tokenController,
  required String message,
  required String error,
  required bool isLoading,
  required bool isResendLoading,
  required VoidCallback onVerifyPressed,
  required VoidCallback onResendPressed,
}) {
  return Dialog(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
        constraints: const BoxConstraints(maxWidth: 500),
        child: Stack(
          children: [
            // ❌ Close Button
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // ✅ Dialog Content
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
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),

                  /// Token Input (6 boxes)
                  _SixCharCodeInput(
                    onCodeChanged: (value) {
                      // Keep the original controller as the single source of truth
                      tokenController.text = value;
                    },
                  ),
                  if (error.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ],
                  const SizedBox(height: 20),

                  /// Verify Account Button
                  AsyncButton(
                    onPressed: onVerifyPressed,
                    isLoading: isLoading,
                    child: const Text(
                      'Verify Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// Resend Verification Email
                  SizedBox(
                    height: 36,
                    child: AsyncButton(
                      onPressed: onResendPressed,
                      isLoading: isResendLoading,
                      width: null,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Resend Verification Email',
                        style: TextStyle(color: Color(0xFF0D6EFD)),
                      ),
                    ),
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

class _SixCharCodeInput extends StatefulWidget {
  const _SixCharCodeInput({required this.onCodeChanged});

  final ValueChanged<String> onCodeChanged;

  @override
  State<_SixCharCodeInput> createState() => _SixCharCodeInputState();
}

class _SixCharCodeInputState extends State<_SixCharCodeInput> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].addListener(_notifyChange);
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.removeListener(_notifyChange);
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _notifyChange() {
    final code = _controllers.map((c) => c.text).join();
    widget.onCodeChanged(code);
  }

  void _handleOnChanged(String value, int index) {
    // Move to next box when a character is entered
    if (value.isNotEmpty) {
      if (index < _focusNodes.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
  }

  KeyEventResult _handleKeyEvent(KeyEvent event, int index) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        _focusNodes[index - 1].requestFocus();
        _controllers[index - 1].clear();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 44,
          height: 56,
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (e) {
              _handleKeyEvent(e, index);
            },
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              maxLength: 1,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                counterText: '',
                isDense: true,
                contentPadding: EdgeInsets.only(top: 10, bottom: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF86B7FE)),
                ),
              ),
              textAlignVertical: TextAlignVertical.center,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                UpperCaseTextFormatter(),
              ],
              keyboardType: TextInputType.visiblePassword,
              textInputAction: index == 5
                  ? TextInputAction.done
                  : TextInputAction.next,
              onChanged: (v) => _handleOnChanged(v, index),
            ),
          ),
        );
      }),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
      composing: TextRange.empty,
    );
  }
}
