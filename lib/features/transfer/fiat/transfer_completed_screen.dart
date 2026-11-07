import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/fiat_transfer.dart';
import 'widgets/fiat_form_widgets.dart';

/// Screen 13 — full-page success confirmation. Back gesture goes Home.
class TransferCompletedScreen extends StatelessWidget {
  final FiatTransfer transfer;
  const TransferCompletedScreen({super.key, required this.transfer});

  void _goHome(BuildContext context) {
    // Walk back down to the Home root (the single cleared root). Never uses
    // removeUntil so it can't leave a rootless stack; isFirst can't exit.
    Navigator.popUntil(context, (route) => route.isFirst);
  }

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
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: const BoxDecoration(
                            color: AppColors.success, shape: BoxShape.circle),
                        child: const Icon(Icons.check,
                            color: Colors.white, size: 36),
                      ),
                      const SizedBox(height: 18),
                      const ScreenHeading(
                        'Transfer completed',
                        helper:
                            "Your recipient's bank has received the payout.",
                        center: true,
                      ),
                      const SizedBox(height: 22),
                      InfoCard(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 22),
                        children: [
                          Text(t.formattedReceiveAmount,
                              style: const TextStyle(
                                  color: AppColors.primaryDark,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 28)),
                          const SizedBox(height: 10),
                          const Text('Sent to',
                              style: TextStyle(
                                  color: AppColors.textGrey, fontSize: 14)),
                          const SizedBox(height: 4),
                          Text(b?.displayName ?? '—',
                              style: const TextStyle(
                                  color: AppColors.primaryDark,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(b?.bankAccountLine ?? '—',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: AppColors.textGrey, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      InfoCard(
                        children: [
                          SummaryRow('Transaction reference', t.transactionId),
                          const Divider(height: 1, color: AppColors.divider),
                          SummaryRow(t.status, t.dateTime),
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
                      'View Receipt',
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.fiatTransactionDetails,
                        arguments: t,
                      ),
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
