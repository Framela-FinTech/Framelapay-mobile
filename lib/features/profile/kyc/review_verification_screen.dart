import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Review Verification — summary of the entered details with per-section Edit
/// links before submitting the upgrade.
class ReviewVerificationScreen extends StatelessWidget {
  const ReviewVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Review Verification'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _reviewCard(
                        'Identity document',
                        'International passport •••• 4821',
                        () => Navigator.popUntil(context,
                            ModalRoute.withName(AppRoutes.profileKycIdentity))),
                    const SizedBox(height: 12),
                    _reviewCard(
                        'Residential address',
                        'Victoria Island, Lagos',
                        () => Navigator.popUntil(context,
                            ModalRoute.withName(AppRoutes.profileKycAddress))),
                    const SizedBox(height: 12),
                    _reviewCard(
                        'Source of funds',
                        'Employment income',
                        () => Navigator.popUntil(
                            context,
                            ModalRoute.withName(
                                AppRoutes.profileKycSourceOfFunds))),
                    const SizedBox(height: 14),
                    const NoticeBanner(
                      'By submitting, you confirm that the information provided '
                      'is accurate.',
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: PrimaryButton(
                'Submit Verification',
                onPressed: () => Navigator.pushNamed(
                    context, AppRoutes.profileKycSubmitted),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reviewCard(String label, String value, VoidCallback onEdit) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: AppColors.textGrey, fontSize: 13)),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 16)),
              ],
            ),
          ),
          GestureDetector(
            onTap: onEdit,
            child: const Text('Edit',
                style: TextStyle(
                    color: AppColors.primary50,
                    fontWeight: FontWeight.w600,
                    fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
