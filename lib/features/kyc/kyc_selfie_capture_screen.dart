import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';
import 'kyc_processing_screen.dart';

class KycSelfieCaptureScreen extends StatelessWidget {
  const KycSelfieCaptureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            const Text('Step 4 of 4',
                style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
            const SizedBox(height: 8),
            const Text('Take selfie',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Verify it's really you, take a quick selfie.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textGrey, fontSize: 13),
              ),
            ),
            const Spacer(),
            Container(
              width: 220,
              height: 220,
              decoration: const BoxDecoration(
                color: AppColors.secondaryDark,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_outline,
                  color: AppColors.textGrey, size: 80),
            ),
            const SizedBox(height: 8),
            const Text(
                'Look directly at the camera and tap below to take a selfie.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => KycProcessingScreen(
                      title: 'Verifying selfie',
                      subtitle:
                          'Checking your selfie matches your document.',
                      nextRoute: AppRoutes.kycStatus,
                      nextRouteArguments: false,
                    ),
                  ),
                ),
                child: const Text('Take selfie'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}