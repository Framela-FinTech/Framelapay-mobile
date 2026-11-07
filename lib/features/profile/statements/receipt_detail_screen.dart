import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/receipt_card.dart';
import '../../../core/widgets/share_receipt_sheet.dart';
import '../../../data/models/transaction_receipt.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Receipt detail — the branded receipt card plus Share / Back to Activity.
///
/// Renders the same card for every [ReceiptStatus]; the pill colour, the
/// footer note and the body rows come from the receipt itself.
class ReceiptDetailScreen extends StatelessWidget {
  final TransactionReceipt receipt;
  const ReceiptDetailScreen({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Receipt'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: _card(),
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
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        minimumSize: const Size.fromHeight(56),
                        side: const BorderSide(color: AppColors.divider),
                        foregroundColor: AppColors.primaryDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.activity,
                        (route) => route.isFirst,
                      ),
                      child: const Text(
                        'Back to Activity',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
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


  /// Maps the list model's status enum onto the shared card's primitives.
  ReceiptCard _card() {
    late final String label;
    late final Color colour;
    switch (receipt.status) {
      case ReceiptStatus.completed:
        label = 'Completed';
        colour = AppColors.success;
      case ReceiptStatus.failed:
        label = 'Failed';
        colour = AppColors.error;
      case ReceiptStatus.pending:
        label = 'Pending';
        colour = AppColors.warning;
    }
    return ReceiptCard(
      statusLabel: label,
      statusColor: colour,
      headlineAmount: receipt.headlineAmount,
      caption: receipt.caption,
      rows: [for (final r in receipt.rows) ReceiptLine(r.label, r.value)],
      reference: receipt.transactionId,
      note: receipt.statusNote,
    );
  }
}
