import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../data/models/fiat_beneficiary.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Beneficiary Details — avatar, name + account subtitle, with actions to edit
/// the nickname or remove the beneficiary.
class BeneficiaryDetailsScreen extends StatelessWidget {
  final FiatBeneficiary beneficiary;
  const BeneficiaryDetailsScreen({super.key, required this.beneficiary});

  @override
  Widget build(BuildContext context) {
    final currencyOrCountry = beneficiary.currency ?? beneficiary.country;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Beneficiary Details'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                    color: Color(0xFFE6ECFF), shape: BoxShape.circle),
                child: const AppIcon('folder-user',
                    size: 32, color: AppColors.primaryDark),
              ),
              const SizedBox(height: 16),
              Text(beneficiary.displayName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 22)),
              const SizedBox(height: 6),
              Text(
                  '${beneficiary.bankName} • $currencyOrCountry •••• ${beneficiary.accountTail}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppColors.textGrey, fontSize: 13)),
              const SizedBox(height: 24),
              PrimaryButton(
                'Edit Nickname',
                onPressed: () => Navigator.pushNamed(
                    context, AppRoutes.editBeneficiary,
                    arguments: beneficiary),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => Navigator.pushNamed(
                      context, AppRoutes.removeBeneficiary,
                      arguments: beneficiary),
                  child: const Text('Remove Beneficiary'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
