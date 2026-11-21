import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Preference Saved confirmation screen.
/// Matches Frame 3 of `Preferred total currency.png`.
class PreferenceSavedScreen extends StatelessWidget {
  const PreferenceSavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Preferred Total Currency'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check,
                          color: AppColors.white,
                          size: 38,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Preference saved',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your settings have been updated.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.neutral60,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: PrimaryButton(
                'Return to Settings',
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    (route) =>
                        route.settings.name == AppRoutes.settingsHome ||
                        route.settings.name == AppRoutes.profile ||
                        route.isFirst,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
