import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';

class KycStatusScreen extends StatelessWidget {
  final bool isVerified;
  const KycStatusScreen({super.key, this.isVerified = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('KYC Verification',
            style: TextStyle(color: Colors.black, fontSize: 16)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text(
                isVerified
                    ? "You're verified!"
                    : "We're verifying your identity",
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                isVerified
                    ? 'Your identity has been successfully verified.\n\nYou can now enjoy all features on Framela.'
                    : 'Your information has been submitted successfully.\n\nVerification may take a little longer in some cases.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
              ),
              const SizedBox(height: 28),
              _statusRow('Submitted', '1st May 2026, 10:42AM', true),
              _statusRow('Under review', '1st May 2026, 10:46AM', isVerified),
              _statusRow('Verified', '1st May 2026, 10:50AM', isVerified),
              _statusRow('Completed', '1st May 2026, 10:50AM', isVerified,
                  isLast: true),
              const SizedBox(height: 24),
              Text(
                isVerified
                    ? 'Your account is now fully verified.\n\nYou can send money, receive, and access all features on Framela.'
                    : "You can continue using the app, but some features will be limited until verification is complete.",
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.home,
                  (route) => false,
                ),
                child: const Text('Go to Home'),
              ),
              const SizedBox(height: 8),
              const Text('Your data is secure and encrypted end to end.',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 11)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusRow(String title, String time, bool done,
      {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              done ? Icons.check_circle : Icons.radio_button_unchecked,
              color: done ? AppColors.success : AppColors.textGrey,
              size: 20,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 32,
                color: AppColors.divider,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                Text(time,
                    style: const TextStyle(
                        color: AppColors.textGrey, fontSize: 12)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}