import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/currency_wallet.dart';
import '../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Minimal funding-success screen for the Add Money card path.
/// Terminal screen: back gesture returns Home.
class AddMoneySuccessScreen extends StatelessWidget {
  final CurrencyWallet wallet;
  const AddMoneySuccessScreen({super.key, required this.wallet});

  void _goHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.home, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
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
                      const Text('Wallet funded',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 24)),
                      const SizedBox(height: 8),
                      Text(
                          'Your ${wallet.name} Wallet has been funded successfully.',
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
                  'Back to Home',
                  onPressed: () => _goHome(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
