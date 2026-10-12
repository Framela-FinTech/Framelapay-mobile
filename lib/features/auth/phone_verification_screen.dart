import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';

class PhoneVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  const PhoneVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  bool _verified = false;
  int _expireSeconds = 112;
  int _resendSeconds = 42;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
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
    final defaultPinTheme = PinTheme(
      width: 52,
      height: 56,
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Phone Verification',
            style: TextStyle(color: Colors.black, fontSize: 16)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _verified ? _buildSuccess() : _buildCodeEntry(defaultPinTheme),
        ),
      ),
    );
  }

  Widget _buildCodeEntry(PinTheme theme) {
    return SingleChildScrollView(
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Verify your phone\nnumber.',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          "We've sent a verification code to\n${widget.phoneNumber}",
          style: const TextStyle(color: AppColors.textGrey, fontSize: 14),
        ),
        const SizedBox(height: 32),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Pinput(length: 6, defaultPinTheme: theme),
        ),
        const SizedBox(height: 16),
        Text('Code expires in ${_format(_expireSeconds)}',
            style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
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
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () => setState(() => _verified = true),
          child: const Text('Verify'),
        ),
      ],
      ),
    );
  }

  Widget _buildSuccess() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: AppColors.success,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 36),
        ),
        const SizedBox(height: 24),
        const Text('Phone verified\nsuccessfully!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        const Text('Your phone number has been verified.',
            style: TextStyle(color: AppColors.textGrey)),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
           onPressed: () => Navigator.pushNamed(context, AppRoutes.createPassword),
            child: const Text('Continue'),
          ),
        ),
      ],
    );
  }
}