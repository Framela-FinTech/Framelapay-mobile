import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/conversion_result.dart';
import '../fiat/widgets/fiat_form_widgets.dart';

/// "Conversion completed" — the outcome of the standalone conversion journey.
/// Same shape as the transfer completion screen: no app bar, the back gesture
/// goes Home.
class ConversionCompletedScreen extends StatelessWidget {
  final ConversionResult result;
  const ConversionCompletedScreen({super.key, required this.result});

  void _goHome(BuildContext context) =>
      Navigator.popUntil(context, (route) => route.isFirst);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
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
                        'Conversion completed',
                        helper:
                            'Your funds have been converted successfully and '
                            'added to your destination wallet.',
                        center: true,
                      ),
                      const SizedBox(height: 22),
                      InfoCard(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 22),
                        children: [
                          Text(result.formattedReceived,
                              style: const TextStyle(
                                  color: AppColors.primaryDark,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 28)),
                          const SizedBox(height: 10),
                          const Text('Added to',
                              style: TextStyle(
                                  color: AppColors.textGrey, fontSize: 14)),
                          const SizedBox(height: 4),
                          Text('${result.to.code} Wallet',
                              style: const TextStyle(
                                  color: AppColors.primaryDark,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16)),
                          const SizedBox(height: 6),
                          Text(
                              'Converted from ${result.formattedConverted}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: AppColors.textGrey, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      InfoCard(
                        children: [
                          SummaryRow(
                              'Transaction reference', result.reference),
                          const Divider(height: 1, color: AppColors.divider),
                          SummaryRow('Completed', result.dateTime),
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
                        AppRoutes.conversionReceipt,
                        arguments: result,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SecondaryButton('Back Home',
                        onPressed: () => _goHome(context)),
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
