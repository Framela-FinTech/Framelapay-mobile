import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_flags/country_flags.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/widgets/app_icon.dart';
import '../../data/models/currency_wallet.dart';
import '../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Receiving details for a single wallet: a QR placeholder plus the account
/// information other people use to pay the user in this currency.
class ReceiveDetailsScreen extends StatelessWidget {
  final CurrencyWallet wallet;
  const ReceiveDetailsScreen({super.key, required this.wallet});

  // Mock account holder — consistent with the Home dashboard ("HI, CYNTHIA").
  static const String _accountName = 'Cynthia Okoro';
  static const String _framelaId = 'FRM-482913';

  /// Per-currency receiving coordinates (mock data).
  ({String bank, String account}) get _coordinates {
    switch (wallet.code) {
      case 'NGN':
        return (bank: 'Providus Bank (Framela)', account: '9912 345 678');
      case 'USD':
        return (bank: 'Lead Bank (Framela)', account: 'Routing 101019644 · 9900 2841');
      case 'GBP':
        return (bank: 'Clear Junction (Framela)', account: 'Sort 04-00-75 · 9900 2841');
      case 'EUR':
        return (bank: 'SEPA (Framela)', account: 'DE89 3704 0044 0532 0130 00');
      case 'UAH':
        return (bank: 'Framela UA', account: '2600 1234 5678 9012');
      default:
        return (bank: 'Framela', account: '9900 2841');
    }
  }

  void _copy(BuildContext context, String label, String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$label copied')));
  }

  void _share(BuildContext context) {
    final c = _coordinates;
    final summary = 'Pay me in ${wallet.code} via Framela\n'
        'Account name: $_accountName\n'
        'Account number: ${c.account}\n'
        'Bank: ${c.bank}\n'
        'Framela ID: $_framelaId';
    Clipboard.setData(ClipboardData(text: summary));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
          const SnackBar(content: Text('Details copied — ready to share')));
  }

  @override
  Widget build(BuildContext context) {
    final c = _coordinates;
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Receive ${wallet.code}'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ClipOval(
                          child: CountryFlag.fromCountryCode(wallet.countryCode,
                              height: 36, width: 36, shape: const Circle()),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Receive ${wallet.name}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16)),
                              const SizedBox(height: 2),
                              Text(
                                  'Share these details to get paid in ${wallet.code}.',
                                  style: const TextStyle(
                                      color: AppColors.textGrey, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _qrCard(),
                    const SizedBox(height: 20),
                    _detailsCard(context, c),
                    const SizedBox(height: 16),
                    NoticeBanner(
                      'Only send ${wallet.code} to this account. Funds sent in another currency may be lost.',
                      type: NoticeType.warning,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: PrimaryButton('Share Details',
                  onPressed: () => _share(context)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _qrCard() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          children: [
            const Icon(Icons.qr_code_2, size: 150, color: AppColors.primaryDark),
            const SizedBox(height: 12),
            Text('Framela ID: $_framelaId',
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 2),
            const Text('Scan to pay me on Framela',
                style: TextStyle(color: AppColors.textGrey, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _detailsCard(BuildContext context, ({String bank, String account}) c) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          _copyRow(context, 'Account name', _accountName),
          const Divider(height: 1, color: AppColors.divider),
          _copyRow(context, 'Account number', c.account),
          const Divider(height: 1, color: AppColors.divider),
          _copyRow(context, 'Bank', c.bank),
          const Divider(height: 1, color: AppColors.divider),
          _copyRow(context, 'Framela ID', _framelaId),
        ],
      ),
    );
  }

  Widget _copyRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: AppColors.textGrey, fontSize: 12)),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: () => _copy(context, label, value),
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: AppIcon('copy', size: 18, color: AppColors.primaryDark),
            ),
          ),
        ],
      ),
    );
  }
}
