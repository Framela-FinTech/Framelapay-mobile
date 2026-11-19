import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';
import '../widgets/profile_success_screen.dart';

/// Appearance settings. Light / Dark / System cards. Selection is
/// local state only — this does NOT actually switch the app theme.
class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  String _selected = 'system';

  void _save() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ProfileSuccessScreen(
          title: 'Appearance saved',
          message: 'Your appearance preference has been updated.',
          primary: SuccessButton('Return to Settings', AppRoutes.settingsHome),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Appearance'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ScreenHeading(
                      'Choose your app appearance',
                      helper: 'Pick how Framela Pay looks on this device.',
                    ),
                    const SizedBox(height: 20),
                    _option('light', 'Light', 'Bright background', 'eye'),
                    _option('dark', 'Dark', 'Dim background', 'eye-slash'),
                    _option('system', 'System', 'Match your device setting',
                        'settings'),
                    const SizedBox(height: 16),
                    const NoticeBanner(
                      'Appearance changes apply to this device only.',
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: PrimaryButton('Save Changes', onPressed: _save),
            ),
          ],
        ),
      ),
    );
  }

  Widget _option(String key, String title, String subtitle, String icon) {
    final selected = _selected == key;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => setState(() => _selected = key),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.primaryDark : AppColors.divider,
              width: selected ? 1.5 : 1.0,
            ),
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
              Radio<String>(
                value: key,
                groupValue: _selected,
                activeColor: AppColors.primaryDark,
                onChanged: (v) => setState(() => _selected = v!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
