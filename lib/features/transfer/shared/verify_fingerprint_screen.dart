import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../data/models/transfer_auth_flow.dart';

/// Shared biometric gate for BOTH the stablecoin and fiat flows.
///
/// It no longer knows anything about a specific transfer model — it just
/// carries a neutral [TransferAuthFlow] forward to the processing screen
/// (or to the passcode fallback), which in turn routes to the right
/// completion screen. See [TransferAuthFlow].
class VerifyFingerprintScreen extends StatelessWidget {
  final TransferAuthFlow flow;
  const VerifyFingerprintScreen({super.key, required this.flow});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.4),
      body: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Verifying fingerprint',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 8),
                const Text('Use your fingerprint to authorize this transfer.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                const SizedBox(height: 24),
                // Tap to simulate a successful scan. Replaced by the real
                // local_auth prompt when biometrics are wired up.
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.processingTransfer,
                    arguments: flow,
                  ),
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                        color: AppColors.inputFill, shape: BoxShape.circle),
                    child: const AppIcon('fingerprint',
                        size: 48, color: AppColors.primaryDark),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Touch the fingerprint sensor.',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.enterPasscode,
                    arguments: flow,
                  ),
                  child: const Text('Use passcode instead'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
