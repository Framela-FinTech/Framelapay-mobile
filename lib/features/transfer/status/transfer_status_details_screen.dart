import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/ongoing_transfer.dart';
import '../fiat/widgets/fiat_form_widgets.dart';

/// "Transfer Details" for an in-flight transfer — the money and the
/// destination, with a way to report a problem.
///
/// Not the same as the completed-transfer receipt: nothing has settled, so
/// there is no receipt to share.
class TransferStatusDetailsScreen extends StatelessWidget {
  final OngoingTransfer transfer;
  const TransferStatusDetailsScreen({super.key, required this.transfer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Transfer Details'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusPill(transfer.stage.label),
                    const SizedBox(height: 14),
                    InfoCard(
                      children: [
                        SummaryRow('Recipient', transfer.recipient),
                        const Divider(height: 1, color: AppColors.divider),
                        SummaryRow('You send', transfer.youSend),
                        const Divider(height: 1, color: AppColors.divider),
                        SummaryRow('Fee', transfer.fee),
                        const Divider(height: 1, color: AppColors.divider),
                        SummaryRow('Total payment', transfer.totalPayment),
                        const Divider(height: 1, color: AppColors.divider),
                        SummaryRow(
                            'Recipient receives', transfer.recipientReceives),
                        const Divider(height: 1, color: AppColors.divider),
                        SummaryRow('Reference', transfer.reference),
                      ],
                    ),
                    const SizedBox(height: 14),
                    InfoCard(
                      children: [
                        SummaryRow(
                            'Destination bank', transfer.destinationBank),
                        const Divider(height: 1, color: AppColors.divider),
                        SummaryRow('Account number', transfer.accountNumber),
                        const Divider(height: 1, color: AppColors.divider),
                        SummaryRow('Initiated', transfer.startedAt),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                children: [
                  PrimaryButton(
                    'Report a problem',
                    onPressed: () => Navigator.pushNamed(
                        context, AppRoutes.helpSupport),
                  ),
                  const SizedBox(height: 12),
                  SecondaryButton(
                    'Go to transfers',
                    onPressed: () => Navigator.popUntil(
                      context,
                      (r) =>
                          r.settings.name == AppRoutes.transferStatus ||
                          r.isFirst,
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
}
