import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';

enum PasswordStrength { weak, medium, strong }

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _created = false;
  PasswordStrength _strength = PasswordStrength.weak;

  void _checkStrength(String value) {
    final hasLetters = RegExp(r'[a-zA-Z]').hasMatch(value);
    final hasNumbers = RegExp(r'[0-9]').hasMatch(value);
    final hasSymbols = RegExp(r'[!@#\$&*~%^()_+=-]').hasMatch(value);
    final score = [hasLetters, hasNumbers, hasSymbols].where((e) => e).length;

    setState(() {
      if (value.length >= 8 && score == 3) {
        _strength = PasswordStrength.strong;
      } else if (value.length >= 6 && score >= 2) {
        _strength = PasswordStrength.medium;
      } else {
        _strength = PasswordStrength.weak;
      }
    });
  }

  Color get _strengthColor {
    switch (_strength) {
      case PasswordStrength.strong:
        return AppColors.success;
      case PasswordStrength.medium:
        return AppColors.accentYellow;
      case PasswordStrength.weak:
        return AppColors.error;
    }
  }

  String get _strengthLabel {
    switch (_strength) {
      case PasswordStrength.strong:
        return 'Strong';
      case PasswordStrength.medium:
        return 'Medium';
      case PasswordStrength.weak:
        return 'Weak';
    }
  }

  double get _strengthFraction {
    switch (_strength) {
      case PasswordStrength.strong:
        return 1.0;
      case PasswordStrength.medium:
        return 0.6;
      case PasswordStrength.weak:
        return 0.3;
    }
  }

  void _handleContinue() {
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a password')),
      );
      return;
    }
    if (confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please confirm your password')),
      );
      return;
    }
    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => _created = true);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _created ? _buildSuccess() : _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Create a\nstrong password',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const Text('Create a password to secure your account.',
              style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
          const SizedBox(height: 24),
          const Text('Password',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 8),
          TextField(
            controller: _passwordController,
            obscureText: true,
            onChanged: _checkStrength,
            decoration: const InputDecoration(hintText: 'Enter Password'),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Password strength: ',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
              Text(_strengthLabel,
                  style: TextStyle(
                      color: _strengthColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _strengthFraction,
              minHeight: 6,
              backgroundColor: AppColors.divider,
              color: _strengthColor,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Use 8 or more characters with a mix of letters, numbers and symbols.',
            style: TextStyle(color: AppColors.textGrey, fontSize: 12),
          ),
          const SizedBox(height: 20),
          const Text('Confirm password',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 8),
          TextField(
            controller: _confirmController,
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Enter Password'),
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: _handleContinue,
            child: const Text('Continue'),
          ),
          const SizedBox(height: 24),
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
              color: AppColors.success, shape: BoxShape.circle),
          child: const Icon(Icons.check, color: Colors.white, size: 36),
        ),
        const SizedBox(height: 24),
        const Text('Password created\nsuccessfully!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        const Text('Your account is now more secure.',
            style: TextStyle(color: AppColors.textGrey)),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.biometricsSetup),
            child: const Text('Continue'),
          ),
        ),
      ],
    );
  }
}