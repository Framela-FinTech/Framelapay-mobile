import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_bottom_nav.dart';

/// Simple stub for bottom-nav tabs whose real screen does not exist yet
/// (Wallet, Activity, Profile). Shows the tab title + "Coming soon" and keeps
/// the shared bottom nav so the user can switch tabs.
class ComingSoonScreen extends StatelessWidget {
  final String title;
  final int navIndex;
  const ComingSoonScreen({
    super.key,
    required this.title,
    required this.navIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(title,
            style: const TextStyle(color: Colors.black, fontSize: 16)),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 20)),
            const SizedBox(height: 8),
            const Text('Coming soon',
                style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(currentIndex: navIndex),
    );
  }
}
