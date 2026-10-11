import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';
import '../widgets/profile_success_screen.dart';

/// Language & Region settings (sheet 5). Display-preference dropdowns only —
/// this does NOT change the user's verified country of residence.
class LanguageRegionScreen extends StatefulWidget {
  const LanguageRegionScreen({super.key});

  @override
  State<LanguageRegionScreen> createState() => _LanguageRegionScreenState();
}

class _LanguageRegionScreenState extends State<LanguageRegionScreen> {
  String _language = 'English';
  String _region = 'Nigeria';

  static const _languages = ['English', 'French', 'Spanish', 'Portuguese'];
  static const _regions = ['Nigeria', 'Ghana', 'Kenya', 'United Kingdom'];

  void _save() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ProfileSuccessScreen(
          title: 'Preference saved',
          message: 'Your language and region preferences have been updated.',
          primary: SuccessButton('Return to Settings', AppRoutes.settingsHome),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Language & Region'),
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
                      'Display preferences',
                      helper: 'Set your preferred language and region.',
                    ),
                    const SizedBox(height: 20),
                    const FieldLabel('Language'),
                    AppDropdownField(
                      hint: 'Select language',
                      value: _language,
                      items: _languages,
                      onChanged: (v) =>
                          setState(() => _language = v ?? _language),
                    ),
                    const SizedBox(height: 16),
                    const FieldLabel('Region'),
                    AppDropdownField(
                      hint: 'Select region',
                      value: _region,
                      items: _regions,
                      onChanged: (v) =>
                          setState(() => _region = v ?? _region),
                    ),
                    const SizedBox(height: 16),
                    const NoticeBanner(
                      'This changes display preferences, not your verified country of residence.',
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
}
