import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/fiat_transfer.dart';
import '../fiat/widgets/fiat_form_widgets.dart';

/// Screen 10 (Card) — 6-digit email verification before the review step.
///
/// The board labels the middle summary row "CArd"; shipped as "Card".
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
    // Themed locally: pinput is also used by phone_verification_screen and
    // verify_email_screen, which keep their own look.
    final defaultPinTheme = PinTheme(
      width: 46,
      height: 54,
      textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryDark),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Card Verification'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  children: [
                    const IconBadge(
                      icon: 'mail',
                      halo: AppColors.infoHalo,
                      size: 88,
                      glyphSize: 36,
                    ),
                    const SizedBox(height: 16),
                    const ScreenHeading(
                      'Enter Verification Code',
                      helper: 'Enter the 6-digit code sent to your E-mail to '
                          'complete this payment',
                      center: true,
                    ),
                    const SizedBox(height: 28),
                    InfoCard(
                      children: [
                        SummaryRow('Amount', t.formattedSendAmount),
                        const Divider(height: 1, color: AppColors.divider),
                        SummaryRow('Card', t.cardLabel ?? 'Visa ****4242'),
                        const Divider(height: 1, color: AppColors.divider),
                        SummaryRow(
                            'Recipient', t.beneficiary?.displayName ?? '—'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Pinput(
                      length: 6,
                      defaultPinTheme: defaultPinTheme,
                      separatorBuilder: (_) => const SizedBox(width: 8),
                    ),
                    const SizedBox(height: 16),
                    _remaining > 0
                        ? Text.rich(
                            TextSpan(
                              text: 'Resend code in ',
                              style: const TextStyle(
                                  color: AppColors.textGrey, fontSize: 14),
                              children: [
                                TextSpan(
                                  text: _resendText,
                                  style: const TextStyle(
                                      color: AppColors.primaryDark,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          )
                        : TextButton(
                            onPressed: _startTimer,
                            child: const Text('Resend code'),
                          ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: PrimaryButton(
                'Verify Payment',
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
