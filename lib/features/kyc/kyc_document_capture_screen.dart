import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';
import 'kyc_processing_screen.dart';

class KycDocumentCaptureScreen extends StatelessWidget {
  const KycDocumentCaptureScreen({super.key});

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
            const Text('Step 3 of 4',
                style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text('Capture your passport',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Position your document inside the frame. Make sure all details are clear and visible.',
                style: TextStyle(color: AppColors.textGrey, fontSize: 13),
              ),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              height: 220,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.accentYellow, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => KycProcessingScreen(
                      nextRoute: AppRoutes.kycSelfieCapture,
                    ),
                  ),
                ),
                child: const Text('Capture document'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}