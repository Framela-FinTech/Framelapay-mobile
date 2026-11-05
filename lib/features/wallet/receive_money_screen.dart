import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/currency_wallet.dart';
import '../../data/repositories/currency_wallet_repository.dart';
import '../transfer/fiat/widgets/fiat_form_widgets.dart';

/// "Receive Money" — the middle tab of the Transfer hub.
///
/// Lists the user's currency wallets; picking one opens its receiving
/// details (account info + QR) on [ReceiveDetailsScreen].
class ReceiveMoneyScreen extends StatefulWidget {
  const ReceiveMoneyScreen({super.key});

  @override
  State<ReceiveMoneyScreen> createState() => _ReceiveMoneyScreenState();
}

class _ReceiveMoneyScreenState extends State<ReceiveMoneyScreen> {
  final CurrencyWalletRepository _repo = MockCurrencyWalletRepository();
  List<CurrencyWallet> _wallets = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final wallets = await _repo.getWallets();
    if (!mounted) return;
    setState(() {
      _wallets = wallets;
      _loading = false;
    });
  }

  void _open(CurrencyWallet wallet) =>
      Navigator.pushNamed(context, AppRoutes.receiveDetails, arguments: wallet);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Transfer'),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _tabStrip(),
                    const SizedBox(height: 20),
                    _promoBanner(),
                    const SizedBox(height: 24),
                    const ScreenHeading(
                      'Select a wallet',
                      helper: 'Choose the wallet you want to receive money in.',
                    ),
                    const SizedBox(height: 16),
                    ..._wallets.map(_walletCard),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _tabStrip() {
    Widget tab(String label, bool active, VoidCallback onTap) {
      return Padding(
        padding: const EdgeInsets.only(right: 20),
        child: InkWell(
          onTap: onTap,
          child: Column(
            children: [
              Text(label,
                  style: TextStyle(
                      fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                      color:
                          active ? AppColors.primaryDark : AppColors.textGrey,
                      fontSize: 13)),
              const SizedBox(height: 4),
              if (active)
                Container(width: 24, height: 2, color: AppColors.accentYellow),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        tab('Send Money', false,
            () => Navigator.pushReplacementNamed(context, AppRoutes.transferHub)),
        tab('Receive Money', true, () {}),
        tab('History', false, () {}),
      ],
    );
  }

  /// Promo card, reusing the designer's banner art (same asset as the Send
  /// hub) with a safe dark-card fallback if the image is missing.
  Widget _promoBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        'assets/images/create-account-banner.png',
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primaryDark,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create\nyour account.',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
              SizedBox(height: 6),
              Text('Fast, secure and reliable transfer to over 100 countries',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _walletCard(CurrencyWallet w) {
    return InkWell(
      onTap: () => _open(w),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            ClipOval(
              child: CountryFlag.fromCountryCode(w.countryCode,
                  height: 40, width: 40, shape: const Circle()),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(w.code,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(w.name,
                      style: const TextStyle(
                          color: AppColors.textGrey, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(w.formattedBalance,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 2),
                const Text('Available balance',
                    style:
                        TextStyle(color: AppColors.textGrey, fontSize: 11)),
              ],
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: AppColors.textGrey),
          ],
        ),
      ),
    );
  }
}
