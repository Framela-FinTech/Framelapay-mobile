import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_icon.dart';
import '../../data/models/currency_wallet.dart';
import '../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Screen 5 — "Choose Method": pick how to fund the selected wallet.
/// Reuses existing flows: Stablecoin → stablecoin flow; Card → a minimal
/// card-funding screen; Bank Transfer → the new bank-details screen.
class ChooseMethodScreen extends StatelessWidget {
  final CurrencyWallet wallet;
  const ChooseMethodScreen({super.key, required this.wallet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Choose Method'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _walletCard(context),
              const SizedBox(height: 20),
              const SectionTitle('Choose a funding method'),
              const SizedBox(height: 4),
              const Text('How would you like to add money?',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
              const SizedBox(height: 16),
              _method(
                context,
                icon: 'bank',
                title: 'Bank Transfer',
                subtitle: 'Pay directly from your bank account',
                onTap: () => Navigator.pushNamed(
                    context, AppRoutes.fundWalletDetails,
                    arguments: wallet),
              ),
              _method(
                context,
                icon: 'card',
                title: 'Debit/Credit Card',
                subtitle: 'Pay securely using your visa, Mastercard or other card.',
                onTap: () => Navigator.pushNamed(context, AppRoutes.fundCard,
                    arguments: wallet),
              ),
              _method(
                context,
                icon: 'coins',
                title: 'Stablecoin',
                subtitle: 'Send using USDT on popular blockchain networks.',
                onTap: () => Navigator.pushNamed(
                    context, AppRoutes.sendStablecoinWallet),
              ),
              const SizedBox(height: 16),
              const NoticeBanner(
                'Available methods may vary based on your country and wallet.',
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _walletCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accentYellow, width: 1.5),
      ),
      child: Row(
        children: [
          ClipOval(
            child: CountryFlag.fromCountryCode(wallet.countryCode,
                height: 36, width: 36, shape: const Circle()),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${wallet.name} Wallet',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text('${wallet.formattedBalance} available',
                    style: const TextStyle(
                        color: AppColors.textGrey, fontSize: 12)),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  Widget _method(BuildContext context,
      {required String icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap}) {
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
              radius: 20,
              backgroundColor: AppColors.primaryDark,
              child: AppIcon(icon, color: Colors.white, size: 18),
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
            const AppIcon('chevron-right', color: AppColors.textGrey),
          ],
        ),
      ),
    );
  }
}
