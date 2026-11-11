import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Profile Photo Removed — confirmation that the account now uses the default
/// avatar, with options to return or add a new photo.
class ProfilePhotoRemovedScreen extends StatelessWidget {
  const ProfilePhotoRemovedScreen({super.key});

  void _popTo(BuildContext context, String route) {
    // Walk UP the existing stack to [route] (an ancestor reached via pushNamed),
    // stopping at the Home root if it isn't found, so this never exits the app
    // or re-enters onboarding/KYC.
    Navigator.popUntil(
        context, (r) => r.settings.name == route || r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _popTo(context, AppRoutes.profile);
      },
      child: Scaffold(
        backgroundColor: AppColors.pageGrey,
        appBar: whiteAppBar('Profile Photo Removed'),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
                  child: Column(
                    children: [
                      const IconBadge(
                        icon: 'check-circle',
                        halo: AppColors.successSoft,
                        size: 104,
                        glyphSize: 42,
                        glyphColor: AppColors.success,
                      ),
                      const SizedBox(height: 24),
                      const ScreenHeading(
                        'Profile photo removed',
                        helper:
                            'Your account now uses the default profile icon. '
                            'You can add a new photo at any time.',
                        center: true,
                      ),
                      const SizedBox(height: 28),
                      Container(
                        width: 110,
                        height: 110,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEAF2FB),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: AppIcon('folder-user',
                              size: 48, color: AppColors.primaryDark),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Column(
                  children: [
                    PrimaryButton(
                      'Return to profile',
                      onPressed: () => _popTo(context, AppRoutes.profile),
                    ),
                    const SizedBox(height: 12),
                    SecondaryButton(
                      'Add a New Photo',
                      onPressed: () => _popTo(context, AppRoutes.changePhoto),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
