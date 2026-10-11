import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../data/models/fiat_transfer.dart';
import '../../../data/models/transfer_method.dart';

class TransferScreen extends StatelessWidget {
  const TransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Text('Transfer',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
              const SizedBox(height: 16),
              Row(
                children: [
                  _tab('Send Money', selected: true),
                  _tab('Add Money',
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.addMoneySelectWallet)),
                  _tab('History'),
                ],
              ),
              const SizedBox(height: 20),
              _promoBanner(),
              const SizedBox(height: 24),
              const Text('How would you like to pay?',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              const SizedBox(height: 4),
              const Text('Choose how you want to fund your transfer.',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
              const SizedBox(height: 16),
              _payOption('wallet', 'Wallet',
                  'Send from your Framela wallet balance',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.selectWallet)),
              _payOption('bank', 'Bank Transfer',
                  'Pay directly from your bank account',
                  onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.fiatTransferDetails,
                        arguments:
                            const FiatTransfer(method: TransferMethod.bank),
                      )),
              _payOption('card', 'Debit/Credit Card',
                  'Pay securely using your visa, Mastercard or other card.',
                  onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.fiatTransferDetails,
                        arguments:
                            const FiatTransfer(method: TransferMethod.card),
                      )),
              _payOption('coins', 'Stablecoin',
                  'Send using USDT on popular blockchain networks.',
                  onTap: () => Navigator.pushNamed(
                      context, AppRoutes.sendStablecoinWallet)),
              const SizedBox(height: 16),
              Row(
                children: [
                  const AppIcon('shield',
                      size: 16, color: AppColors.textGrey),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Your security is our priority — all payments are encrypted and secure. We never store your card or bank details.',
                      style: const TextStyle(
                          color: AppColors.textGrey, fontSize: 11),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tab(String label, {bool selected = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Text(label,
                style: TextStyle(
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                    color:
                        selected ? AppColors.primaryDark : AppColors.textGrey,
                    fontSize: 13)),
            const SizedBox(height: 4),
            if (selected)
              Container(width: 24, height: 2, color: AppColors.accentYellow),
          ],
        ),
      ),
    );
  }

  /// Promo card: the designer's globe art. Falls back to the original dark
  /// container if the image asset is missing so nothing breaks.
  Widget _promoBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        'assets/images/create-account-banner.png',
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _promoFallback(),
      ),
    );
  }

  Widget _promoFallback() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Create\nyour account.',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
          SizedBox(height: 6),
          Text('Fast, secure and reliable transfer to over 100 countries',
              style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _payOption(String iconName, String title, String subtitle,
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
              child: AppIcon(iconName, color: Colors.white, size: 18),
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