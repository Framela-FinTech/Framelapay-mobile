import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/correction_request.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';
import 'personal_info_widgets.dart';

/// Step 5: Request Status Screen.
/// Matches Frame 5 of Row 0, Row 1, and Row 2 of `Personal Information Edit.png`.
class CorrectionRequestStatusScreen extends StatelessWidget {
  final CorrectionRequest request;

  const CorrectionRequestStatusScreen({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    final isAddress = request.requestType == 'Residential address';
    final bodyText = isAddress
        ? "Your current address is still active. We'll update it if the request is approved."
        : "Your original profile detail is still active. We'll update it if the request is approved.";

    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Request Status'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warningPill,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Under review',
                        style: TextStyle(
                          color: Color(0xFF854D0E),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ScreenHeading(request.title),
                    const SizedBox(height: 8),
                    Text(
                      bodyText,
                      style: const TextStyle(
                        color: AppColors.neutral60,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Status Details Card
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.divider, width: 1),
                      ),
                      child: Column(
                        children: [
                          ReviewDetailRow(
                            label: 'Current',
                            value: request.currentValue,
                          ),
                          ReviewDetailRow(
                            label: 'Requested',
                            value: request.requestedValue,
                          ),
                          ReviewDetailRow(
                            label: 'Reference',
                            value: request.reference,
                          ),
                          ReviewDetailRow(
                            label: 'Status',
                            value: request.status,
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Timeline Stepper
                    const TimelineStepper(activeStep: 1),
                  ],
                ),
              ),
            ),
            BottomBar(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PrimaryButton(
                    'Back to Personal Information',
                    onPressed: () {
                      Navigator.popUntil(
                        context,
                        (route) =>
                            route.settings.name ==
                            AppRoutes.personalInformation,
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  SecondaryButton(
                    'Back to Profile',
                    onPressed: () {
                      Navigator.popUntil(
                        context,
                        (route) =>
                            route.settings.name == AppRoutes.profile ||
                            route.isFirst,
                      );
                    },
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
