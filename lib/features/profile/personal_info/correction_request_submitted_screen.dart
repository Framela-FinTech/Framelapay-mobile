import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/correction_request.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';
import 'personal_info_widgets.dart';

/// Step 4: Request Submitted Screen.
/// Matches Frame 4 of Row 0, Row 1, and Row 2 of `Personal Information Edit.png`.
class CorrectionRequestSubmittedScreen extends StatelessWidget {
  final CorrectionRequest request;

  const CorrectionRequestSubmittedScreen({
    super.key,
    required this.request,
  });

  void _onViewStatus(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.correctionRequestStatus,
      arguments: request,
    );
  }

  @override
  Widget build(BuildContext context) {
    final type = request.requestType;
    String bodyText;
    if (type == 'Full name') {
      bodyText =
          'We received your full name correction request. Your verified detail stays unchanged while it is reviewed.';
    } else if (type == 'Date of birth') {
      bodyText =
          'We received your date of birth correction request. Your verified detail stays unchanged while it is reviewed.';
    } else {
      bodyText =
          'We received your address change request. Your current address stays unchanged while it is reviewed.';
    }

    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Correction Request'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Green check badge
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check,
                          color: AppColors.white,
                          size: 38,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Request submitted',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      bodyText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.neutral60,
                        fontSize: 13,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Details Card
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.divider, width: 1),
                      ),
                      child: Column(
                        children: [
                          ReviewDetailRow(
                            label: 'Request type',
                            value: request.requestType,
                          ),
                          ReviewDetailRow(
                            label: 'Status',
                            value: type == 'Residential address'
                                ? request.requestedValue
                                : request.status,
                          ),
                          ReviewDetailRow(
                            label: 'Reference',
                            value: request.reference,
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Notice
                    const NoticeBanner(
                      "We'll notify you when there is an update. Review times depend on verification.",
                    ),
                  ],
                ),
              ),
            ),
            BottomBar(
              child: PrimaryButton(
                'View Request Status',
                onPressed: () => _onViewStatus(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
