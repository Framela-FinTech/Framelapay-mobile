import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Reset Password — step 2. Enter the 6-digit code sent to the registered
/// email, with expiry + resend countdowns. Verify → Create New Password.
class VerifyEmailScreen extends StatefulWidget {
  final String email;
  const VerifyEmailScreen({super.key, required this.email});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  int _expireSeconds = 112; // 01:52
  int _resendSeconds = 42; // 00:42
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        if (_expireSeconds > 0) _expireSeconds--;
        if (_resendSeconds > 0) _resendSeconds--;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _format(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final pinTheme = PinTheme(
      width: 46,
      height: 52,
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Verify Email'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                          color: AppColors.inputFill, shape: BoxShape.circle),
                      child: const AppIcon('bell',
                          size: 28, color: AppColors.primaryDark),
                    ),
                    const SizedBox(height: 20),
                    const Text('Verify your email.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 22)),
                    const SizedBox(height: 8),
                    Text(
                        'Enter the six-digit code sent to\n${widget.email}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: AppColors.textGrey, fontSize: 13)),
                    const SizedBox(height: 28),
                    Pinput(length: 6, defaultPinTheme: pinTheme),
                    const SizedBox(height: 16),
                    Text('Code expires in ${_format(_expireSeconds)}',
                        style: const TextStyle(
                            color: AppColors.textGrey, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(
                      _resendSeconds > 0
                          ? 'Resend code in ${_format(_resendSeconds)}'
                          : 'Resend code',
                      style: TextStyle(
                        color: _resendSeconds > 0
                            ? AppColors.textGrey
                            : AppColors.accentYellow,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text.rich(
                        TextSpan(
                          text: 'Entered the wrong email? ',
                          style: TextStyle(
                              color: AppColors.textGrey, fontSize: 13),
                          children: [
                            TextSpan(
                              text: 'Change email',
                              style: TextStyle(
                                  color: AppColors.accentYellow,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: PrimaryButton(
                'Verify',
                onPressed: () => Navigator.pushNamed(
                    context, AppRoutes.createNewPassword),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
