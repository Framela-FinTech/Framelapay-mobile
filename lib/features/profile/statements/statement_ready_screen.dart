import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_icon.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// "Your statement is ready" — shown after generating an account statement.
/// [summary] describes the wallet + date range, e.g.
/// "EUR Wallet • 2026-06-01 to 2026-09-30".
class StatementReadyScreen extends StatelessWidget {
  final String summary;
  const StatementReadyScreen({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Statement Ready'),
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
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                          color: AppColors.inputFill, shape: BoxShape.circle),
                      child: const AppIcon('receipt',
                          size: 34, color: AppColors.primaryDark),
                    ),
                    const SizedBox(height: 20),
                    const Text('Your statement is ready',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 22)),
                    const SizedBox(height: 8),
                    Text(summary,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: AppColors.textGrey, fontSize: 13)),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: PrimaryButton(
                'Download',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Statement downloaded')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
