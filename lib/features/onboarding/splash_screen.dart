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
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo image — sized to cover a reasonable part of the screen.
              // If the asset fails to load we fall back to an empty box.
              Image.asset(
                'assets/images/framelapay_logo_white.png',
                height: screenHeight * 0.22,
                errorBuilder: (context, error, stackTrace) =>
                    SizedBox(height: screenHeight * 0.22),
              ),
              SizedBox(height: screenHeight * 0.06),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  children: [
                    TextSpan(
                        text: 'Fast. ',
                        style: TextStyle(color: AppColors.white)),
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
            ],
          ),
        ),
      ),
    );
  }
}
