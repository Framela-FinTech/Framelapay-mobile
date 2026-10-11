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
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Send Money'),
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
                          const ScreenHeading(
                            'You are sending from your Framela wallet.',
                            helper:
                                'Choose the wallet (currency) you want to use for this transfer.',
                          ),
                          const SizedBox(height: 20),
                          if (_conversionMessage != null) ...[
                            NoticeBanner(
                              _conversionMessage!,
                              title: 'Conversion successful!',
                              type: NoticeType.success,
                            ),
                            const SizedBox(height: 16),
                          ],
                          const SectionTitle('Your wallets'),
                          const SizedBox(height: 12),
                          ..._wallets.map(_walletTile),
                          const SizedBox(height: 8),
                          _convertCard(),
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
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primaryDark,
              child: Text(w.code,
                  style: const TextStyle(color: Colors.white, fontSize: 11)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(w.formattedBalance,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text('${w.name} · Available balance',
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

  Widget _convertCard() {
    return InkWell(
      onTap: _openConvert,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.accentYellow,
              child: AppIcon('coin-swap',
                  color: AppColors.primaryDark, size: 18),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Need to move money between wallets?',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  SizedBox(height: 2),
                  Text('Convert one currency balance to another before sending.',
                      style: TextStyle(
                          color: AppColors.textGrey, fontSize: 12)),
                ],
              ),
            ),
            AppIcon('chevron-right', color: AppColors.textGrey),
          ],
        ),
      ),
    );
  }
}
