import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';

class KycIntroScreen extends StatelessWidget {
  const KycIntroScreen({super.key});

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text("Let's verify your\nidentity",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text(
                'We need to verify your identity before you can send money',
                style: TextStyle(color: AppColors.textGrey, fontSize: 14),
              ),
              const SizedBox(height: 28),
              _infoRow(Icons.timer_outlined, 'Takes a few minutes'),
              const SizedBox(height: 16),
              _infoRow(Icons.lock_outline, 'Your information is encrypted'),
              const SizedBox(height: 16),
              _infoRow(
                  Icons.public, 'Required for secure international transfer'),
              const SizedBox(height: 40),
              const Text(
                'Your information is encrypted and used only for verification purposes.',
                style: TextStyle(color: AppColors.textGrey, fontSize: 12),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.kycStep1), 
              child: const Text('Continue')),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, AppRoutes.home, (route) => false),
                  child: const Text('Do this later',
                      style: TextStyle(color: AppColors.textGrey)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.inputFill,
          child: Icon(icon, color: AppColors.primaryDark, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }
}
