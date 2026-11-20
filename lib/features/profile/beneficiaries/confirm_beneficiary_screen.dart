import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../data/models/fiat_beneficiary.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Confirm Beneficiary — shows the simulated account-verification result before
/// saving the recipient.
class ConfirmBeneficiaryScreen extends StatelessWidget {
  final FiatBeneficiary beneficiary;

  const ConfirmBeneficiaryScreen({super.key, required this.beneficiary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Confirm Beneficiary'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  children: [
                    const IconBadge(
                      icon: 'shield-tick',
                      halo: AppColors.successSoft,
                      size: 88,
                      glyphSize: 36,
                      glyphColor: AppColors.success,
                    ),
                    const SizedBox(height: 18),
                    ScreenHeading(
                      beneficiary.displayName,
                      helper: 'Account verified — simulated provider response',
                      center: true,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Row(
                        children: [
                          const AppIcon('info-circle',
                              size: 18, color: AppColors.textGrey),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '${beneficiary.bankName} • •••• ${beneficiary.accountTail}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                    'Save Beneficiary',
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.beneficiarySaved,
                      arguments: beneficiary,
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
