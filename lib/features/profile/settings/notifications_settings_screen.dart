import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';
import '../widgets/profile_success_screen.dart';

/// Notification preferences (sheet 5). Checkbox rows for the kinds of alerts
/// the user receives. State is local only.
class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  bool _security = true;
  bool _transfers = true;
  bool _promos = false;

  void _save() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ProfileSuccessScreen(
          title: 'Preferences saved',
          message: 'Your notification preferences have been updated.',
          primary: SuccessButton('Return to Settings', AppRoutes.settingsHome),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Notifications'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const ScreenHeading(
                      'Choose which alerts you receive',
                      helper:
                          'You can change these preferences at any time.',
                    ),
                    const SizedBox(height: 20),
                    _check(
                      'Security alerts',
                      'Sign-ins and important account changes',
                      _security,
                      (v) => setState(() => _security = v),
                    ),
                    _check(
                      'Transfer updates',
                      'Status of your transfers and payments',
                      _transfers,
                      (v) => setState(() => _transfers = v),
                    ),
                    _check(
                      'Promotional messages',
                      'Offers, tips and product news',
                      _promos,
                      (v) => setState(() => _promos = v),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: PrimaryButton('Save Preferences', onPressed: _save),
            ),
          ],
        ),
      ),
    );
  }

  Widget _check(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return InkWell(
      onTap: () => onChanged(!value),
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
            Checkbox(
              value: value,
              activeColor: AppColors.accentYellow,
              onChanged: (v) => onChanged(v ?? false),
            ),
          ],
        ),
      ),
    );
  }
}
