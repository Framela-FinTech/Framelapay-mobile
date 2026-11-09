import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../data/models/fiat_transfer.dart';
import '../../../data/models/transfer_method.dart';
import '../../../data/models/currency_wallet.dart';
import '../../../data/repositories/currency_wallet_repository.dart';
import '../fiat/widgets/fiat_form_widgets.dart';
import 'convert_funds_sheet.dart';

/// Screen 15 (Wallet) — choose the source wallet (currency) for the transfer.
/// Entry point of the Wallet flow; continues to the shared Transfer details.
class SelectWalletScreen extends StatefulWidget {
  const SelectWalletScreen({super.key});

  @override
  State<SelectWalletScreen> createState() => _SelectWalletScreenState();
}

class _SelectWalletScreenState extends State<SelectWalletScreen> {
  final CurrencyWalletRepository _repo = MockCurrencyWalletRepository();
  List<CurrencyWallet> _wallets = [];
  String? _selected;
  String? _conversionMessage;
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

  Future<void> _openConvert() async {
    final message = await showConvertFundsSheet(context, _wallets);
    if (message != null && mounted) {
      setState(() => _conversionMessage = message);
      // The balances the sheet just moved money between are now stale.
      await _load();
    }
  }

  void _continue() {
    Navigator.pushNamed(
      context,
      AppRoutes.fiatTransferDetails,
      arguments: FiatTransfer(
        method: TransferMethod.wallet,
        sourceWalletCode: _selected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Send Money'),
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
                          // The board carries this copy inside the banner
                          // rather than as a screen heading.
                          _infoBanner(),
                          const SizedBox(height: 22),
                          const SectionTitle('Your wallets'),
                          const SizedBox(height: 12),
                          ..._wallets.map(_walletTile),
                          const SizedBox(height: 6),
                          _convertCard(),
                          if (_conversionMessage != null) ...[
                            const SizedBox(height: 14),
                            NoticeBanner(
                              _conversionMessage!,
                              title: 'Conversion successful',
                              type: NoticeType.success,
                            ),
                          ],
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

  /// "You are sending from your Framela wallet." — a white glyph tile on the
  /// soft blue panel. The board spells it "walet"; corrected here.
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
                Text('You are sending from your Framela wallet.',
                    style: TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
                SizedBox(height: 3),
                Text(
                    'Choose the wallet (currency) you want to use for this '
                    'transfer.',
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
              // Drawn rather than a Radio: the board shows a plain navy ring
              // with no fill, and Radio's deprecated groupValue API is being
              // removed upstream.
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? AppColors.primaryDark
                        : AppColors.divider,
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

  Widget _convertCard() {
    return InkWell(
      onTap: _openConvert,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.infoPanel,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            AppIcon('coin-swap', color: AppColors.primaryDark, size: 24),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Need to move money between wallets?',
                      style: TextStyle(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 15)),
                  SizedBox(height: 3),
                  Text(
                      'Convert one currency balance to another before sending.',
                      style: TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 14,
                          height: 1.35)),
                ],
              ),
            ),
            SizedBox(width: 8),
            AppIcon('chevron-right', color: AppColors.primaryDark),
          ],
        ),
      ),
    );
  }
}
