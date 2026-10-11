import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';

class KycStep2Screen extends StatelessWidget {
  const KycStep2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Step 2 of 4',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
              const SizedBox(height: 4),
              const LinearProgressIndicator(
                value: 0.5,
                minHeight: 4,
                backgroundColor: AppColors.divider,
                color: AppColors.accentYellow,
              ),
              const SizedBox(height: 20),
              const Text('A little bit more about you',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text(
                'This information helps us understand your profile and keep your account secure.',
                style: TextStyle(color: AppColors.textGrey, fontSize: 14),
              ),
              const SizedBox(height: 24),
              _dropdown('Occupation', 'Select your occupation'),
              const SizedBox(height: 14),
              _dropdown('Source of funds', 'Select source of funds'),
              const SizedBox(height: 14),
              _dropdown('Expected monthly transfer', 'Select an option'),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.kycIdType),
                child: const Text('Continue')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropdown(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(hintText: hint),
          items: const [],
          onChanged: (_) {},
        ),
      ],
    );
  }
}
