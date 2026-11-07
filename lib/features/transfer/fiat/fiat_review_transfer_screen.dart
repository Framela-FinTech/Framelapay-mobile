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
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Review Transfer'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // The board puts each section's header and its Edit link
                    // outside the card it introduces.
                    SectionHeader(
                      'Recipient',
                      actionLabel: 'Edit',
                      // `|| isFirst` guarantees termination: a bare name
                      // predicate empties the stack if that route is gone.
                      onAction: () => Navigator.popUntil(
                        context,
                        (r) =>
                            r.settings.name == AppRoutes.fiatSelectRecipient || r.isFirst,
                      ),
                    ),
                    const SizedBox(height: 10),
                    InfoCard(
                      children: [
                        SummaryRow('Recipient',
                            '${b?.displayName ?? '—'} · ${b?.bankName ?? '—'}'),
                        const Divider(height: 1, color: AppColors.divider),
                        SummaryRow('Account', b?.listSubtitle ?? '—'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SectionHeader(
                      'Payment details',
                      actionLabel: 'Edit',
                      // `|| isFirst` guarantees termination: a bare name
                      // predicate empties the stack if that route is gone.
                      onAction: () => Navigator.popUntil(
                        context,
                        (r) =>
                            r.settings.name == AppRoutes.fiatTransferDetails || r.isFirst,
                      ),
                    ),
                    const SizedBox(height: 10),
                    InfoCard(
                      children: [
                        SummaryRow('You send', t.formattedSendAmount),
                        const Divider(height: 1, color: AppColors.divider),
                        SummaryRow('Transfer fee', t.formattedFee),
                        const Divider(height: 1, color: AppColors.divider),
                        SummaryRow('Total you pay', t.formattedTotal),
                        const Divider(height: 1, color: AppColors.divider),
                        SummaryRow('Exchange rate', t.formattedRate),
                        const Divider(height: 1, color: AppColors.divider),
                        SummaryRow(
                            'Recipient receives', t.formattedReceiveAmount),
                      ],
                    ),
                    const SizedBox(height: 14),
                    InfoCard(
                      children: [
                        SummaryRow('Payment method', t.methodLabel),
                        const Divider(height: 1, color: AppColors.divider),
                        SummaryRow('Purpose', t.purpose),
                        const Divider(height: 1, color: AppColors.divider),
                        SummaryRow('Estimated delivery', t.deliveryEstimate),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const NoticeBanner(
                      'Check the recipient and amounts before you confirm.',
                      background: AppColors.infoNotice,
                    ),
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
