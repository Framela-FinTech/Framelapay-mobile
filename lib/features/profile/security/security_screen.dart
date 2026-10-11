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
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Security'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _tile(
                icon: 'lock',
                title: 'Password',
                subtitle: 'Change or reset your login password',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.securityPassword),
              ),
              _tile(
                icon: 'shield-tick',
                title: 'Transaction PIN',
                subtitle: 'Change or secure your transaction PIN',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.transactionPin),
              ),
              _tile(
                icon: 'shield',
                title: 'Trusted Devices',
                subtitle: 'Manage trusted devices',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.trustedDevices),
              ),
              const SizedBox(height: 8),
              _biometricToggle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _biometricToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primaryDark,
            child: const AppIcon('fingerprint', color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Biometric sign-in',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                SizedBox(height: 2),
                Text('Use Face ID or fingerprint',
                    style:
                        TextStyle(color: AppColors.textGrey, fontSize: 11)),
              ],
            ),
          ),
          Switch(
            value: _biometric,
            activeColor: AppColors.accentYellow,
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primaryDark,
              child: AppIcon(icon, color: Colors.white, size: 18),
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
                          color: AppColors.textGrey, fontSize: 11)),
                ],
              ),
            ),
            const AppIcon('chevron-right', color: AppColors.textGrey),
          ],
        ),
      ),
    );
  }
}
