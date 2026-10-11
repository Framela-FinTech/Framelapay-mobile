import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/fiat_transfer.dart';
import '../fiat/widgets/fiat_form_widgets.dart';

/// Screen 9 (Card) — collect card details before verification.
class PayWithCardScreen extends StatefulWidget {
  final FiatTransfer transfer;
  const PayWithCardScreen({super.key, required this.transfer});

  @override
  State<PayWithCardScreen> createState() => _PayWithCardScreenState();
}

class _PayWithCardScreenState extends State<PayWithCardScreen> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  bool _saveCard = false;

  @override
  void dispose() {
    _numberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _continue() {
    final digits = _numberController.text.replaceAll(RegExp(r'\s'), '');
    final last4 = digits.length >= 4
        ? digits.substring(digits.length - 4)
        : '4242';
    Navigator.pushNamed(
      context,
      AppRoutes.cardVerification,
      arguments: widget.transfer.copyWith(cardLabel: 'Visa ****$last4'),
    );
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
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Checkbox(
                          value: _saveCard,
                          activeColor: AppColors.primaryDark,
                          onChanged: (v) =>
                              setState(() => _saveCard = v ?? false),
                        ),
                        const Expanded(
                          child: Text('Save this card for the future transfer',
                              style: TextStyle(fontSize: 13)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
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
              child: PrimaryButton('Continue', onPressed: _continue),
            ),
          ],
        ),
      ),
    );
  }
}
