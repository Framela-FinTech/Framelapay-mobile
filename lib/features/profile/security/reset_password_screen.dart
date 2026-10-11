import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Reset Password — step 1. Confirm the registered email, then send a
/// verification code (→ Verify Email).
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _email = TextEditingController(text: 'cynthia.nkechi@email.com');

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Reset Password'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    Center(
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: const BoxDecoration(
                            color: AppColors.inputFill,
                            shape: BoxShape.circle),
                        child: const AppIcon('lock',
                            size: 28, color: AppColors.primaryDark),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Reset your password',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 22)),
                    const SizedBox(height: 8),
                    const Text(
                        'We\'ll send a one-time code to your registered email address.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.textGrey, fontSize: 13)),
                    const SizedBox(height: 28),
                    const FieldLabel('Registered Email'),
                    AppTextInput(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      hint: 'you@email.com',
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: PrimaryButton(
                'Send Verification Code',
                onPressed: () => Navigator.pushNamed(
                    context, AppRoutes.resetVerifyEmail,
                    arguments: _email.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
