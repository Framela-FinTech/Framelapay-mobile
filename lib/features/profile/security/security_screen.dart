import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Security hub. Password / Transaction PIN / Trusted Devices destinations plus
/// a Biometric sign-in toggle (local state only).
class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _biometric = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Security'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _tile(
                icon: 'search',
                title: 'Password',
                subtitle: 'Change or reset your login password.',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.securityPassword),
              ),
              _tile(
                icon: 'more',
                title: 'Transaction PIN',
                subtitle: 'Change or recover your transaction PIN.',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.transactionPin),
              ),
              _tile(
                icon: 'mobile',
                title: 'Trusted Devices',
                subtitle: 'Remove Devices.',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.trustedDevices),
              ),
              const SizedBox(height: 4),
              _biometricToggle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _biometricToggle() {
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
            child: const Center(
              child: AppIcon('fingerprint',
                  size: 20, color: AppColors.primaryDark),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Biometric sign-in',
                    style: TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 16)),
                SizedBox(height: 2),
                Text('Use Face ID or fingerprint',
                    style:
                        TextStyle(color: AppColors.textGrey, fontSize: 13)),
              ],
            ),
          ),
          Switch(
            value: _biometric,
            activeColor: AppColors.primaryDark,
            onChanged: (v) => setState(() => _biometric = v),
          ),
        ],
      ),
    );
  }

  Widget _tile({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
                  child: AppIcon(icon,
                      size: 20, color: AppColors.primaryDark),
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
                    Text(subtitle,
                        style: const TextStyle(
                            color: AppColors.textGrey, fontSize: 13)),
                  ],
                ),
              ),
              const AppIcon('chevron-right',
                  size: 18, color: AppColors.textGrey),
            ],
          ),
        ),
      ),
    );
  }
}
