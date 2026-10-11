import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../data/models/fiat_transfer.dart';
import '../fiat/widgets/fiat_form_widgets.dart';

/// Screen 8 (Bank) — manual bank-transfer instructions with copyable fields.
class PaymentInstructionScreen extends StatelessWidget {
  final FiatTransfer transfer;
  const PaymentInstructionScreen({super.key, required this.transfer});

  @override
  Widget build(BuildContext context) {
    final t = transfer;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Payment Instruction'),
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
                    const ScreenHeading('Complete your bank transfer'),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.inputFill,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _copyRow('Amount to Transfer', t.formattedTotal),
                          _copyRow('Bank Name', t.beneficiary?.bankName ?? '—'),
                          _copyRow('IBAN Number', '123456789'),
                          _copyRow('Payment Reference', 'FRM123456789'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const NoticeBanner(
                      'Send the exact amount to the account below using the reference provided. Use the payment reference as narration.',
                      title: 'Important',
                      type: NoticeType.warning,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: PrimaryButton(
                "I've Made the Transfer",
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

  Widget _copyRow(String label, String value) {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style:
                    const TextStyle(color: AppColors.textGrey, fontSize: 13)),
            Row(
              children: [
                Text(value,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () =>
                      Clipboard.setData(ClipboardData(text: value)),
                  child: const AppIcon('copy',
                      size: 14, color: AppColors.textGrey),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
