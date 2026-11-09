import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/receipt_card.dart';
import '../../../core/widgets/share_receipt_sheet.dart';
import '../../../data/models/transfer_recipient.dart';
import '../fiat/widgets/fiat_form_widgets.dart';

/// Stablecoin receipt — the same branded artifact the fiat flow and the
/// Statements screens render, via the shared [ReceiptCard]. The board draws
/// this with no app bar; the two actions below the card are the way out.
class TransactionDetailsScreen extends StatelessWidget {
  final TransferRecipient recipient;
  final String senderName;
  final String transactionId;
  final String assetSent;
  final String network;
  final String networkFee;
  final String paymentMethod;
  final String dateTime;

  const TransactionDetailsScreen({
    super.key,
    required this.recipient,
    this.senderName = 'Cynthia Nkechi',
    this.transactionId = 'FRM-20261010-10429',
    this.assetSent = '350 USDC',
    this.network = 'Ethereum',
    this.networkFee = '\$2.50',
    this.paymentMethod = 'Stablecoin',
    this.dateTime = '10 Oct 2026 · 10:45 AM WAT',
  });

  void _goHome(BuildContext context) =>
      Navigator.popUntil(context, (route) => route.isFirst);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _goHome(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.pageGrey,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: ReceiptCard(
                    statusLabel: 'Completed',
                    statusColor: AppColors.success,
                    statusBackground: AppColors.successNotice,
                    headlineAmount: assetSent,
                    caption: 'Coin sent · ${recipient.displayName}',
                    reference: transactionId,
                    note: 'Sample receipt · Not an official financial record',
                    rows: [
                      ReceiptLine('From', senderName),
                      ReceiptLine('To', recipient.displayName),
                      ReceiptLine('Network', network),
                      ReceiptLine('Asset sent', assetSent),
                      ReceiptLine('Network fee', networkFee),
                      ReceiptLine('Wallet address', recipient.shortAddress),
                      ReceiptLine('Recipient receives', assetSent),
                      ReceiptLine('Payment method', paymentMethod),
                      ReceiptLine('Status', 'Completed'),
                      ReceiptLine('Date and time', dateTime),
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
