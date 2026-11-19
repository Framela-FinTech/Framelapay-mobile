import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

enum _StepState { done, active, pending }

/// Verification Submitted — upgrade is under review. Shows a progress timeline
/// and a CTA to review the approval state.
class VerificationSubmittedScreen extends StatelessWidget {
  const VerificationSubmittedScreen({super.key});

  void _toProfile(BuildContext context) {
    Navigator.popUntil(
      context,
      (route) => route.settings.name == AppRoutes.profile || route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _toProfile(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.pageGrey,
        appBar: whiteAppBar('Verification Submitted'),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  child: Column(
                    children: [
                      const IconBadge(
                        icon: 'clock',
                        halo: AppColors.warningPill,
                        size: 88,
                        glyphSize: 36,
                        glyphColor: Color(0xFF8A5300),
                      ),
                      const SizedBox(height: 18),
                      const ScreenHeading(
                        'Verification in progress',
                        helper:
                            "We're reviewing your information and will notify "
                            'you when the review is complete.',
                        center: true,
                      ),
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          children: [
                            _step(
                              _StepState.done,
                              'Information submitted',
                              'Completed',
                              isLast: false,
                            ),
                            _step(
                              _StepState.active,
                              'Document review',
                              'In progress',
                              isLast: false,
                            ),
                            _step(
                              _StepState.pending,
                              'Verification outcome',
                              'Pending',
                              isLast: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const NoticeBanner(
                        'You can continue using your current Tier 2 account '
                        'limits during the review.',
                        type: NoticeType.warning,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: PrimaryButton(
                  'Review Approval State',
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.profileKycSuccessful,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _step(
    _StepState state,
    String title,
    String subtitle, {
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            _stepIndicator(state),
            if (!isLast)
              Container(
                width: 2,
                height: 38,
                color: const Color(0xFFCBD5E1),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textGrey,
                ),
              ),
              if (!isLast) const SizedBox(height: 18),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stepIndicator(_StepState state) {
    Color ringColor;
    Color centerColor;

    switch (state) {
      case _StepState.done:
        ringColor = AppColors.success;
        centerColor = AppColors.success;
        break;
      case _StepState.active:
        ringColor = const Color(0xFFB45309);
        centerColor = const Color(0xFFB45309);
        break;
      case _StepState.pending:
        ringColor = const Color(0xFFCBD5E1);
        centerColor = Colors.transparent;
        break;
    }

    return Container(
      width: 22,
      height: 22,
      margin: const EdgeInsets.only(top: 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ringColor, width: 3),
      ),
      child: Center(
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: centerColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
