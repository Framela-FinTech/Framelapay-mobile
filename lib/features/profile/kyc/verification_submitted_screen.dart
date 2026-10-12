import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

enum _StepState { done, active, pending }

/// Verification Submitted — upgrade is under review. Shows a progress timeline
/// and a shortcut to preview the approved (successful) state.
class VerificationSubmittedScreen extends StatelessWidget {
  const VerificationSubmittedScreen({super.key});

  void _toProfile(BuildContext context) {
    Navigator.popUntil(context,
        (route) => route.settings.name == AppRoutes.profile || route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _toProfile(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: whiteAppBar('Verification Submitted'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: const BoxDecoration(
                                color: Color(0xFFFBE9B8),
                                shape: BoxShape.circle),
                            child: const AppIcon('clock',
                                size: 34, color: Color(0xFF8A6D1B)),
                          ),
                          const SizedBox(height: 16),
                          const Text('Verification in progress',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 24)),
                          const SizedBox(height: 8),
                          const Text(
                              "We're reviewing your information and will notify "
                              'you when the review is complete.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppColors.textGrey, fontSize: 13)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    _step(_StepState.done, 'Information submitted', 'Completed',
                        isLast: false),
                    _step(_StepState.active, 'Document review', 'In progress',
                        isLast: false),
                    _step(_StepState.pending, 'Verification outcome', 'Pending',
                        isLast: true),
                    const SizedBox(height: 12),
                    _yellowBanner(
                        'You can continue using your current Tier 2 account '
                        'limits during the review.'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                children: [
                  PrimaryButton(
                    'Preview Approved State',
                    onPressed: () => Navigator.pushNamed(
                        context, AppRoutes.profileKycSuccessful),
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
                      onPressed: () => _toProfile(context),
                      child: const Text('Return to Profile'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _step(_StepState state, String title, String subtitle,
      {required bool isLast}) {
    Color dotColor;
    switch (state) {
      case _StepState.done:
        dotColor = AppColors.success;
        break;
      case _StepState.active:
        dotColor = const Color(0xFFB4690E);
        break;
      case _StepState.pending:
        dotColor = AppColors.textGrey;
        break;
    }
    final filled = state != _StepState.pending;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: filled ? dotColor : AppColors.white,
                  border: Border.all(color: dotColor, width: 2),
                ),
                child: filled
                    ? const Icon(Icons.circle,
                        size: 6, color: Colors.white)
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: AppColors.divider),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                        color: AppColors.textGrey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _yellowBanner(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFBE3A2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppIcon('info-circle', size: 18, color: Color(0xFF8A6D1B)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 13, color: Color(0xFF6B541A))),
          ),
        ],
      ),
    );
  }
}
