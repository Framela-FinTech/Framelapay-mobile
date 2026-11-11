import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/user_repository.dart';

/// Profile hub — the bottom nav's Profile tab (index 4).
/// Dark user card + grouped account sections.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserRepository _repo = MockUserRepository();
  UserProfile? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final user = await _repo.getCurrentUser();
    if (!mounted) return;
    setState(() {
      _user = user;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: AppColors.primaryDark),
        title: const Text('Profile',
            style: TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w700,
                fontSize: 20)),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
      body: SafeArea(
        child: _loading || user == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _userCard(user),
                    const SizedBox(height: 20),
                    _sectionLabel('Account'),
                    _tile('folder-user', 'Personal Information',
                        'View and update your personal details.',
                        route: AppRoutes.personalInformation),
                    _tile('shield-tick', 'KYC Status',
                        'Verification status and limits.',
                        route: AppRoutes.profileKycStatus),
                    _tile('gift', 'Referral',
                        'Invite friends and earn rewards.',
                        route: AppRoutes.referral),
                    _tile('folder-user', 'Beneficiaries',
                        'Manage saved beneficiaries.',
                        route: AppRoutes.beneficiariesList),
                    const SizedBox(height: 12),
                    _sectionLabel('Statement'),
                    _tile('receipt', 'Statements',
                        'Download, share or print records.',
                        route: AppRoutes.statementsHub),
                    const SizedBox(height: 12),
                    _sectionLabel('Security'),
                    _tile('shield', 'Security',
                        'PIN, biometrics and trusted devices.',
                        route: AppRoutes.securityHome),
                    _tile('settings', 'Settings',
                        'Appearance, notifications and more.',
                        route: AppRoutes.settingsHome),
                    const SizedBox(height: 12),
                    _sectionLabel('Support'),
                    _tile('lifebuoy', 'Help & Support',
                        'Help articles and live support.',
                        route: AppRoutes.helpSupport),
                    const SizedBox(height: 12),
                    _sectionLabel('ACCOUNT CONTROLS'),
                    _tile('power', 'Deactivate Account',
                        'Temporarily disable your account.',
                        route: AppRoutes.deactivateAccount, danger: true),
                    _tile('logout', 'Sign Out', 'Log out from this device.',
                        route: AppRoutes.signOut, danger: true),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _userCard(UserProfile user) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRoutes.changePhoto),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            _avatar(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text('Framela ID: ${user.framelaId}',
                          style: const TextStyle(
                              color: AppColors.textGrey, fontSize: 12)),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () => Clipboard.setData(
                            ClipboardData(text: user.framelaId)),
                        child: const AppIcon('copy',
                            size: 13, color: AppColors.textGrey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _tierPill(),
                ],
              ),
            ),
            const AppIcon('chevron-right', color: AppColors.textGrey),
          ],
        ),
      ),
    );
  }

  Widget _avatar() {
    return SizedBox(
      width: 52,
      height: 52,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundImage: AssetImage('assets/images/cynthia_avatar.png'),
          ),
          Positioned(
            bottom: -2,
            right: -2,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.accentYellow,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryDark, width: 2),
              ),
              child: const AppIcon('verified',
                  size: 10, color: AppColors.primaryDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tierPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF16253D),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accentYellow, width: 1),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check, size: 12, color: AppColors.accentYellow),
          SizedBox(width: 4),
          Text('Tier 2 Verified',
              style: TextStyle(
                  color: AppColors.accentYellow,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      child: Text(text,
          style: const TextStyle(
              color: AppColors.textGrey,
              fontSize: 15,
              fontWeight: FontWeight.w700)),
    );
  }

  Widget _tile(String icon, String title, String subtitle,
      {required String route, bool danger = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: danger ? const Color(0xFFFEF2F2) : AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: danger
                  ? const Color(0xFFFCA5A5).withValues(alpha: 0.35)
                  : AppColors.divider,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: danger
                      ? const Color(0xFFFEE2E2)
                      : AppColors.iconTileSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: AppIcon(icon,
                      size: 20,
                      color: danger ? AppColors.error : AppColors.primaryDark),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: danger
                                ? AppColors.error
                                : AppColors.primaryDark)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: const TextStyle(
                            color: AppColors.textGrey, fontSize: 13)),
                  ],
                ),
              ),
              AppIcon('chevron-right',
                  size: 18,
                  color: danger ? AppColors.error : AppColors.textGrey),
            ],
          ),
        ),
      ),
    );
  }
}
