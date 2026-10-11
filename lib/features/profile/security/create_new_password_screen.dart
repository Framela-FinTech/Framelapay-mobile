import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';
import '../widgets/profile_success_screen.dart';

/// Reset Password — step 3. Set the new password → "Password reset complete".
class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final _next = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _next.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _save() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ProfileSuccessScreen(
          title: 'Password reset complete',
          message: 'Your new login password is ready to use.',
          primary: SuccessButton('Return to Security', AppRoutes.securityHome),
          secondary: SuccessButton('Return to Profile', AppRoutes.profile),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Create New Password'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text('Create a new password',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)),
                    const SizedBox(height: 20),
                    const FieldLabel('New Password'),
                    AppTextInput(
                      controller: _next,
                      obscureText: true,
                      hint: 'Enter new password',
                    ),
                    const SizedBox(height: 16),
                    const FieldLabel('Confirm New Password'),
                    AppTextInput(
                      controller: _confirm,
                      obscureText: true,
                      hint: 'Re-enter new password',
                    ),
                    const SizedBox(height: 16),
                    const NoticeBanner(
                      'Use at least 8 characters, including a letter and a number.',
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: PrimaryButton('Save New Password', onPressed: _save),
            ),
          ],
        ),
      ),
    );
  }
}
