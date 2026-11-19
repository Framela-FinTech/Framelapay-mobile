import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Upgrade Verification — intro for the Tier 2 → Tier 3 upgrade, listing the
/// remaining checks before starting.
class UpgradeVerificationScreen extends StatelessWidget {
  const UpgradeVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Upgrade Verification'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    const IconBadge(
                      icon: 'shield-tick',
                      halo: AppColors.infoHalo,
                      size: 88,
                      glyphSize: 36,
                      glyphColor: AppColors.primary50,
                    ),
                    const SizedBox(height: 20),
                    const ScreenHeading(
                      'Upgrade to Tier 3',
                      helper:
                          'Complete the remaining checks to increase your account limits.',
                      center: true,
                    ),
                    const SizedBox(height: 36),
                    _check(
                      'id-card',
                      'Valid identity document',
                      'Passport, national ID or driving licence',
                    ),
                    const SizedBox(height: 24),
                    _check(
                      'location',
                      'Proof of residential address',
                      'Issued within the last 3 months',
                    ),
                    const SizedBox(height: 24),
                    _check(
                      'briefcase',
                      'Source of funds',
                      'Employment or business information',
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: PrimaryButton(
                'Start Verification',
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.profileKycIdentity,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _check(String icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: AppIcon(
            icon,
            size: 24,
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
