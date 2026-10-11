import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/fiat_transfer.dart';
import 'widgets/fiat_form_widgets.dart';

/// Screen 5 — confirmation that the recipient account was verified.
class AccountVerifiedScreen extends StatelessWidget {
  final FiatTransfer transfer;
  const AccountVerifiedScreen({super.key, required this.transfer});

  @override
  Widget build(BuildContext context) {
    final b = transfer.beneficiary;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Add Recipient'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                          color: AppColors.success, shape: BoxShape.circle),
                      child: const Icon(Icons.check,
                          color: Colors.white, size: 32),
                    ),
                    const SizedBox(height: 16),
                    const Text('Account verified',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)),
                    const SizedBox(height: 6),
                    const Text('Please confirm the details below.',
                        style: TextStyle(
                            color: AppColors.textGrey, fontSize: 12)),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.inputFill,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          SummaryRow('Recipient Name', b?.fullName ?? '—'),
                          SummaryRow('Bank', b?.bankName ?? '—'),
                          SummaryRow(
                              'Account Number', b?.maskedAccount ?? '—'),
                          SummaryRow('Country', b?.country ?? '—'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const NoticeBanner(
                      'This account has been verified and is ready to receive money.',
                      type: NoticeType.success,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                children: [
                  PrimaryButton(
                    'Confirm Recipient',
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.fiatFxQuote,
                      arguments: transfer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Edit Details'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
