import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/fiat_transfer.dart';
import 'widgets/fiat_form_widgets.dart';

/// Screen 14 — fiat transaction details. Separate from the stablecoin details
/// screen because the row set differs (bank/payment-method vs network/wallet).
/// Back gesture goes Home.
class FiatTransactionDetailsScreen extends StatelessWidget {
  final FiatTransfer transfer;
  const FiatTransactionDetailsScreen({super.key, required this.transfer});

  void _goHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.home, (route) => false);
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
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text('Transaction Details',
              style: TextStyle(color: Colors.black, fontSize: 16)),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                            color: AppColors.success, shape: BoxShape.circle),
                        child: const Icon(Icons.check,
                            color: Colors.white, size: 32),
                      ),
                      const SizedBox(height: 16),
                      const Text('Transfer completed',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20)),
                      const SizedBox(height: 4),
                      Text(t.transactionId,
                          style: const TextStyle(
                              color: AppColors.textGrey, fontSize: 12)),
                      const SizedBox(height: 24),
                      SummaryRow('Transaction Id', t.transactionId),
                      SummaryRow('From', t.senderName),
                      SummaryRow('You sent', t.formattedSendAmount),
                      SummaryRow('Fee', t.formattedFee),
                      SummaryRow('Exchange rate', t.formattedRate),
                      SummaryRow(
                          'Recipient receives', t.formattedReceiveAmount),
                      SummaryRow('Recipient', b?.fullName ?? '—'),
                      SummaryRow('Bank', b?.bankName ?? '—'),
                      SummaryRow('Payment method', t.methodLabel),
                      const SummaryRow('Delivery', 'Completed'),
                      SummaryRow('Date & Time', t.dateTime),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Column(
                  children: [
                    PrimaryButton('Share Receipt', onPressed: () {}),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => _goHome(context),
                      child: const Text('Back to Home'),
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
