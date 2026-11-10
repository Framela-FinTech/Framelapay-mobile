import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/receipt_card.dart';
import '../../../core/widgets/share_receipt_sheet.dart';
import '../../../data/models/conversion_result.dart';
import '../fiat/widgets/fiat_form_widgets.dart';

/// The shareable receipt for a completed conversion, rendered with the shared
/// [ReceiptCard] the transfer and Statements receipts use.
class ConversionReceiptScreen extends StatelessWidget {
  final ConversionResult result;
  const ConversionReceiptScreen({super.key, required this.result});

  void _goHome(BuildContext context) =>
      Navigator.popUntil(context, (route) => route.isFirst);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  headlineAmount: result.formattedReceived,
                  caption: 'Funds converted · ${result.to.code} Wallet',
                  reference: result.reference,
                  note: 'Conversion Completed',
                  rows: [
                    ReceiptLine('From', '${result.from.code} Wallet'),
                    ReceiptLine('To', '${result.to.code} Wallet'),
                    ReceiptLine(
                        'Converted from', result.formattedConverted),
                    ReceiptLine('Fee', result.formattedFee),
                    ReceiptLine('Amount received', result.formattedReceived),
                    ReceiptLine('Exchange rate', result.rateText),
                    ReceiptLine('Conversion type', 'Wallet conversion'),
                    ReceiptLine('Date and time', result.dateTime),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                children: [
                  PrimaryButton('Share Receipt',
                      onPressed: () => showShareReceiptSheet(context)),
                  const SizedBox(height: 12),
                  SecondaryButton('Back Home',
                      onPressed: () => _goHome(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
