import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';
import 'kyc_widgets.dart';

/// Profile → KYC Status. Shows the current Tier 2 verification state and an
/// entry point to the Tier 2 → Tier 3 upgrade flow.
///
/// This is the profile-side status screen for the upgrade journey. It is
/// separate from the onboarding KYC screens in lib/features/kyc/.
class ProfileKycStatusScreen extends StatelessWidget {
  const ProfileKycStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('KYC Status'),
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
                          color: Color(0xFFE3F7EC), shape: BoxShape.circle),
                      child: const AppIcon('shield-tick',
                          size: 34, color: AppColors.success),
                    ),
                    const SizedBox(height: 16),
                    const Text('Tier 2 Verified',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 24)),
                    const SizedBox(height: 8),
                    const Text(
                        'Your identity is verified and your account is active.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.textGrey, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const _SectionLabel('CURRENT VERIFICATION'),
              const SizedBox(height: 10),
              _statusTile('id-card', 'Identity verification',
                  'Government-issued ID',
                  trailing: const KycPill('Verified')),
              const SizedBox(height: 10),
              _statusTile('scan', 'Liveness check', 'Face verification',
                  trailing: const KycPill('Verified')),
              const SizedBox(height: 10),
              _statusTile('location', 'Residential address',
                  'Required for Tier 3',
                  trailing: const AppIcon('chevron-right',
                      size: 18, color: AppColors.textGrey),
                  onTap: () => Navigator.pushNamed(
                      context, AppRoutes.profileKycUpgrade)),
              const SizedBox(height: 12),
              const NoticeBanner(
                  'Upgrade to Tier 3 to access higher sending and wallet limits.',
                  type: NoticeType.info),
              const SizedBox(height: 20),
              const _SectionLabel('CURRENT LIMITS — ILLUSTRATIVE'),
              const SizedBox(height: 10),
              const NoticeBanner(
                  'Daily €5,000 • Monthly €20,000. Actual limits depend on your '
                  'provider and verified tier.',
                  type: NoticeType.info),
              const SizedBox(height: 28),
              PrimaryButton(
                'Increase My Limits',
                onPressed: () => Navigator.pushNamed(
                    context, AppRoutes.profileKycUpgrade),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusTile(String icon, String title, String subtitle,
      {Widget? trailing, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
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
                  Text(subtitle,
                      style: const TextStyle(
                          color: AppColors.textGrey, fontSize: 12)),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}

/// Small uppercase grey section label.
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            color: AppColors.textGrey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5));
  }
}
