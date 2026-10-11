import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 4),
            // Logo image. If the asset fails to load we fall back to an empty
            // box so the wordmark + tagline below are always visible.
            Image.asset(
              'assets/images/framelapay_logo_white.png',
              height: 90,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox(height: 90),
            ),
            const SizedBox(height: 16),
            // Wordmark — always shown as text, independent of the logo asset.
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2),
                children: [
                  TextSpan(
                      text: 'FRAMELA ',
                      style: TextStyle(color: AppColors.white)),
                  TextSpan(
                      text: 'PAY',
                      style: TextStyle(color: AppColors.accentYellow)),
                ],
              ),
            ),
            const Spacer(flex: 5),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                children: [
                  TextSpan(
                      text: 'Fast. ', style: TextStyle(color: AppColors.white)),
                  TextSpan(
                      text: 'Secure',
                      style: TextStyle(color: AppColors.accentYellow)),
                  TextSpan(
                      text: '. Borderless.',
                      style: TextStyle(color: AppColors.white)),
                ],
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Powered by Framela Fintech',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.accentYellow, fontSize: 11),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
