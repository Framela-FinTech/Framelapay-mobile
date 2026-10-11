import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Remove Profile Photo? — confirmation before replacing the photo with the
/// default profile icon.
class RemoveProfilePhotoScreen extends StatelessWidget {
  const RemoveProfilePhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Remove Profile Photo?'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                          color: Color(0xFFFBE9B8), shape: BoxShape.circle),
                      child: const AppIcon('image-off',
                          size: 32, color: Color(0xFFCB8A1E)),
                    ),
                    const SizedBox(height: 20),
                    const Text('Remove your profile photo?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 22)),
                    const SizedBox(height: 8),
                    const Text(
                        'Your photo will be replaced with the default profile '
                        'icon. Your account details will stay the same.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.textGrey, fontSize: 13)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => Navigator.pushNamed(
                          context, AppRoutes.profilePhotoRemoved),
                      child: const Text('Remove Photo'),
                    ),
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
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Keep Photo'),
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
