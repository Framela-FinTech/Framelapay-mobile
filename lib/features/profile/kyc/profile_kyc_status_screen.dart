import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';
import 'kyc_widgets.dart';

/// Profile → KYC Status. Shows the current Tier 2 verification state and an
/// entry point to the Tier 2 → Tier 3 upgrade flow.
class ProfileKycStatusScreen extends StatelessWidget {
  const ProfileKycStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('KYC Status'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Column(
                  children: [
                    IconBadge(
                      icon: 'shield-tick',
                      halo: AppColors.successSoft,
                      size: 88,
                      glyphSize: 36,
                      glyphColor: AppColors.success,
                    ),
                    SizedBox(height: 16),
                    ScreenHeading(
                      'Tier 2 Verified',
                      helper:
                          'Your identity is verified and your account is active.',
                      center: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              _sectionLabel('Current verification'),
              const SizedBox(height: 8),
              _statusTile(
                'id-card',
                'Identity verification',
                'Government-issued ID',
                trailing: const KycPill('Verified'),
              ),
              const SizedBox(height: 10),
              _statusTile(
                'scan',
                'Liveness check',
                'Face verification',
                trailing: const KycPill('Verified'),
              ),
              const SizedBox(height: 10),
              _statusTile(
                'location',
                'Residential address',
                'Required for Tier 3',
                trailing: const AppIcon(
                  'chevron-right',
                  size: 18,
                  color: AppColors.textGrey,
                ),
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.profileKycUpgrade),
              ),
              const SizedBox(height: 14),
              const NoticeBanner(
                'Upgrade to Tier 3 to access higher sending and wallet limits.',
              ),
              const SizedBox(height: 24),
              _sectionLabel('Current limits — Illustrative'),
              const SizedBox(height: 8),
              const NoticeBanner(
                'Daily €5,000 • Monthly €20,000. Actual limits depend on your provider and verified tier.',
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                'Increase Limit',
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.profileKycUpgrade),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.textGrey,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _statusTile(
    String icon,
    String title,
    String subtitle, {
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
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
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }
}
