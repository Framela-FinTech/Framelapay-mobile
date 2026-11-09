import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/fiat_transfer.dart';
import '../fiat/widgets/fiat_form_widgets.dart';

/// Screen 9 (Card) — collect card details before verification.
///
/// The board's frame for this screen was duplicated from Destination and only
/// partly re-labelled: it carries that screen's "Where Are You Sending
/// Money?" heading, a "Select destination country" placeholder on the card
/// number, a second field labelled "Expiry Date" where the CVV belongs, and
/// picker chevrons on two plain text fields. All four are slips, so the
/// sensible version ships here.
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
    final last4 =
        digits.length >= 4 ? digits.substring(digits.length - 4) : '4242';
    Navigator.pushNamed(
      context,
      AppRoutes.cardVerification,
      arguments: widget.transfer.copyWith(cardLabel: 'Visa ****$last4'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Pay With Card'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                // The board keeps the whole form, the save-card checkbox and
                // the notice inside one white surface.
                child: InfoCard(
                  padding: const EdgeInsets.all(16),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // The board shows Mastercard and Visa marks here; no
                    // card-brand assets exist yet, so the row is the title
                    // alone until they are supplied.
                    const SectionTitle('Card Information'),
                    const SizedBox(height: 18),
                    const FieldLabel('Card Number'),
                    AppTextInput(
                      controller: _numberController,
                      keyboardType: TextInputType.number,
                      hint: '1234 5678 9012 3456',
                      maxLength: 19,
                    ),
                    const SizedBox(height: 18),
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
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Checkbox(
                          value: _saveCard,
                          activeColor: AppColors.primaryDark,
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onChanged: (v) =>
                              setState(() => _saveCard = v ?? false),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text('Save this card for the future transfer',
                              style: TextStyle(
                                  color: AppColors.primaryDark, fontSize: 14)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const NoticeBanner(
                      'Your card details are encrypted and securely processed.',
                      type: NoticeType.warning,
                      icon: Icons.lock_outline,
                      iconColor: AppColors.primaryDark,
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
