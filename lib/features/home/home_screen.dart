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
      backgroundColor: AppColors.pageGrey,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildBalanceCard(context),
              const SizedBox(height: 24),
              _buildSectionHeader(
                'Quick Links',
                trailing: _viewAll(() =>
                    Navigator.pushNamed(context, AppRoutes.quickActions)),
              ),
              const SizedBox(height: 12),
              _buildQuickLinks(context),
              const SizedBox(height: 20),
              _buildTransferStatusCard(),
              const SizedBox(height: 24),
              _buildSectionHeader(
                "Today's Rates",
                trailing: Row(
                  children: const [
                    Text('Updated now',
                        style: TextStyle(
                            color: AppColors.textGrey, fontSize: 12)),
                    SizedBox(width: 6),
                    AppIcon('refresh', size: 16, color: AppColors.textGrey),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildRatesCard(),
              const SizedBox(height: 24),
              _buildReferralCard(),
              const SizedBox(height: 24),
              _buildSectionHeader(
                'Recent Activity',
                trailing: _viewAll(() {}),
              ),
              const SizedBox(height: 4),
              _activityRow(
                  'Money sent to James Okoro', 'Aug 6th, 21:29 AM',
                  'USD • \$250', up: true),
              _activityRow('Money received from James Okoro',
                  'Aug 6th, 21:29 AM', 'UAH • \$250', up: false),
              _activityRow('Crypto purchased', 'Aug 6th, 21:29 AM',
                  'BTC • \$250', up: true),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }

  // ---------- Header ----------

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.inputFill,
                child: AppIcon('folder-user',
                    color: AppColors.primaryDark, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('HI, CYNTHIA',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 18)),
                    const SizedBox(height: 2),
                    Row(
                      children: const [
                        Flexible(
                          child: Text('Framela ID: FRM-482913',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: AppColors.textGrey, fontSize: 12)),
                        ),
                        SizedBox(width: 6),
                        AppIcon('copy', size: 14, color: AppColors.textGrey),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.inputFill,
                child: AppIcon('bell', color: AppColors.primaryDark),
              ),
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 18,
                  height: 18,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: AppColors.accentYellow, shape: BoxShape.circle),
                  child: const Text('8',
                      style: TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 10,
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------- Balance card ----------

  Widget _buildBalanceCard(BuildContext context) {
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
              Row(
                children: const [
                  Text('Total Balance',
                      style: TextStyle(color: AppColors.white, fontSize: 14)),
                  SizedBox(width: 8),
                  AppIcon('eye', color: AppColors.white, size: 16),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.secondaryDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Text('All Accounts',
                        style:
                            TextStyle(color: AppColors.white, fontSize: 12)),
                    SizedBox(width: 4),
                    AppIcon('chevron-down', color: AppColors.white, size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('\$12,550.00',
              style: TextStyle(
                  color: AppColors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          const Text('= ₦15,000,150.60',
              style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
          const SizedBox(height: 20),
          Row(
            children: [
              _balanceAction(context, 'arrow-up', 'Add Money',
                  () => Navigator.pushNamed(
                      context, AppRoutes.addMoneySelectWallet)),
              _balanceAction(context, 'arrow-down', 'Send Money',
                  () => Navigator.pushNamed(context, AppRoutes.transferHub)),
              _balanceAction(context, 'coin-swap', 'Convert', () {}),
              _balanceAction(context, 'more', 'More',
                  () => Navigator.pushNamed(context, AppRoutes.quickActions)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _balanceAction(
      BuildContext context, String icon, String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                  color: AppColors.white, shape: BoxShape.circle),
              child: AppIcon(icon, color: AppColors.primaryDark, size: 22),
            ),
            const SizedBox(height: 8),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.white, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  // ---------- Section header ----------

  Widget _buildSectionHeader(String title, {Widget? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style:
                const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _viewAll(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: const Text('View All',
          style: TextStyle(
              color: AppColors.iconBlue,
              fontWeight: FontWeight.w600,
              fontSize: 13)),
    );
  }

  // ---------- Quick links ----------

  Widget _buildQuickLinks(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _quickCard(context, 'send', 'Send Money', AppColors.iconBlue,
              route: AppRoutes.transferHub),
          const SizedBox(width: 12),
          _quickCard(
              context, 'folder-user', 'Beneficiaries', AppColors.iconPurple,
              route: AppRoutes.beneficiariesList),
          const SizedBox(width: 12),
          _quickCard(context, 'BTC', 'Crypto', AppColors.iconBlue),
          const SizedBox(width: 12),
          _quickCard(context, 'receipt', 'Transactions History',
              AppColors.accentYellow),
        ],
      ),
    );
  }

  Widget _quickCard(
      BuildContext context, String icon, String label, Color color,
      {String? route}) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: route == null
            ? null
            : () => Navigator.pushNamed(context, route),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppIcon(icon, color: color, size: 26),
              const SizedBox(height: 10),
              Text(label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      height: 1.15)),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Transfer status ----------

  Widget _buildTransferStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
                color: AppColors.accentYellow, shape: BoxShape.circle),
            child: const AppIcon('clock', color: AppColors.white, size: 18),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Transfer Status',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                SizedBox(height: 2),
                Text('You have 2 ongoing transfer',
                    style:
                        TextStyle(color: AppColors.textGrey, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.accentYellow.withOpacity(0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('In progress',
                style: TextStyle(
                    color: AppColors.accentYellow,
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 4),
          const AppIcon('chevron-right',
              size: 18, color: AppColors.textGrey),
        ],
      ),
    );
  }

  // ---------- Today's rates ----------

  Widget _buildRatesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _rateRow('USD / NGN', '₦150,000', '0.33%', 'US', up: true),
          const Divider(height: 1, color: AppColors.divider),
          _rateRow('GBP / NGN', '₦150,000', '0.33%', 'GB', up: false),
          const Divider(height: 1, color: AppColors.divider),
          _rateRow('UAH / NGN', '₦150,000', '0.33%', 'UA', up: true),
          const Divider(height: 1, color: AppColors.divider),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('View All',
                    style: TextStyle(
                        color: AppColors.iconBlue,
                        fontWeight: FontWeight.w700,
                        fontSize: 13)),
                SizedBox(width: 4),
                AppIcon('chevron-right', size: 16, color: AppColors.iconBlue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _rateRow(String pair, String rate, String change, String countryCode,
      {required bool up}) {
    final color = up ? AppColors.success : AppColors.error;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          CountryFlag.fromCountryCode(
            countryCode,
            height: 24,
            width: 24,
            shape: const Circle(),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(pair,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14)),
          ),
          Text(rate,
              style:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(width: 12),
          Icon(up ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: color, size: 20),
          Text(change,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  // ---------- Referral ----------

  Widget _buildReferralCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.iconBlue.withOpacity(0.85),
            AppColors.iconBlue.withOpacity(0.45),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const AppIcon('gift', color: AppColors.white, size: 26),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Earn more with referrals',
                    style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
                SizedBox(height: 4),
                Text('Invite friends to Framela and earn exciting rewards.',
                    style: TextStyle(color: AppColors.white, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              foregroundColor: AppColors.white,
              minimumSize: const Size(0, 40),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {},
            child: const Text('Refer now', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  // ---------- Recent activity ----------

  Widget _activityRow(String title, String time, String amount,
      {required bool up}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: AppIcon(up ? 'arrow-up-right' : 'arrow-down',
                color: AppColors.success, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(time,
                    style: const TextStyle(
                        color: AppColors.textGrey, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 12)),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Completed',
                    style: TextStyle(
                        color: AppColors.success,
                        fontSize: 10,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
