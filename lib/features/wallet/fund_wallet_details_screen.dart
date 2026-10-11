import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_icon.dart';
import '../../data/models/currency_wallet.dart';
import '../../data/models/bank_account_details.dart';
import '../../data/repositories/currency_wallet_repository.dart';
import '../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Screen 6 — "Fund <currency> Wallet": bank account details to fund the
/// wallet by manual bank transfer.
class FundWalletDetailsScreen extends StatefulWidget {
  final CurrencyWallet wallet;
  const FundWalletDetailsScreen({super.key, required this.wallet});

  @override
  State<FundWalletDetailsScreen> createState() =>
      _FundWalletDetailsScreenState();
}

class _FundWalletDetailsScreenState extends State<FundWalletDetailsScreen> {
  final CurrencyWalletRepository _repo = MockCurrencyWalletRepository();
  BankAccountDetails? _details;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final d = await _repo.getBankFundingDetails(widget.wallet.code);
    if (!mounted) return;
    setState(() {
      _details = d;
      _loading = false;
    });
  }

  void _copyAll() {
    final d = _details;
    if (d == null) return;
    Clipboard.setData(ClipboardData(
      text: 'Account name: ${d.accountName}\n'
          'IBAN: ${d.iban}\n'
          'BIC/SWIFT: ${d.bic}\n'
          'Reference: ${d.reference}',
    ));
  }

  @override
  Widget build(BuildContext context) {
    final d = _details;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Fund ${widget.wallet.code} Wallet'),
      body: SafeArea(
        child: _loading || d == null
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
                            'Your account details',
                            helper:
                                'Transfer money from a bank account in your name.',
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.inputFill,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                _copyRow('Account name', d.accountName),
                                _copyRow('IBAN', d.iban),
                                _copyRow('BIC / SWIFT', d.bic),
                                _copyRow('Reference', d.reference),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          const NoticeBanner(
                            'Use the reference exactly as shown so we can identify your transfer.',
                            type: NoticeType.warning,
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(56),
                              side: const BorderSide(color: AppColors.divider),
                              foregroundColor: AppColors.primaryDark,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: _copyAll,
                            icon: const AppIcon('copy', size: 18),
                            label: const Text('Copy Details'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(56),
                              side: const BorderSide(color: AppColors.divider),
                              foregroundColor: AppColors.primaryDark,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () {},
                            icon: const AppIcon('share', size: 18),
                            label: const Text('Share Details'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _copyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
              ],
            ),
          ),
          InkWell(
            onTap: () => Clipboard.setData(ClipboardData(text: value)),
            child: const AppIcon('copy', size: 16, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }
}
