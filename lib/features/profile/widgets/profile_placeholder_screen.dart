import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_icon.dart';

/// Lightweight "Coming soon" placeholder for Profile sub-screens that don't
/// have a full design yet. Unlike the bottom-nav [ComingSoonScreen], this one
/// is a pushed step screen with a back button (no bottom nav).
class ProfilePlaceholderScreen extends StatelessWidget {
  final String title;
  const ProfilePlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(title,
            style: const TextStyle(color: Colors.black, fontSize: 16)),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppIcon('settings', size: 40, color: AppColors.textGrey),
            const SizedBox(height: 12),
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 18)),
            const SizedBox(height: 6),
            const Text('Coming soon',
                style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
