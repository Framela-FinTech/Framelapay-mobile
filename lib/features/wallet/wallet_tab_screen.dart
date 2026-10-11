import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../data/models/currency_wallet.dart';
import '../../data/models/wallet_activity.dart';
import '../../data/repositories/currency_wallet_repository.dart';
import '../transfer/wallet/convert_funds_sheet.dart';
import 'choose_wallet_balance_sheet.dart';

/// Wallet tab (screens: wallet-main + wallet-action-required). The yellow
/// "Action required" banner shows when KYC isn't verified; [forceActionRequired]
/// lets the debug menu preview that state.
class WalletTabScreen extends StatefulWidget {
  final bool forceActionRequired;
  const WalletTabScreen({super.key, this.forceActionRequired = false});

  @override
  State<WalletTabScreen> createState() => _WalletTabScreenState();
}

class _WalletTabScreenState extends State<WalletTabScreen> {
  final CurrencyWalletRepository _repo = MockCurrencyWalletRepository();
  List<CurrencyWallet> _wallets = [];
  List<WalletActivity> _activity = [];
  WalletTotals? _totals;
  bool _hidden = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final wallets = await _repo.getWallets();
    final activity = await _repo.getRecentActivity();
    final totals = await _repo.getTotals();
    if (!mounted) return;
    setState(() {
      _wallets = wallets;
      _activity = activity;
      _totals = totals;
      _loading = false;
    });
  }

  bool get _actionRequired =>
      widget.forceActionRequired || !(_totals?.kycVerified ?? true);

  void _openBalanceSheet() {
    showChooseWalletBalanceSheet(context, _wallets);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Wallet',
            style: TextStyle(color: Colors.black, fontSize: 16)),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _balanceCard(),
                    const SizedBox(height: 16),
                    _kycRow(),
                    const SizedBox(height: 16),
                    if (_actionRequired) ...[
                      _actionRequiredBanner(),
                      const SizedBox(height: 16),
                    ],
                    _currenciesHeader(),
                    const SizedBox(height: 12),
                    ..._wallets.map(_currencyTile),
                    const SizedBox(height: 16),
                    _activityHeader(),
                    const SizedBox(height: 8),
                    ..._activity.map(_activityTile),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
      ),
    );
  }

  // ---------- Balance card ----------

  Widget _balanceCard() {
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
                children: [
                  const Text('Total Balance',
                      style:
                          TextStyle(color: AppColors.textGrey, fontSize: 13)),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () => setState(() => _hidden = !_hidden),
                    child: AppIcon(_hidden ? 'eye-slash' : 'eye',
                        size: 16, color: AppColors.textGrey),
                  ),
                ],
              ),
              InkWell(
                onTap: _openBalanceSheet,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('All Accounts',
                          style:
                              TextStyle(color: Colors.white, fontSize: 12)),
                      AppIcon('chevron-down', size: 16, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(_hidden ? '••••••••' : (_totals?.primaryFormatted ?? ''),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(_hidden ? '••••••' : (_totals?.secondaryFormatted ?? ''),
              style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _action('arrow-up', 'Add Money',
                  () => Navigator.pushNamed(
                      context, AppRoutes.addMoneySelectWallet)),
              _action('arrow-down', 'Send Money',
                  () => Navigator.pushNamed(context, AppRoutes.transferHub)),
              _action('coin-swap', 'Convert',
                  () => showConvertFundsSheet(context, _wallets)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _action(String icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
                color: AppColors.white, shape: BoxShape.circle),
            child: AppIcon(icon, size: 20, color: AppColors.primaryDark),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }

  // ---------- KYC status ----------

  Widget _kycRow() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
                color: AppColors.success, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Active',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                SizedBox(height: 2),
                Text('KYC verified · No restrictions',
                    style:
                        TextStyle(color: AppColors.textGrey, fontSize: 12)),
              ],
            ),
          ),
          const AppIcon('chevron-right', color: AppColors.textGrey),
        ],
      ),
    );
  }

  Widget _actionRequiredBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const AppIcon('info-triangle', size: 16, color: Colors.orange),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Action required',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: Colors.black87)),
                SizedBox(height: 2),
                Text('Complete verification to continue using all wallet features.',
                    style: TextStyle(fontSize: 11, color: Colors.black87)),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.kycIntro),
            style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8)),
            child: const Text('Review'),
          ),
        ],
      ),
    );
  }

  // ---------- Currencies ----------

  Widget _currenciesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('My currencies',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Add currency'),
        ),
      ],
    );
  }

  Widget _currencyTile(CurrencyWallet w) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          ClipOval(
            child: CountryFlag.fromCountryCode(w.countryCode,
                height: 28, width: 28, shape: const Circle()),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text('${w.code} / NGN',
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14)),
          ),
          Text(_hidden ? '••••' : w.formattedBalance,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(width: 4),
          const AppIcon('chevron-right', size: 18, color: AppColors.textGrey),
        ],
      ),
    );
  }

  // ---------- Recent activity ----------

  Widget _activityHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Recent Activity',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        TextButton(onPressed: () {}, child: const Text('View All')),
      ],
    );
  }

  Widget _activityTile(WalletActivity a) {
    final tint = a.isCompleted ? AppColors.success : AppColors.error;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.inputFill,
            child: AppIcon(a.incoming ? 'arrow-down' : 'arrow-up',
                size: 18, color: tint),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(a.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text(a.time,
                    style: const TextStyle(
                        color: AppColors.textGrey, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(a.amount,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 4),
              _statusPill(a),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusPill(WalletActivity a) {
    final bg = a.isCompleted ? const Color(0xFFE3F7EC) : const Color(0xFFFDE8E6);
    final fg = a.isCompleted ? AppColors.success : AppColors.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(a.isCompleted ? 'Completed' : 'Failed',
          style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.w600)),
    );
  }
}
