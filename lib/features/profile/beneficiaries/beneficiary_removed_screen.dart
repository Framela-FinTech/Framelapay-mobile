import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Beneficiary Removed — confirmation state after deleting a saved recipient.
/// Matches Row 2, Frame 3 of the `Beneficiary.png` Figma board.
/// (The board copies the "Remove Beneficiary?" title onto this frame; the
/// heading and semantics are "Beneficiary Removed".)
class BeneficiaryRemovedScreen extends StatelessWidget {
  const BeneficiaryRemovedScreen({super.key});

  void _toBeneficiaries(BuildContext context) {
    Navigator.popUntil(
      context,
      (r) => r.settings.name == AppRoutes.beneficiariesList || r.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _toBeneficiaries(context);
      },
      child: Scaffold(
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
                        'Beneficiary Removed',
                        helper:
                            'This beneficiary has been removed from your saved list.',
                        center: true,
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
}
