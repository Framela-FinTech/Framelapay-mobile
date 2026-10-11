import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/fiat_transfer.dart';
import '../../../data/models/processing_step.dart';
import '../../../data/models/transfer_auth_flow.dart';
import 'widgets/fiat_form_widgets.dart';

/// Screen 11 — shared review step for all fiat flows. "Confirm Transfer"
/// builds the neutral [TransferAuthFlow] (fiat processing steps + the
/// "Transfer completed" completion target) and hands it to the shared
/// fingerprint/passcode gate.
class FiatReviewTransferScreen extends StatelessWidget {
  final FiatTransfer transfer;
  const FiatReviewTransferScreen({super.key, required this.transfer});

  TransferAuthFlow _authFlow() {
    final country = transfer.beneficiary?.country ?? 'Recipient';
    return TransferAuthFlow(
      completionRoute: AppRoutes.transferCompleted,
      completionArgs: transfer,
      processingSteps: [
        const ProcessingStep(
            title: 'Transfer initiated',
            time: '10:41 AM',
            subtitle: 'Your transfer has been created',
            done: true),
        const ProcessingStep(
            title: 'Payment received',
            time: '10:42 AM',
            subtitle: 'We have received your payment',
            done: true),
        const ProcessingStep(
            title: 'Compliance checks',
            time: '10:43 AM',
            subtitle: 'We are verifying your transaction',
            done: true),
        const ProcessingStep(
            title: 'FX processing', subtitle: 'Converting your funds'),
        ProcessingStep(
            title: '$country payout',
            subtitle: "Sending to recipient's bank"),
        const ProcessingStep(
            title: 'Completed', subtitle: 'Transfer will be completed soon'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = transfer;
    final b = t.beneficiary;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Review Transfer'),
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
                    const SectionTitle('Transfer Summary'),
                    const SizedBox(height: 8),
                    SummaryRow('To', b?.fullName ?? '—'),
                    SummaryRow('Bank', b?.bankName ?? '—'),
                    SummaryRow('Exchange rate', t.formattedRate),
                    SummaryRow('You send', t.formattedSendAmount),
                    SummaryRow('Recipient receives', t.formattedReceiveAmount),
                    SummaryRow('Fee', t.formattedFee),
                    SummaryRow('Delivery', t.deliveryEstimate),
                    SummaryRow('Purpose', t.purpose),
                    const SizedBox(height: 16),
                    const NoticeBanner(
                      'Ensure all details are correct before you confirm.',
                      type: NoticeType.warning,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: PrimaryButton(
                'Confirm Transfer',
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.verifyFingerprint,
                  arguments: _authFlow(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
