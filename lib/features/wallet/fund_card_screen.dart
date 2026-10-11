import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/currency_wallet.dart';
import '../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Card funding for Add Money — minimal card entry that leads straight to a
/// funding-success screen (does NOT enter the send/review flow).
class FundCardScreen extends StatefulWidget {
  final CurrencyWallet wallet;
  const FundCardScreen({super.key, required this.wallet});

  @override
  State<FundCardScreen> createState() => _FundCardScreenState();
}

class _FundCardScreenState extends State<FundCardScreen> {
  final _numberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _numberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Pay with card'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text('Add money to your ${widget.wallet.name} Wallet',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)),
                    const SizedBox(height: 6),
                    const Text(
                        'Enter your card details to fund this wallet.',
                        style: TextStyle(
                            color: AppColors.textGrey, fontSize: 12)),
                    const SizedBox(height: 20),
                    const SectionTitle('Card Information'),
                    const SizedBox(height: 16),
                    const FieldLabel('Card Number'),
                    AppTextInput(
                      controller: _numberController,
                      keyboardType: TextInputType.number,
                      hint: '1234 5678 9012 3456',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const FieldLabel('Expiry Date'),
                              AppTextInput(
                                controller: _expiryController,
                                keyboardType: TextInputType.number,
                                hint: 'MM/YY',
                                maxLength: 5,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const FieldLabel('CVV'),
                              AppTextInput(
                                controller: _cvvController,
                                keyboardType: TextInputType.number,
                                hint: '123',
                                maxLength: 4,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const NoticeBanner(
                      'Your card details are encrypted and securely processed.',
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: PrimaryButton(
                'Add Money',
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.addMoneySuccess,
                  arguments: widget.wallet,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
