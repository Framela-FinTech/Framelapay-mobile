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
        backgroundColor: AppColors.pageGrey,
        appBar: whiteAppBar('Verification Successful'),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                  child: Column(
                    children: [
                      const IconBadge(
                        icon: 'check-circle',
                        halo: AppColors.successSoft,
                        size: 88,
                        glyphSize: 36,
                        glyphColor: AppColors.success,
                      ),
                      const SizedBox(height: 18),
                      const ScreenHeading(
                        'Verification successful',
                        helper:
                            'Your account is now Tier 3 verified and your higher '
                            'limits are active.',
                        center: true,
                      ),
                      const SizedBox(height: 28),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.iconTileSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: AppIcon(icon, size: 20, color: AppColors.primaryDark),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 16)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        color: AppColors.textGrey, fontSize: 13)),
              ],
            ),
          ),
          const KycPill('Active'),
        ],
      ),
    );
  }
}
