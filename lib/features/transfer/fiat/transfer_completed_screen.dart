import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _goHome(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        width: 72,
                        height: 72,
                        decoration: const BoxDecoration(
                            color: AppColors.success, shape: BoxShape.circle),
                        child: const Icon(Icons.check,
                            color: Colors.white, size: 36),
                      ),
                      const SizedBox(height: 20),
                      Text(t.formattedReceiveAmount,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 28)),
                      const SizedBox(height: 8),
                      const Text('has been successfully sent to',
                          style: TextStyle(
                              color: AppColors.textGrey, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(t.beneficiary?.fullName ?? '—',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Transaction ID: ${t.transactionId}',
                              style: const TextStyle(
                                  color: AppColors.textGrey, fontSize: 12)),
                          const SizedBox(width: 6),
                          InkWell(
                            onTap: () => Clipboard.setData(
                                ClipboardData(text: t.transactionId)),
                            child: const AppIcon('copy',
                                size: 14, color: AppColors.textGrey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Column(
                  children: [
                    PrimaryButton(
                      'View Transfer',
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.fiatTransactionDetails,
                        arguments: t,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                          side: const BorderSide(color: AppColors.divider),
                          foregroundColor: AppColors.primaryDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text('Share Receipt'),
                      ),
                    ),
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
