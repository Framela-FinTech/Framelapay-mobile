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
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Confirm Beneficiary'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                          color: Color(0xFFE3F7EC), shape: BoxShape.circle),
                      child: const AppIcon('shield-tick',
                          size: 34, color: AppColors.success),
                    ),
                    const SizedBox(height: 16),
                    Text(beneficiary.displayName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 22)),
                    const SizedBox(height: 8),
                    const Text('Account verified — simulated provider response',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.textGrey, fontSize: 13)),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.inputFill,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const AppIcon('info-circle',
                              size: 18, color: AppColors.textGrey),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                                '${beneficiary.bankName} • •••• ${beneficiary.accountTail}',
                                style: const TextStyle(fontSize: 13)),
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
                        context, AppRoutes.beneficiarySaved),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                        side: const BorderSide(color: AppColors.divider),
                        foregroundColor: AppColors.primaryDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Edit Details'),
                    ),
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
