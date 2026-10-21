import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_icon.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: AppBar(
        title: const Text('Referral'),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
          child: Column(
            children: [
              const _CircleIcon(
                  icon: 'gift', color: AppColors.iconBlue),
              const SizedBox(height: 22),
              const Text('Invite friends to FramelaPay',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              const Text(
                'Share your referral code and earn rewards when eligible friends complete their first transfer.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.textGrey, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 34),
              InkWell(
                onTap: () {
                  Clipboard.setData(const ClipboardData(text: 'FERANMI25'));
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Referral code copied')));
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 28),
                  decoration: BoxDecoration(
                    color: AppColors.pageGrey,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: const Column(
                    children: [
                      AppIcon('copy', size: 40, color: AppColors.iconBlue),
                      SizedBox(height: 14),
                      Text('FERANMI25',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w800)),
                      SizedBox(height: 8),
                      Text('Tap to copy your referral code',
                          style: TextStyle(
                              color: AppColors.textGrey, fontSize: 13)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 42),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Referral link ready to share'))),
                  child: const Text('Share Referral Link'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.popUntil(
                      context, ModalRoute.withName(AppRoutes.profile)),
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final String icon;
  final Color color;
  const _CircleIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        width: 74,
        height: 74,
        decoration: const BoxDecoration(
            color: AppColors.inputFill, shape: BoxShape.circle),
        child: Center(child: AppIcon(icon, size: 36, color: color)),
      );
}
