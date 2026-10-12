import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';
import 'kyc_widgets.dart';

/// Verification Successful — the Tier 3 upgrade is approved and higher limits
/// are active.
class VerificationSuccessfulScreen extends StatelessWidget {
  const VerificationSuccessfulScreen({super.key});

  void _toProfile(BuildContext context) {
    Navigator.popUntil(context,
        (route) => route.settings.name == AppRoutes.profile || route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _toProfile(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: whiteAppBar('Verification Submitted'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                          color: AppColors.success, shape: BoxShape.circle),
                      child: const Icon(Icons.check,
                          color: Colors.white, size: 40),
                    ),
                    const SizedBox(height: 16),
                    const Text('Verification successful',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 24)),
                    const SizedBox(height: 8),
                    const Text(
                        'Your account is now Tier 3 verified and your higher '
                        'limits are active.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.textGrey, fontSize: 13)),
                    const SizedBox(height: 24),
                    _limitTile('arrow-up-right', 'Daily sending limit',
                        '€1,000'),
                    const SizedBox(height: 12),
                    _limitTile('calendar', 'Monthly sending limit', '€5,000'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: PrimaryButton(
                'Continue to Profile',
                onPressed: () => _toProfile(context),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _limitTile(String icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(10),
            ),
            child: AppIcon(icon, size: 20, color: AppColors.primaryDark),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        color: AppColors.textGrey, fontSize: 12)),
              ],
            ),
          ),
          const KycPill('Active'),
        ],
      ),
    );
  }
}
