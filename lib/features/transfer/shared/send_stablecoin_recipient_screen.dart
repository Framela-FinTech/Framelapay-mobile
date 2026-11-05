import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/widgets/app_icon.dart';

class SendStablecoinRecipientScreen extends StatelessWidget {
  const SendStablecoinRecipientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: AppColors.primaryDark),
        title: const Text('Recipient Type',
            style: TextStyle(
                color: AppColors.primaryDark,
                fontSize: 20,
                fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Who are you sending to?',
                  style: TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 17)),
              const SizedBox(height: 4),
              const Text('Choose how you want to send your USDC.',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
              const SizedBox(height: 22),
              _option('folder-user', 'FramelaPay User',
                  'Send to a FramelaPay user using their username, email or phone number.',
                  onTap: () => Navigator.pushNamed(
                      context, AppRoutes.findFramelaUser)),
              _option('wallet', 'External wallet',
                  'Send to any external crypto wallet address.',
                  onTap: () => Navigator.pushNamed(
                      context, AppRoutes.enterWalletAddress)),
              _option('QR-code', 'Scan QR code',
                  "Scan a wallet QR code to get the recipient's address.",
                  onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _option(String icon, String title, String subtitle,
      {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(12),
              ),
              child: AppIcon(icon, size: 24, color: AppColors.primaryDark),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 17)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          color: AppColors.textGrey, fontSize: 15)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const AppIcon('chevron-right',
                size: 22, color: AppColors.primaryDark),
          ],
        ),
      ),
    );
  }
}