import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../data/models/fiat_beneficiary.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Beneficiary Saved — success screen after saving a new recipient.
/// Matches Row 1, Frame 4 of the `Beneficiary.png` Figma board.
class BeneficiarySavedScreen extends StatelessWidget {
  final FiatBeneficiary? beneficiary;

  const BeneficiarySavedScreen({super.key, this.beneficiary});

  void _toBeneficiaries(BuildContext context) {
    Navigator.popUntil(
      context,
      (r) => r.settings.name == AppRoutes.beneficiariesList || r.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bank = beneficiary?.bankName.isNotEmpty == true
        ? beneficiary!.bankName
        : 'OPay Digital Services Limited';
    final account = beneficiary?.accountNumber.isNotEmpty == true
        ? beneficiary!.accountNumber
        : '7055036089';
    final country = beneficiary?.country.isNotEmpty == true
        ? beneficiary!.country
        : 'Nigeria';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _toBeneficiaries(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.pageGrey,
        appBar: whiteAppBar('Beneficiary Saved'),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                  child: Column(
                    children: [
                      const IconBadge(
                        icon: 'check-circle',
                        halo: AppColors.successSoft,
                        size: 88,
                        glyphSize: 36,
                        glyphColor: AppColors.success,
                      ),
                      const SizedBox(height: 18),
                      const ScreenHeading(
                        'Beneficiary saved',
                        helper:
                            'This recipient is now available in your saved list.',
                        center: true,
                      ),
                      const SizedBox(height: 28),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Column(
                          children: [
                            _detailRow('bank', 'BANK', bank),
                            const Divider(
                                height: 24, color: AppColors.divider),
                            _detailRow('card', 'ACCOUNT NUMBER', account),
                            const Divider(
                                height: 24, color: AppColors.divider),
                            _detailRow('card', 'RECIPIENT COUNTRY', country),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: PrimaryButton(
                  'Return to Beneficiaries',
                  onPressed: () => _toBeneficiaries(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.iconTileSoft,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: AppIcon(icon, size: 20, color: AppColors.primaryDark),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
