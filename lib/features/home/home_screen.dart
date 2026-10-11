import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/app_bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildWalletBalanceCard(context),
              const SizedBox(height: 24),
              _buildSectionHeader(
                'Quick Links',
                showViewAll: true,
                onViewAll: () =>
                    Navigator.pushNamed(context, AppRoutes.quickActions),
              ),
              const SizedBox(height: 12),
              _buildQuickLinks(context),
              const SizedBox(height: 24),
              _buildSectionHeader('Today\'s Rates',
                  trailingText: 'Updated now'),
              const SizedBox(height: 12),
              _rateRow('USD / NGN', '₦150,000', '0.33%', 'US'),
              _rateRow('GBP / NGN', '₦150,000', '0.33%', 'GB'),
              _rateRow('UAH / NGN', '₦150,000', '0.33%', 'UA'),
              const SizedBox(height: 24),
              _buildReferralCard(),
              const SizedBox(height: 24),
              _buildSectionHeader('Recent Activity', showViewAll: true),
              const SizedBox(height: 8),
              _activityRow('Money sent to James Okoro', 'Aug 6th, 21:29 AM',
                  'USD \$250', 'Completed', 'assets/icons/crypto/usd.png'),
              _activityRow('Money received from James Okoro',
                  'Aug 6th, 21:29 AM', 'UAH \$250', 'Completed',
                  'assets/icons/crypto/uah.png'),
              _activityRow('Crypto purchased', 'Aug 6th, 21:29 AM',
                  'BTC \$250', 'Completed', 'assets/icons/crypto/btc.png'),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }

  // ---------- Section builders ----------

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'HI, CYNTHIA',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            SizedBox(height: 2),
            Text(
              'Framela ID: FRM4829138',
              style: TextStyle(color: AppColors.textGrey, fontSize: 11),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
          child: const CircleAvatar(
            backgroundColor: AppColors.inputFill,
            child: AppIcon('bell', color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildWalletBalanceCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Balance',
                style: TextStyle(color: AppColors.textGrey, fontSize: 13),
              ),
              Row(
                children: const [
                  AppIcon('eye', color: AppColors.textGrey, size: 16),
                  SizedBox(width: 4),
                  Text('NGN',
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                  AppIcon('chevron-down', color: Colors.white, size: 16),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '₦1,245,600.00',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '≈ 2,500.00 USDC',
            style: TextStyle(color: AppColors.textGrey, fontSize: 12),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.transferHub),
                  icon: const AppIcon('arrow-up', size: 16),
                  label: const Text('Send'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 56),
                    side: const BorderSide(color: AppColors.textGrey),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {},
                  icon: const AppIcon('arrow-down',
                      size: 16, color: Colors.white),
                  label: const Text('Add Money',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    String title, {
    bool showViewAll = false,
    VoidCallback? onViewAll,
    String? trailingText,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        if (showViewAll)
          TextButton(
            onPressed: onViewAll ?? () {},
            child: const Text('View All'),
          ),
        if (trailingText != null)
          Text(
            trailingText,
            style: const TextStyle(color: AppColors.textGrey, fontSize: 11),
          ),
      ],
    );
  }

  Widget _buildQuickLinks(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _quickLink('send', 'Send Money',
              onTap: () => Navigator.pushNamed(context, AppRoutes.transferHub)),
          _quickLink('folder-user', 'Beneficiaries'),
          _quickLink('BTC', 'Crypto'),
          _quickLink('receipt', 'Transactions History'),
        ],
      ),
    );
  }

  Widget _buildReferralCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Earn more with referrals',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 4),
                Text(
                  'Invite friends to Framela and earn exciting rewards.',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 44),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onPressed: () {},
            child: const Text('Refer now'),
          ),
        ],
      ),
    );
  }

  // ---------- Reusable rows ----------

  Widget _quickLink(String iconName, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.inputFill,
              child: AppIcon(iconName, color: AppColors.primaryDark),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: 70,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rateRow(
      String pair, String rate, String change, String countryCode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CountryFlag.fromCountryCode(
                countryCode,
                height: 20,
                width: 20,
                shape: const Circle(),
              ),
              const SizedBox(width: 8),
              Text(pair, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          Text(rate),
          Text(change, style: const TextStyle(color: AppColors.success)),
        ],
      ),
    );
  }

  Widget _activityRow(String title, String time, String amount,
      String status, String iconAssetPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.inputFill,
            child: ClipOval(
              child: Image.asset(
                iconAssetPath,
                width: 24,
                height: 24,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.swap_horiz,
                  color: AppColors.primaryDark,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 2),
                Text(
                  time,
                  style:
                      const TextStyle(color: AppColors.textGrey, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                status,
                style:
                    const TextStyle(color: AppColors.success, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}