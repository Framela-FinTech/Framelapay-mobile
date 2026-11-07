import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/fiat_transfer.dart';
import 'widgets/fiat_form_widgets.dart';

/// Screen 5 — "Confirm Recipient": the verified account, for a last look
/// before the quote.
class AccountVerifiedScreen extends StatelessWidget {
  final FiatTransfer transfer;
  const AccountVerifiedScreen({super.key, required this.transfer});

  @override
  Widget build(BuildContext context) {
    final b = transfer.beneficiary;
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Confirm Recipient'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                          color: AppColors.success, shape: BoxShape.circle),
                      child:
                          const Icon(Icons.check, color: Colors.white, size: 32),
                    ),
                    const SizedBox(height: 16),
                    const ScreenHeading(
                      'Account verified',
                      helper: 'Please confirm the recipient details.',
                      center: true,
                    ),
                    const SizedBox(height: 22),
                    InfoCard(
                      children: [
                        SummaryRow('Recipient', b?.displayName ?? '—'),
                        const Divider(height: 1, color: AppColors.divider),
                        SummaryRow('Bank', b?.bankName ?? '—'),
                        const Divider(height: 1, color: AppColors.divider),
                        SummaryRow('Account number', b?.accountNumber ?? '—'),
                        const Divider(height: 1, color: AppColors.divider),
                        SummaryRow('Country', b?.country ?? '—'),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const NoticeBanner(
                      'Account details checked. Confirm this is the person you '
                      'intend to pay.',
                      type: NoticeType.success,
                      background: AppColors.successNotice,
                    ),
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
                  const SizedBox(height: 12),
                  SecondaryButton(
                    'Edit Details',
                    onPressed: () => Navigator.pop(context),
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
