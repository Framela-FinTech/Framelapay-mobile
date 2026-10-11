import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../data/models/fiat_transfer.dart';
import '../fiat/widgets/fiat_form_widgets.dart';

/// Screen 10 (Card) — 6-digit email verification before the review step.
class CardVerificationScreen extends StatefulWidget {
  final FiatTransfer transfer;
  const CardVerificationScreen({super.key, required this.transfer});

  @override
  State<CardVerificationScreen> createState() => _CardVerificationScreenState();
}

class _CardVerificationScreenState extends State<CardVerificationScreen> {
  static const _resendSeconds = 42; // 00:42
  int _remaining = _resendSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _remaining = _resendSeconds);
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

  String get _resendText {
    final m = (_remaining ~/ 60).toString().padLeft(2, '0');
    final s = (_remaining % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.transfer;
    final defaultPinTheme = PinTheme(
      width: 44,
      height: 52,
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Card Verification'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                          color: AppColors.inputFill, shape: BoxShape.circle),
                      child: const AppIcon('shield',
                          color: AppColors.primaryDark, size: 32),
                    ),
                    const SizedBox(height: 16),
                    const Text('Enter verification code',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)),
                    const SizedBox(height: 6),
                    const Text(
                        'Enter the 6-digit code sent to your E-mail to complete this payment',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.textGrey, fontSize: 12)),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.inputFill,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          SummaryRow('Amount', t.formattedSendAmount),
                          SummaryRow('Card', t.cardLabel ?? 'Visa ****4242'),
                          SummaryRow(
                              'Recipient', t.beneficiary?.fullName ?? '—'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Pinput(
                      length: 6,
                      defaultPinTheme: defaultPinTheme,
                      separatorBuilder: (_) => const SizedBox(width: 8),
                    ),
                    const SizedBox(height: 16),
                    _remaining > 0
                        ? Text('Resend code in $_resendText',
                            style: const TextStyle(
                                color: AppColors.textGrey, fontSize: 12))
                        : TextButton(
                            onPressed: _startTimer,
                            child: const Text('Resend code'),
                          ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: PrimaryButton(
                'Verify payment',
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.fiatReviewTransfer,
                  arguments: t,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
