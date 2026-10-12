import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_icon.dart';

class _QuickAction {
  final String label;
  final String iconName; // AppIcon name
  final String? route; // null = no screen yet

  const _QuickAction(this.label, this.iconName, {this.route});
}

class QuickActionsScreen extends StatelessWidget {
  const QuickActionsScreen({super.key});

  // Grouping matches the redesign: Transfer / Manage / Support & more, each a
  // two-column list of icon-tile + label rows. Tile routes are unchanged.
  static const _transfer = <_QuickAction>[
    _QuickAction('Send Money', 'send', route: AppRoutes.transferHub),
    _QuickAction('Beneficiaries', 'folder-user'),
    _QuickAction('Crypto', 'BTC'),
    _QuickAction('Transactions History', 'receipt'),
  ];

  static const _manage = <_QuickAction>[
    _QuickAction('Refer & Earn', 'gift'),
    _QuickAction('Exchange rates', 'chart-up'),
    _QuickAction('Transactions Receipts', 'receipt'),
    _QuickAction('Security', 'shield'),
  ];

  static const _support = <_QuickAction>[
    _QuickAction('Help & Support', 'lifebuoy'),
    _QuickAction('FAQs', 'question-circle'),
    _QuickAction('Notifications', 'bell', route: AppRoutes.notifications),
    _QuickAction('Settings', 'settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FA),
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Quick Actions',
            style: TextStyle(color: Colors.black, fontSize: 16)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _sectionTitle('Transfer'),
              const SizedBox(height: 12),
              _list(context, _transfer),
              const SizedBox(height: 24),
              _sectionTitle('Manage'),
              const SizedBox(height: 12),
              _list(context, _manage),
              const SizedBox(height: 24),
              _sectionTitle('Support & more'),
              const SizedBox(height: 12),
              _list(context, _support),
              const SizedBox(height: 24),
              _promoBanner(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
    );
  }

  /// Two-column list of icon-tile + label rows. The fixed column count keeps it
  /// responsive — each cell scales to the available width.
  Widget _list(BuildContext context, List<_QuickAction> items) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.9,
      children: items.map((a) => _listTile(context, a)).toList(),
    );
  }

  Widget _listTile(BuildContext context, _QuickAction action) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: action.route == null
          ? null
          : () => Navigator.pushNamed(context, action.route!),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(12),
              ),
              child: AppIcon(action.iconName,
                  color: AppColors.primaryDark, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                action.label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _promoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFC7C9F2), Color(0xFF9DE8D6)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.35),
              shape: BoxShape.circle,
            ),
            child: const AppIcon('globe',
                size: 30, color: AppColors.primaryDark),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Send money internationally',
                    style: TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
                SizedBox(height: 4),
                Text(
                    'Fast, secure and reliable transfer to over 100 countries',
                    style: TextStyle(
                        color: AppColors.primaryDark, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
