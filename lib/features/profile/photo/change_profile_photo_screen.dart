import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Change Profile Photo — pick a source (camera / gallery) or remove the
/// current photo.
class ChangeProfilePhotoScreen extends StatelessWidget {
  const ChangeProfilePhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Change Profile Photo'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            children: [
              _avatarWithBadge(),
              const SizedBox(height: 20),
              const Text('Choose a profile photo',
                  style:
                      TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
              const SizedBox(height: 8),
              const Text('Use a clear photo that helps you recognise your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
              const SizedBox(height: 24),
              _tile(context, 'camera', 'Take a Photo', 'Use your device camera',
                  () => Navigator.pushNamed(
                      context, AppRoutes.adjustProfilePhoto)),
              const SizedBox(height: 12),
              _tile(context, 'image', 'Choose from Gallery',
                  'Select an existing photo',
                  () => Navigator.pushNamed(
                      context, AppRoutes.adjustProfilePhoto)),
              const SizedBox(height: 12),
              _removeTile(
                  context,
                  () => Navigator.pushNamed(
                      context, AppRoutes.removeProfilePhoto)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatarWithBadge() {
    return SizedBox(
      width: 108,
      height: 108,
      child: Stack(
        children: [
          Container(
            width: 104,
            height: 104,
            decoration: const BoxDecoration(
                color: Color(0xFFE6ECFF), shape: BoxShape.circle),
            child: const AppIcon('folder-user',
                size: 44, color: AppColors.primaryDark),
          ),
          Positioned(
            right: 0,
            bottom: 8,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                  color: AppColors.accentYellow, shape: BoxShape.circle),
              child: const AppIcon('camera',
                  size: 16, color: Colors.white, style: AppIconStyle.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, String icon, String title,
      String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: AppIcon(icon, size: 20, color: AppColors.primaryDark),
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
                          color: AppColors.textGrey, fontSize: 12)),
                ],
              ),
            ),
            const AppIcon('chevron-right', size: 18, color: AppColors.textGrey),
          ],
        ),
      ),
    );
  }

  Widget _removeTile(BuildContext context, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFDEAEA),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const AppIcon('trash', size: 20, color: AppColors.error),
            ),
            const SizedBox(width: 12),
            const Text('Remove Current Photo',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.error)),
          ],
        ),
      ),
    );
  }
}
