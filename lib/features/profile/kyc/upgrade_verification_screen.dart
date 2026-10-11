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
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Upgrade Verification'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                          color: Color(0xFFDCE6FB), shape: BoxShape.circle),
                      child: const AppIcon('shield-tick',
                          size: 34, color: Color(0xFF2F6BFF)),
                    ),
                    const SizedBox(height: 16),
                    const Text('Upgrade to Tier 3',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 24)),
                    const SizedBox(height: 8),
                    const Text(
                        'Complete the remaining checks to increase your account '
                        'limits.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.textGrey, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _check('id-card', 'Valid identity document',
                  'Passport, national ID or driving licence'),
              const SizedBox(height: 16),
              _check('location', 'Proof of residential address',
                  'Issued within the last 3 months'),
              const SizedBox(height: 16),
              _check('briefcase', 'Source of funds',
                  'Employment or business information'),
              const SizedBox(height: 28),
              PrimaryButton(
                'Start Verification',
                onPressed: () => Navigator.pushNamed(
                    context, AppRoutes.profileKycIdentity),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _check(String icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppIcon(icon, size: 22, color: AppColors.success),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: const TextStyle(
                      color: AppColors.textGrey, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}
