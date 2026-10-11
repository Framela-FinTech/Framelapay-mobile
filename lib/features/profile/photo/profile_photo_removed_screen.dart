import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Profile Photo Removed — confirmation that the account now uses the default
/// avatar, with options to return or add a new photo.
class ProfilePhotoRemovedScreen extends StatelessWidget {
  const ProfilePhotoRemovedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Profile Photo Removed'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                          color: Color(0xFFE3F7EC), shape: BoxShape.circle),
                      child: const Icon(Icons.check,
                          color: AppColors.success, size: 36),
                    ),
                    const SizedBox(height: 16),
                    const Text('Profile photo removed',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 22)),
                    const SizedBox(height: 8),
                    const Text(
                        'Your account now uses the default profile icon. '
                        'You can add a new photo at any time.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.textGrey, fontSize: 13)),
                    const SizedBox(height: 24),
                    Container(
                      width: 88,
                      height: 88,
                      decoration: const BoxDecoration(
                          color: Color(0xFFDCE6FB), shape: BoxShape.circle),
                      child: const AppIcon('folder-user',
                          size: 36, color: AppColors.primaryDark),
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
                    'Return to Profile',
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context, AppRoutes.profile, (route) => false),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                        side: const BorderSide(color: AppColors.divider),
                        foregroundColor: AppColors.primaryDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context, AppRoutes.changePhoto, (route) => false),
                      child: const Text('Add a New Photo'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
