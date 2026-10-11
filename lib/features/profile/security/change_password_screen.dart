import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';
import '../widgets/profile_success_screen.dart';

/// Change Password (Security sub-flow). Current / new / confirm fields → a
/// success screen. No real auth; fields are not validated against a backend.
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _current = TextEditingController();
  final _next = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _save() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ProfileSuccessScreen(
          title: 'Password changed',
          message: 'Your login password has been updated.',
          primary: SuccessButton('Return to Settings',
              AppRoutes.settingsHome,
              keepProfileBase: true),
          secondary: SuccessButton('Return to Profile', AppRoutes.profile),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Change Password'),
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
                    const FieldLabel('Current Password'),
                    AppTextInput(
                      controller: _current,
                      obscureText: true,
                      hint: 'Enter current password',
                    ),
                    const SizedBox(height: 16),
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
              child: PrimaryButton('Update Password', onPressed: _save),
            ),
          ],
        ),
      ),
    );
  }
}
