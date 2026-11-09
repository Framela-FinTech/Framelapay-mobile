import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_icon.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Referral — share a code, earn rewards.
///
/// The board shows a single "Invite Friends" call to action; the previous
/// build also carried a "Done" button whose `popUntil` used a bare route-name
/// predicate, which empties the navigator when Referral is reached from Home
/// or Quick Actions rather than from Profile. Dropping it matches the design
/// and removes the hazard — the app bar's back button covers the same intent.
class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  static const _code = 'FERANMI25';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Referral'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                child: Column(
                  children: [
                    const IconBadge(
                      icon: 'gift',
                      halo: AppColors.infoHalo,
                      size: 88,
                      glyphSize: 38,
                      glyphColor: AppColors.iconBlue,
                    ),
                    const SizedBox(height: 20),
                    const ScreenHeading(
                      'Invite Friends To FramelaPay',
                      helper:
                          'Share your referral code and earn rewards when '
                          'eligible friends complete their first transfer.',
                      center: true,
                    ),
                    const SizedBox(height: 28),
                    _codeCard(context),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: PrimaryButton(
                'Invite Friends',
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Referral link ready to share')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _codeCard(BuildContext context) {
    return InkWell(
      onTap: () {
        Clipboard.setData(const ClipboardData(text: _code));
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Referral code copied')));
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 26),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: const Column(
          children: [
            AppIcon('copy', size: 34, color: AppColors.iconBlue),
            SizedBox(height: 14),
            Text(_code,
                style: TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 22,
                    fontWeight: FontWeight.w800)),
            SizedBox(height: 6),
            Text('Tap to copy your referral code',
                style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
