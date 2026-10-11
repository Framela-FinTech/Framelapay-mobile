import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/currency_wallet.dart';
import '../../data/repositories/currency_wallet_repository.dart';
import '../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Screen 4 — "Add Money": pick which wallet to fund, then continue to
/// the funding-method chooser.
class AddMoneySelectWalletScreen extends StatefulWidget {
  const AddMoneySelectWalletScreen({super.key});

  @override
  State<AddMoneySelectWalletScreen> createState() =>
      _AddMoneySelectWalletScreenState();
}

class _AddMoneySelectWalletScreenState
    extends State<AddMoneySelectWalletScreen> {
  final CurrencyWalletRepository _repo = MockCurrencyWalletRepository();
  List<CurrencyWallet> _wallets = [];
  String? _selected;
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
      _selected = wallets.isNotEmpty ? wallets.first.code : null;
      _loading = false;
    });
  }

  void _continue() {
    final wallet = _wallets.firstWhere((w) => w.code == _selected);
    Navigator.pushNamed(context, AppRoutes.chooseMethod, arguments: wallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Add Money'),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          _tabStrip(),
                          const SizedBox(height: 20),
                          const ScreenHeading(
                            'Select a wallet to fund',
                            helper: 'Choose where you want to add money.',
                          ),
                          const SizedBox(height: 16),
                          ..._wallets.map(_walletTile),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    child: PrimaryButton('Continue', onPressed: _continue),
                  ),
                ],
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
        tab('Add Money', true, () {}),
        tab('History', false, () {}),
      ],
    );
  }

  Widget _walletTile(CurrencyWallet w) {
    final selected = _selected == w.code;
    return InkWell(
      onTap: () => setState(() => _selected = w.code),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.accentYellow : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            ClipOval(
              child: CountryFlag.fromCountryCode(w.countryCode,
                  height: 36, width: 36, shape: const Circle()),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${w.name} Wallet',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text('${w.formattedBalance} available',
                      style: const TextStyle(
                          color: AppColors.textGrey, fontSize: 12)),
                ],
              ),
            ),
            Radio<String>(
              value: w.code,
              groupValue: _selected,
              activeColor: AppColors.accentYellow,
              onChanged: (v) => setState(() => _selected = v),
            ),
          ],
        ),
      ),
    );
  }
}
