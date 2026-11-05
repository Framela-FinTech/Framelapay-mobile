import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/transfer_auth_flow.dart';

/// Shared passcode gate for BOTH the stablecoin and fiat flows.
/// Carries a neutral [TransferAuthFlow] to the processing screen.
class EnterPasscodeScreen extends StatefulWidget {
  final TransferAuthFlow flow;
  const EnterPasscodeScreen({super.key, required this.flow});

  @override
  State<EnterPasscodeScreen> createState() => _EnterPasscodeScreenState();
}

class _EnterPasscodeScreenState extends State<EnterPasscodeScreen> {
  String _passcode = '';

  void _addDigit(String digit) {
    if (_passcode.length < 4) {
      setState(() => _passcode += digit);
      if (_passcode.length == 4) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.processingTransfer,
              arguments: widget.flow,
            );
          }
        });
      }
    }
  }

  void _removeDigit() {
    if (_passcode.isNotEmpty) {
      setState(() => _passcode = _passcode.substring(0, _passcode.length - 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.4),
      body: Align(
        // Figma anchors the passcode panel to the bottom, full width.
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text('Enter Passcode',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w700,
                              fontSize: 17)),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close,
                          size: 22, color: AppColors.primaryDark),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                _passcodeBoxes(),
                const SizedBox(height: 22),
                _buildKeypad(),
                const SizedBox(height: 10),
                const Text('Never share your transaction PIN.',
                    style: TextStyle(
                        color: AppColors.textGrey, fontSize: 11)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Four outlined boxes; a filled one shows a dot, never the digit itself.
  Widget _passcodeBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        final filled = i < _passcode.length;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 46,
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.divider),
          ),
          child: filled
              ? Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryDark,
                    shape: BoxShape.circle,
                  ),
                )
              : null,
        );
      }),
    );
  }

  /// Bordered 3-column grid; the final row is a wide "0" plus backspace.
  Widget _buildKeypad() {
    return Container(
      // Cells carry their own right/bottom edge, so the grid only needs
      // its top and left drawn here to close the box.
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.divider),
          left: BorderSide(color: AppColors.divider),
        ),
      ),
      child: Column(
        children: [
          _keyRow(const ['1', '2', '3']),
          _keyRow(const ['4', '5', '6']),
          _keyRow(const ['7', '8', '9']),
          Row(
            children: [
              Expanded(flex: 2, child: _key('0')),
              Expanded(
                child: _cell(
                  onTap: _removeDigit,
                  child: const Icon(Icons.backspace_outlined,
                      size: 20, color: AppColors.primaryDark),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _keyRow(List<String> keys) {
    return Row(
      children: keys.map((k) => Expanded(child: _key(k))).toList(),
    );
  }

  Widget _key(String digit) {
    return _cell(
      onTap: () => _addDigit(digit),
      child: Text(digit,
          style: const TextStyle(
              color: AppColors.primaryDark,
              fontSize: 20,
              fontWeight: FontWeight.w600)),
    );
  }

  Widget _cell({required VoidCallback onTap, required Widget child}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 56,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(color: AppColors.divider),
            bottom: BorderSide(color: AppColors.divider),
          ),
        ),
        child: child,
      ),
    );
  }
}