import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Settings hub. A list of settings destinations plus an inline
/// "Enable Push Notifications" master toggle. Toggle state is local only.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Settings'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _tile(
                icon: 'bell',
                title: 'Notifications',
                subtitle: 'Choose which alerts you receive',
                onTap: () => Navigator.pushNamed(
                    context, AppRoutes.notificationsSettings),
              ),
              _tile(
                icon: 'eye',
                title: 'Appearance',
                subtitle: 'Light, dark or system theme',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.appearance),
              ),
              _tile(
                icon: 'globe',
                title: 'Language & Region',
                subtitle: 'Display preferences',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.languageRegion),
              ),
              const SizedBox(height: 8),
              _pushToggle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pushToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Enable Push Notifications',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                SizedBox(height: 2),
                Text('Receive updates on this device',
                    style:
                        TextStyle(color: AppColors.textGrey, fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: _pushEnabled,
            activeColor: AppColors.accentYellow,
            onChanged: (v) => setState(() => _pushEnabled = v),
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
