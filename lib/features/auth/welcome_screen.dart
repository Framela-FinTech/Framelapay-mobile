import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Logo + wordmark (same as splash screen). Rendered large via an
              // OverflowBox while keeping a 60px layout slot, so the logo grows
              // without shifting any of the text/buttons below.
              SizedBox(
                height: 60,
                child: OverflowBox(
                  minHeight: 0,
                  maxHeight: 180,
                  alignment: Alignment.center,
                  child: Image.asset('assets/images/framelapay_logo.png',
                      height: 180),
                ),
              ),
              const SizedBox(height: 16),
              const Spacer(flex: 2),
              // Title
              const Text(
                'Send money across\nborders,simply.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Fast,secure and transparent international transfer.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(flex: 3),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(
                    context, AppRoutes.createAccount),
                child: const Text('Create Account'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  side: const BorderSide(color: AppColors.divider),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {},
                child: const Text(
                  'Log In',
                  style: TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 16),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(color: AppColors.primaryDark, fontSize: 11),
                  children: [
                    TextSpan(text: 'By continuing, you agree to our '),
                    TextSpan(
                      text: 'Terms & Conditions',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark),
                    ),
                    TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
