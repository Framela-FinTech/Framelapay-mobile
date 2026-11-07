import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/receipt_card.dart';
import '../../../core/widgets/share_receipt_sheet.dart';
import '../../../data/models/fiat_transfer.dart';
import 'widgets/fiat_form_widgets.dart';

/// Screen 14 — the shareable receipt for a completed fiat transfer.
/// Renders the same branded card the Statements receipts use.
class FiatTransactionDetailsScreen extends StatelessWidget {
  final FiatTransfer transfer;
  const FiatTransactionDetailsScreen({super.key, required this.transfer});

  void _goHome(BuildContext context) =>
      Navigator.popUntil(context, (route) => route.isFirst);

  @override
  Widget build(BuildContext context) {
    final t = transfer;
    final b = t.beneficiary;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _goHome(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.pageGrey,
        appBar: whiteAppBar('Receipt'),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: ReceiptCard(
                    statusLabel: t.status,
                    statusColor: AppColors.success,
                    statusBackground: AppColors.successNotice,
                    headlineAmount: t.formattedReceiveAmount,
                    caption: 'Money sent · ${b?.displayName ?? '—'}',
                    reference: t.transactionId,
                    note: 'Transaction successful',
                    rows: [
                      ReceiptLine('From', t.senderName),
                      ReceiptLine('To',
                          '${b?.displayName ?? '—'} · ${b?.bankName ?? '—'}'),
                      ReceiptLine(
                          'Account', '•••• ${b?.accountTail ?? '—'}'),
                      ReceiptLine('You sent', t.formattedSendAmount),
                      ReceiptLine('Transfer fee', t.formattedFee),
                      ReceiptLine('Total paid', t.formattedTotal),
                      ReceiptLine('Exchange rate', t.formattedRate),
                      ReceiptLine('Purpose', t.purpose),
                      ReceiptLine('Payment method', t.methodLabel),
                      ReceiptLine('Date and time', t.dateTime),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Column(
                  children: [
                    PrimaryButton(
                      'Share Receipt',
                      onPressed: () => showShareReceiptSheet(context),
                    ),
                    const SizedBox(height: 12),
                    SecondaryButton(
                      'Back Home',
                      onPressed: () => _goHome(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
