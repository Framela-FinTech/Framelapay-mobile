import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../data/models/fiat_transfer.dart';
import '../../../data/repositories/collection_account_repository.dart';
import '../fiat/widgets/fiat_form_widgets.dart';

/// Screen 8 (Bank) — manual bank-transfer instructions with copyable fields.
///
/// The destination account comes from [CollectionAccountRepository]; only the
/// payment reference is per-transfer (it is the transaction id).
class PaymentInstructionScreen extends StatefulWidget {
  final FiatTransfer transfer;
  const PaymentInstructionScreen({super.key, required this.transfer});

  @override
  State<PaymentInstructionScreen> createState() =>
      _PaymentInstructionScreenState();
}

class _PaymentInstructionScreenState extends State<PaymentInstructionScreen> {
  final CollectionAccountRepository _repo = MockCollectionAccountRepository();
  CollectionAccount? _account;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final account = await _repo.getCollectionAccount();
    if (!mounted) return;
    setState(() => _account = account);
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.transfer;
    final a = _account;
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Payment Instruction'),
      body: SafeArea(
        child: a == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                      child: Column(
                        children: [
                          const IconBadge(
                            icon: 'bank',
                            halo: AppColors.iconTileSoft,
                            glyphColor: AppColors.primary50,
                          ),
                          const SizedBox(height: 14),
                          const ScreenHeading(
                            'Complete your bank transfer',
                            helper: 'Transfer the exact total, including the fee.',
                            center: true,
                          ),
                          const SizedBox(height: 22),
                          InfoCard(
                            children: [
                              _copyRow('Amount to transfer', t.formattedTotal),
                              const Divider(
                                  height: 1, color: AppColors.divider),
                              _copyRow('Account name', a.accountName),
                              const Divider(
                                  height: 1, color: AppColors.divider),
                              _copyRow('Bank', a.bankName),
                              const Divider(
                                  height: 1, color: AppColors.divider),
                              _copyRow('Account number', a.accountNumber),
                              const Divider(
                                  height: 1, color: AppColors.divider),
                              _copyRow('Payment reference', t.transactionId),
                            ],
                          ),
                          const SizedBox(height: 18),
                          const NoticeBanner(
                            'Use the payment reference as your transfer '
                            'narration. These are illustrative account details.',
                            type: NoticeType.warning,
                            background: AppColors.warningPanel,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    child: PrimaryButton(
                      "I've Made the Transfer",
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.fiatReviewTransfer,
                        arguments: t,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _copyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 15)),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(value,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 15)),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => Clipboard.setData(ClipboardData(text: value)),
                  child: const AppIcon('copy',
                      size: 16, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
