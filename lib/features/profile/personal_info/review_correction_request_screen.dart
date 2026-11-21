import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/correction_request.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';
import 'personal_info_widgets.dart';

/// Step 3 of Personal Information correction/editing flows.
/// Matches Frame 3 of Row 0, Row 1, and Row 2 of `Personal Information Edit.png`.
class ReviewCorrectionRequestScreen extends StatelessWidget {
  final CorrectionRequest request;

  const ReviewCorrectionRequestScreen({
    super.key,
    required this.request,
  });

  void _onSubmit(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.correctionRequestSubmitted,
      arguments: request,
    );
  }

  @override
  Widget build(BuildContext context) {
    final type = request.requestType;
    final isAddress = type == 'Residential address';
    final heading = isAddress ? 'Review address change' : 'Review correction';
    final subtext = isAddress
        ? 'Please confirm your new address and supporting document.'
        : 'Please confirm the details you are asking us to review.';
    final buttonLabel = type == 'Full name' ? 'Continue' : 'Submit request';

    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Review Request'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StepSubtitle('STEP 3 OF 3'),
                    ScreenHeading(heading),
                    const SizedBox(height: 8),
                    Text(
                      subtext,
                      style: const TextStyle(
                        color: AppColors.neutral60,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Review Details Card
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.divider, width: 1),
                      ),
                      child: Column(
                        children: [
                          ReviewDetailRow(
                            label: 'Detail',
                            value: request.requestType,
                          ),
                          ReviewDetailRow(
                            label: isAddress
                                ? 'Current address'
                                : (type == 'Date of birth'
                                    ? 'Current Date of Birth'
                                    : 'Current value'),
                            value: request.currentValue,
                          ),
                          ReviewDetailRow(
                            label: isAddress
                                ? 'New address'
                                : (type == 'Date of birth'
                                    ? 'Requested Date of Birth'
                                    : 'Requested value'),
                            value: request.requestedValue,
                          ),
                          if (isAddress && request.extraDetail != null)
                            ReviewDetailRow(
                              label: 'Postal',
                              value: request.extraDetail!,
                            ),
                          if (!isAddress)
                            ReviewDetailRow(
                              label: 'Reason',
                              value: request.reason,
                            ),
                          ReviewDetailRow(
                            label: 'Document',
                            value: request.documentName,
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Notice
                    const NoticeBanner(
                      'Submitting is a request. Your verified profile will update only after approval.',
                    ),
                  ],
                ),
              ),
            ),
            BottomBar(
              child: PrimaryButton(
                buttonLabel,
                onPressed: () => _onSubmit(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
