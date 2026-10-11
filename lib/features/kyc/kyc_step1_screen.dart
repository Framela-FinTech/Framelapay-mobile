import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';

class KycStep1Screen extends StatelessWidget {
  const KycStep1Screen({super.key});

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
              const Text('Step 1 of 4',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
              const SizedBox(height: 4),
              const LinearProgressIndicator(
                value: 0.25,
                minHeight: 4,
                backgroundColor: AppColors.divider,
                color: AppColors.accentYellow,
              ),
              const SizedBox(height: 20),
              const Text('Tell us about yourself',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text(
                'Confirm your personal details to continue your KYC review.',
                style: TextStyle(color: AppColors.textGrey, fontSize: 14),
              ),
              const SizedBox(height: 24),
              _label('First name'),
              const TextField(decoration: InputDecoration(hintText: 'Godwin')),
              const SizedBox(height: 14),
              _label('Last name'),
              const TextField(decoration: InputDecoration(hintText: 'Ubom')),
              const SizedBox(height: 14),
              _label('Email address'),
              const TextField(
                  decoration: InputDecoration(hintText: 'Godwin@gmail.com')),
              const SizedBox(height: 14),
              _label('Phone Number'),
              const TextField(
                  decoration: InputDecoration(hintText: '+234 8123456789')),
              const SizedBox(height: 14),
              _label('Country of residence'),
              const TextField(decoration: InputDecoration(hintText: 'Nigeria')),
              const SizedBox(height: 14),
              _label('Date of birth'),
              const TextField(
                  decoration: InputDecoration(hintText: '12 Aug 1994')),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.kycStep2), 
              child: const Text('Continue')),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      );
}