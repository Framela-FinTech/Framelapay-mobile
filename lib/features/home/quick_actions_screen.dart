import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_icon.dart';

class _QuickAction {
  final String label;
  final String iconName; // AppIcon name
  final Color tint; // soft background of the tile
  final Color color; // icon colour
  final String? route; // null = no screen yet

  const _QuickAction(this.label, this.iconName, this.tint, this.color,
      {this.route});
}

class QuickActionsScreen extends StatelessWidget {
  const QuickActionsScreen({super.key});

  // Tint + icon colour pairs
  static const _blueBg = Color(0xFFE7EEFF);
  static const _blue = Color(0xFF3B5BDB);
  static const _yellowBg = Color(0xFFFFF3D6);
  static const _yellow = Color(0xFFD99A00);
  static const _greenBg = Color(0xFFE3F7EC);
  static const _green = Color(0xFF1F9D57);
  static const _purpleBg = Color(0xFFF0E8FF);
  static const _purple = Color(0xFF7048E8);
  static const _pinkBg = Color(0xFFFFE8F0);
  static const _pink = Color(0xFFD6336C);
  static const _orangeBg = Color(0xFFFFEDE0);
  static const _orange = Color(0xFFE8590C);
  static const _tealBg = Color(0xFFE0F7F6);
  static const _teal = Color(0xFF0C8F8A);
  static const _greyBg = Color(0xFFEDEFF3);
  static const _grey = Color(0xFF495057);

  static const _manage = <_QuickAction>[
    _QuickAction('Beneficiaries', 'folder-user', _blueBg, _blue),
    _QuickAction('Crypto', 'BTC', _orangeBg, _orange),
    _QuickAction('Transactions History', 'receipt', _purpleBg, _purple),
    _QuickAction('Exchange rates', 'chart-up', _greenBg, _green),
    _QuickAction('Refer & Earn', 'coins-alt', _pinkBg, _pink),
  ];

  // Placeholder section — remove if it isn't in the final design.
  static const _services = <_QuickAction>[
    _QuickAction('Airtime', 'call', _tealBg, _teal),
    _QuickAction('Data', 'wifi', _blueBg, _blue),
    _QuickAction('Electricity', 'bulb', _yellowBg, _yellow),
    _QuickAction('TV', 'tv', _purpleBg, _purple),
    _QuickAction('Betting', 'target', _greenBg, _green),
    _QuickAction('Education', 'graduating-cap', _orangeBg, _orange),
  ];

  static const _support = <_QuickAction>[
    _QuickAction('Transactions Receipts', 'receipt', _blueBg, _blue),
    _QuickAction('Security', 'lock', _greenBg, _green),
    _QuickAction('Help & Support', 'lifebuoy', _tealBg, _teal),
    _QuickAction('FAQs', 'question-circle', _purpleBg, _purple),
    _QuickAction('Notifications', 'bell', _yellowBg, _yellow,
        route: AppRoutes.notifications),
    _QuickAction('Settings', 'settings', _greyBg, _grey),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
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
              const SizedBox(height: 12),
              _sectionTitle('Transfer'),
              const SizedBox(height: 10),
              _sendMoneyTile(context),
              const SizedBox(height: 24),
              _sectionTitle('Manage'),
              const SizedBox(height: 14),
              _grid(context, _manage),
              const SizedBox(height: 24),
              _sectionTitle('Bills & services'),
              const SizedBox(height: 14),
              _grid(context, _services),
              const SizedBox(height: 24),
              _sectionTitle('Support & more'),
              const SizedBox(height: 14),
              _grid(context, _support),
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

  Widget _sendMoneyTile(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pushNamed(context, AppRoutes.transferHub),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _yellowBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.accentYellow,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const AppIcon('send', color: AppColors.primaryDark),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('Send Money',
                  style:
                      TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            ),
            const AppIcon('chevron-right', color: AppColors.primaryDark),
          ],
        ),
      ),
    );
  }

  Widget _grid(BuildContext context, List<_QuickAction> items) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 12,
      childAspectRatio: 0.95,
      children: items.map((a) => _tile(context, a)).toList(),
    );
  }

  Widget _tile(BuildContext context, _QuickAction action) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: action.route == null
          ? null
          : () => Navigator.pushNamed(context, action.route!),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: action.tint,
              borderRadius: BorderRadius.circular(18),
            ),
            child: AppIcon(action.iconName, color: action.color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            action.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _promoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Send money internationally',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15)),
          SizedBox(height: 4),
          Text('Fast, secure and reliable transfer to over 100 countries',
              style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
        ],
      ),
    );
  }
}