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
    // Walk UP the existing stack to the destination — an ancestor that is
    // already on the stack because the flow was built with pushNamed. The
    // isFirst guard stops at the Home root if the target isn't found, so this
    // can never empty the Navigator / exit the app, and never re-enters
    // the onboarding/KYC flow.
    Navigator.popUntil(
        context, (route) => route.settings.name == b.route || route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Hardware back walks up to the same parent as the primary button, so it
      // can't exit the app or fall back into onboarding/KYC.
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _go(context, primary);
      },
      child: Scaffold(
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
      ),
    );
  }
}
