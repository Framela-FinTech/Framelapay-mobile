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
      backgroundColor: Colors.black.withOpacity(0.4),
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Enter Passcode',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15)),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (i) {
                    final filled = i < _passcode.length;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.inputFill,
                        borderRadius: BorderRadius.circular(10),
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
                ),
                const SizedBox(height: 16),
                _buildKeypad(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', 'back'];

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      childAspectRatio: 1.8,
      children: keys.map((key) {
        if (key.isEmpty) return const SizedBox();
        if (key == 'back') {
          return _keypadButton(
            onTap: _removeDigit,
            child: const Icon(Icons.backspace_outlined, size: 18),
          );
        }
        return _keypadButton(
          onTap: () => _addDigit(key),
          child: Text(
            key,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        );
      }).toList(),
    );
  }

  Widget _keypadButton({required VoidCallback onTap, required Widget child}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Center(child: child),
    );
  }
}