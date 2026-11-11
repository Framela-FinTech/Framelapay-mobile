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
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Change Profile Picture'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            children: [
              _avatarWithBadge(),
              const SizedBox(height: 24),
              const ScreenHeading(
                'Choose A Profile Photo',
                helper:
                    'Use a clear photo that helps you recognise your account.',
                center: true,
              ),
              const SizedBox(height: 28),
              _tile(context, 'camera', 'Take a Photo', 'Use your device camera',
                  () => Navigator.pushNamed(
                      context, AppRoutes.adjustProfilePhoto)),
              _tile(context, 'image', 'Choose from Gallery',
                  'Select an existing photo',
                  () => Navigator.pushNamed(
                      context, AppRoutes.adjustProfilePhoto)),
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
      width: 124,
      height: 124,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF2FB),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: AppIcon('folder-user',
                  size: 52, color: AppColors.primaryDark),
            ),
          ),
          Positioned(
            right: 4,
            bottom: 4,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.accentYellow,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 2),
              ),
              child: const Center(
                child: AppIcon('camera',
                    size: 16, color: Colors.white, style: AppIconStyle.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, String icon, String title,
      String subtitle, VoidCallback onTap) {
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

  Widget _removeTile(BuildContext context, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFFCA5A5).withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child:
                      AppIcon('trash', size: 20, color: AppColors.error),
                ),
              ),
              const SizedBox(width: 14),
              const Text('Remove Current Photo',
                  style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.w700,
                      fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }
}
