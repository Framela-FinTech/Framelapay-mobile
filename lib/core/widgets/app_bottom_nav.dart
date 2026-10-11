import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../routes/app_routes.dart';
import 'app_icon.dart';

/// The app's single bottom navigation bar, shared by every top-level screen.
///
/// Five tabs, in design order: Home, Wallet, Transfer, Activity, Profile.
/// Each screen passes its own [currentIndex]; tapping another tab switches to
/// that tab's route (the current tab is a no-op). Tabs whose real screen does
/// not exist yet (Wallet, Activity, Profile) route to a "Coming soon"
/// placeholder.
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  const AppBottomNav({super.key, required this.currentIndex});

  /// Tab index -> destination route, in left-to-right order.
  static const List<String> _routes = [
    AppRoutes.home, // 0 Home
    AppRoutes.walletTab, // 1 Wallet
    AppRoutes.transferHub, // 2 Transfer
    AppRoutes.activity, // 3 Activity
    AppRoutes.profile, // 4 Profile
  ];

  static const List<_NavSpec> _specs = [
    _NavSpec('home', 'Home'),
    _NavSpec('wallet', 'Wallet'),
    _NavSpec('send', 'Transfer'),
    _NavSpec('activity', 'Activity'),
    _NavSpec('folder-user', 'Profile'),
  ];

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;
    Navigator.pushReplacementNamed(context, _routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (i) => _onTap(context, i),
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.primaryDark,
      unselectedItemColor: AppColors.textGrey,
      showUnselectedLabels: true,
      selectedFontSize: 11,
      unselectedFontSize: 11,
      items: [
        for (final spec in _specs)
          BottomNavigationBarItem(
            icon: AppIcon(spec.icon),
            activeIcon: AppIcon(spec.icon, style: AppIconStyle.bold),
            label: spec.label,
          ),
      ],
    );
  }
}

class _NavSpec {
  final String icon;
  final String label;
  const _NavSpec(this.icon, this.label);
}
