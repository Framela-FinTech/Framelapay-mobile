import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../data/models/currency_wallet.dart';
import '../../../data/repositories/currency_wallet_repository.dart';
import '../fiat/widgets/fiat_form_widgets.dart';

/// "Select From Wallet" — the first step of the standalone conversion journey
/// reached from the Wallet tab. Converting mid-transfer from Send Money uses
/// the bottom sheet instead and skips this screen.
class ConvertSelectWalletScreen extends StatefulWidget {
  const ConvertSelectWalletScreen({super.key});

  @override
  State<ConvertSelectWalletScreen> createState() =>
      _ConvertSelectWalletScreenState();
}

class _ConvertSelectWalletScreenState extends State<ConvertSelectWalletScreen> {
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
    final from = _wallets.firstWhere((w) => w.code == _selected);
    Navigator.pushNamed(context, AppRoutes.convertFunds, arguments: from);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Select From Wallet'),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoBanner(),
                          const SizedBox(height: 22),
                          const SectionTitle('Your wallets'),
                          const SizedBox(height: 12),
                          ..._wallets.map(_walletTile),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    child: PrimaryButton('Continue',
                        onPressed: _selected == null ? null : _continue),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _infoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.infoPanel,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const AppIcon('wallet',
                size: 22, color: AppColors.primaryDark),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Choose the wallet you want to convert from.',
                    style: TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
                SizedBox(height: 3),
                Text(
                    'Select the currency balance you want to use for this '
                    'conversion.',
                    style: TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 14,
                        height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _walletTile(CurrencyWallet w) {
    final selected = _selected == w.code;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => setState(() => _selected = w.code),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.primaryDark : AppColors.divider,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              ClipOval(
                child: CountryFlag.fromCountryCode(w.countryCode,
                    height: 40, width: 40),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(w.code,
                        style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(w.name,
                        style: const TextStyle(
                            color: AppColors.textGrey, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(w.formattedBalance,
                      style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 15)),
                  const SizedBox(height: 2),
                  const Text('Available balance',
                      style:
                          TextStyle(color: AppColors.textGrey, fontSize: 12)),
                ],
              ),
              const SizedBox(width: 8),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        selected ? AppColors.primaryDark : AppColors.divider,
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: selected
                    ? Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryDark,
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
