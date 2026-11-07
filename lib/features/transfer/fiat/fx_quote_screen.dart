import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/fiat_transfer.dart';
import '../../../data/models/transfer_method.dart';
import 'widgets/fiat_form_widgets.dart';

/// Screen 6 — locked FX quote with a countdown timer. Shared by all flows;
/// Continue routes to the method-specific next step.
class FxQuoteScreen extends StatefulWidget {
  final FiatTransfer transfer;
  const FxQuoteScreen({super.key, required this.transfer});

  @override
  State<FxQuoteScreen> createState() => _FxQuoteScreenState();
}

class _FxQuoteScreenState extends State<FxQuoteScreen> {
  static const _lockSeconds = 170; // 02:50
  int _remaining = _lockSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_remaining == 0) {
        _timer?.cancel();
        return;
      }
      setState(() => _remaining--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _timerText {
    final m = (_remaining ~/ 60).toString().padLeft(2, '0');
    final s = (_remaining % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _continue() {
    final t = widget.transfer;
    switch (t.method) {
      case TransferMethod.bank:
        Navigator.pushNamed(context, AppRoutes.bankRedirect, arguments: t);
        break;
      case TransferMethod.card:
        Navigator.pushNamed(context, AppRoutes.payWithCard, arguments: t);
        break;
      case TransferMethod.wallet:
        Navigator.pushNamed(context, AppRoutes.fiatReviewTransfer,
            arguments: t);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.transfer;
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('FX Quote'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  children: [
                    const IconBadge(
                      icon: 'coin-swap',
                      halo: AppColors.infoHalo,
                      glyphColor: AppColors.primary50,
                    ),
                    const SizedBox(height: 14),
                    ScreenHeading(
                      'Your transfer quote',
                      helper:
                          '${t.sendCurrencyCode} to ${t.receiveCurrencyCode} · ${t.methodLabel}',
                      center: true,
                    ),
                    const SizedBox(height: 22),
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
                        SummaryRow('Recipient receives',
                            t.formattedReceiveAmount, bold: true),
                      ],
                    ),
                    const SizedBox(height: 18),
                    QuoteLockPill('Quote expires in $_timerText'),
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Refresh your quote if the timer expires.',
                          style: TextStyle(
                              color: AppColors.textGrey, fontSize: 13)),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: PrimaryButton('Continue', onPressed: _continue),
            ),
          ],
        ),
      ),
    );
  }
}
