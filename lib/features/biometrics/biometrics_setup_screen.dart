import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';

class BiometricsSetupScreen extends StatefulWidget {
  const BiometricsSetupScreen({super.key});

  @override
  State<BiometricsSetupScreen> createState() => _BiometricsSetupScreenState();
}

class _BiometricsSetupScreenState extends State<BiometricsSetupScreen> {
  String _selectedOption = 'fingerprint';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Phone Verification',
            style: TextStyle(color: Colors.black, fontSize: 16)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text('Set up\nbiometrics',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text(
                'Use your fingerprint or face to securely access Framela and confirm transfers.',
                style: TextStyle(color: AppColors.textGrey, fontSize: 14),
              ),
              const SizedBox(height: 24),
              _buildOptionTile(
                value: 'faceId',
                icon: Icons.face_retouching_natural,
                title: 'Face ID',
                subtitle: 'Use facial recognition to access your account securely.',
              ),
              const SizedBox(height: 12),
              _buildOptionTile(
                value: 'fingerprint',
                icon: Icons.fingerprint,
                title: 'Fingerprint',
                subtitle: 'Use your fingerprint to log in quickly and securely.',
              ),
              const SizedBox(height: 12),
              _buildOptionTile(
                value: 'passcode',
                icon: Icons.password,
                title: 'Passcode',
                subtitle: 'Use your device passcode to log in securely.',
              ),
              const SizedBox(height: 20),
              const Text(
                'Your biometric data stays on your device.',
                style: TextStyle(color: AppColors.textGrey, fontSize: 12),
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.biometricsSetup),
                child: const Text('Enable biometric'),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.kycIntro),
                  child: const Text('Not now',
                      style: TextStyle(color: AppColors.textGrey)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required String value,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final bool selected = _selectedOption == value;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => setState(() => _selectedOption = value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.accentYellow : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primaryDark,
              child: Icon(icon, color: AppColors.white, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          color: AppColors.textGrey, fontSize: 12)),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selectedOption,
              activeColor: AppColors.accentYellow,
              onChanged: (v) => setState(() => _selectedOption = v!),
            ),
          ],
        ),
      ),
    );
  }
}