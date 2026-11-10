import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/ongoing_transfer.dart';
import '../fiat/widgets/fiat_form_widgets.dart';
import '../shared/widgets/processing_timeline.dart';

/// "Transfer Progress" — the timeline for a transfer already in flight,
/// opened from Transfer Status.
///
/// Distinct from the post-confirmation Processing Transfer screen: that one
/// auto-advances to a completion screen and carries a blue badge, this one is
/// a read-only check-in on something started earlier, and the board gives it
/// an amber badge. Both render the same [ProcessingTimeline].
class TransferProgressScreen extends StatelessWidget {
  final OngoingTransfer transfer;
  const TransferProgressScreen({super.key, required this.transfer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Transfer Progress'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: AppColors.warningPill,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.sync,
                          size: 44, color: Color(0xFF8A5300)),
                    ),
                    const SizedBox(height: 18),
                    const ScreenHeading(
                      "We're Processing Your Transfer",
                      helper: 'You can safely close the app.',
                      center: true,
                    ),
                    const SizedBox(height: 22),
                    ProcessingTimeline(transfer.steps),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: PrimaryButton(
                'View transfer details',
                onPressed: () => Navigator.pushNamed(
                    context, AppRoutes.transferStatusDetails,
                    arguments: transfer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
