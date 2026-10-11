import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';

class SendStablecoinRecipientScreen extends StatelessWidget {
  const SendStablecoinRecipientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Send Stablecoin',
            style: TextStyle(color: Colors.black, fontSize: 16)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text('Who are you sending to?',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
              const SizedBox(height: 6),
              const Text('Choose how you want to send your USDC.',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
              const SizedBox(height: 20),
              _option(Icons.person_outline, 'FramelaPay User',
                  'Send to a FramelaPay user using their username, email or phone number.',
                  onTap: () => Navigator.pushNamed(
                      context, AppRoutes.findFramelaUser)),
              _option(Icons.account_balance_wallet_outlined, 'External wallet',
                  "Send to any external crypto wallet address.",
                  onTap: () => Navigator.pushNamed(
                      context, AppRoutes.enterWalletAddress)),
              _option(Icons.qr_code_scanner, 'Scan QR code',
                  "Scan a wallet QR code to get the recipient's address.",
                  onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _option(IconData icon, String title, String subtitle,
      {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primaryDark,
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          color: AppColors.textGrey, fontSize: 11)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textGrey),
          ],
        ),
      ),
    );
  }
}