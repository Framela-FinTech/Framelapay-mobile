import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../data/models/fiat_transfer.dart';
import '../fiat/widgets/fiat_form_widgets.dart';

/// Screen 7 (Bank) — simulated redirect to the user's banking app.
/// Auto-advances to the payment-instruction screen after ~3s.
class BankRedirectScreen extends StatefulWidget {
  final FiatTransfer transfer;
  const BankRedirectScreen({super.key, required this.transfer});

  @override
  State<BankRedirectScreen> createState() => _BankRedirectScreenState();
}

class _BankRedirectScreenState extends State<BankRedirectScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.bankPaymentInstruction,
          arguments: widget.transfer,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Bank Transfer'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                    color: AppColors.inputFill, shape: BoxShape.circle),
                child: const AppIcon('bank',
                    color: AppColors.primaryDark, size: 32),
              ),
              const SizedBox(height: 20),
              const Text('Redirecting you to your bank',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
              const SizedBox(height: 8),
              const Text(
                  "You'll complete the transfer securely in your bank's app.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
              const SizedBox(height: 24),
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                    strokeWidth: 3, color: AppColors.accentYellow),
              ),
              const SizedBox(height: 24),
              const Text(
                  'You will return to Framela automatically after completing the transfer',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textGrey, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}
