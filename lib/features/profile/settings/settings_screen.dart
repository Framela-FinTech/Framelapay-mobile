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
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Settings'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const SizedBox(height: 4),
              _pushToggle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pushToggle() {
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
              child: AppIcon('bell', size: 20, color: AppColors.primaryDark),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Enable Push Notifications',
                    style: TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 16)),
                SizedBox(height: 2),
                Text('Receive updates on this device',
                    style:
                        TextStyle(color: AppColors.textGrey, fontSize: 13)),
              ],
            ),
          ),
          Switch(
            value: _pushEnabled,
            activeThumbColor: AppColors.white,
            activeTrackColor: AppColors.primaryDark,
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
