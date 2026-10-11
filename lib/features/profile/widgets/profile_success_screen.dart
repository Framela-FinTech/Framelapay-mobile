import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// One button on a [ProfileSuccessScreen].
class SuccessButton {
  final String label;
  final String route;

  const SuccessButton(this.label, this.route);
}

/// Shared success screen for the Profile section. Green check, title + message,
/// a primary (filled) button and an optional secondary (outline) button.
class ProfileSuccessScreen extends StatelessWidget {
  final String title;
  final String message;
  final SuccessButton primary;
  final SuccessButton? secondary;

  const ProfileSuccessScreen({
    super.key,
    required this.title,
    required this.message,
    required this.primary,
    this.secondary,
  });

  void _go(BuildContext context, SuccessButton b) {
    // Push the destination as a fresh root and clear everything else. This can
    // neither pop back into the onboarding/KYC stack nor exit the app the way
    // pop()/popUntil() can when the target route isn't on the current stack.
    Navigator.pushNamedAndRemoveUntil(context, b.route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                          color: AppColors.success, shape: BoxShape.circle),
                      child: const Icon(Icons.check,
                          color: Colors.white, size: 36),
                    ),
                    const SizedBox(height: 20),
                    Text(title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 24)),
                    const SizedBox(height: 8),
                    Text(message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: AppColors.textGrey, fontSize: 13)),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                children: [
                  PrimaryButton(primary.label,
                      onPressed: () => _go(context, primary)),
                  if (secondary != null) ...[
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
                        onPressed: () => _go(context, secondary!),
                        child: Text(secondary!.label),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
