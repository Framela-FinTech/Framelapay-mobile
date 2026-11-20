import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/fiat_beneficiary.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Remove Beneficiary? — confirmation screen before deleting a saved recipient.
/// Matches Row 2, Frame 2 of the `Beneficiary.png` Figma board.
class RemoveBeneficiaryScreen extends StatelessWidget {
  final FiatBeneficiary beneficiary;

  const RemoveBeneficiaryScreen({super.key, required this.beneficiary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Remove Beneficiary?'),
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 36, 20, 24),
                child: Column(
                  children: [
                    IconBadge(
                      icon: 'trash',
                      halo: Color(0xFFFEE2E2),
                      glyphColor: AppColors.error,
                      size: 88,
                      glyphSize: 36,
                    ),
                    SizedBox(height: 20),
                    ScreenHeading(
                      'Remove Beneficiary?',
                      center: true,
                    ),
                    SizedBox(height: 24),
                    NoticeBanner(
                      'This removes the saved recipient. Previous transaction '
                      'records remain available.',
                      type: NoticeType.warning,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.beneficiaryRemoved,
                      ),
                      child: const Text(
                        'Remove Beneficiary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SecondaryButton(
                    'Cancel',
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
