import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';

class KycIdTypeScreen extends StatefulWidget {
  const KycIdTypeScreen({super.key});

  @override
  State<KycIdTypeScreen> createState() => _KycIdTypeScreenState();
}

class _KycIdTypeScreenState extends State<KycIdTypeScreen> {
  String _selected = 'passport';

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
              const Text('Step 3 of 4',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
              const SizedBox(height: 4),
              const LinearProgressIndicator(
                value: 0.75,
                minHeight: 4,
                backgroundColor: AppColors.divider,
                color: AppColors.accentYellow,
              ),
              const SizedBox(height: 20),
              const Text('Verify your identity',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text(
                "Select the type of identification you'll use for verification.",
                style: TextStyle(color: AppColors.textGrey, fontSize: 14),
              ),
              const SizedBox(height: 24),
              _idTile('passport', Icons.menu_book_outlined, 'Passport',
                  "Passport, national ID or driver's license"),
              const SizedBox(height: 12),
              _idTile('license', Icons.badge_outlined, "Driver's license",
                  "Use your driver's license"),
              const SizedBox(height: 12),
              _idTile('permit', Icons.home_outlined, 'Residence permit',
                  'Use your residence permit'),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.kycDocumentCapture), 
              child: const Text('Continue')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _idTile(String value, IconData icon, String title, String subtitle) {
    final selected = _selected == value;
    return InkWell(
      onTap: () => setState(() => _selected = value),
      borderRadius: BorderRadius.circular(14),
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
            Icon(icon, color: AppColors.primaryDark),
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
              groupValue: _selected,
              activeColor: AppColors.accentYellow,
              onChanged: (v) => setState(() => _selected = v!),
            ),
          ],
        ),
      ),
    );
  }
}
