import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/widgets/app_icon.dart';

/// Step 1 of the stablecoin flow — pick the wallet to send from.
///
/// Figma shows this as a plain tap-to-navigate list: no radio, no Continue.
/// Choosing a wallet goes straight on to the network picker.
class SendStablecoinWalletScreen extends StatelessWidget {
  const SendStablecoinWalletScreen({super.key});

  // Brand marks aren't in the icon pack yet, so the coin glyph is tinted to
  // each token's colour as a stand-in.
  static const _usdcBlue = AppColors.usdcBlue;
  static const _usdtGreen = AppColors.usdtGreen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: AppColors.primaryDark),
        title: const Text('Send Stablecoin',
            style: TextStyle(
                color: AppColors.primaryDark,
                fontSize: 20,
                fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your wallets',
                  style: TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 16)),
              const SizedBox(height: 12),
              _WalletCard(
                code: 'USDC',
                name: 'USD Coin',
                balance: '2,500.00 USDC',
                tint: _usdcBlue,
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.chooseNetwork),
              ),
              const SizedBox(height: 12),
              _WalletCard(
                code: 'USDT',
                name: 'Tether',
                balance: '2,500.00 USDT',
                tint: _usdtGreen,
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.chooseNetwork),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WalletCard extends StatelessWidget {
  final String code;
  final String name;
  final String balance;
  final Color tint;
  final VoidCallback onTap;

  const _WalletCard({
    required this.code,
    required this.name,
    required this.balance,
    required this.tint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
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
                color: AppColors.iconTileSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: AppIcon('coins', size: 26, color: tint),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(code,
                      style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 17,
                          fontWeight: FontWeight.w600)),
                  Text(name,
                      style: const TextStyle(
                          color: AppColors.textGrey, fontSize: 13)),
                  const SizedBox(height: 6),
                  const Text('Available balance',
                      style: TextStyle(
                          color: AppColors.textGrey, fontSize: 13)),
                  Text(balance,
                      style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 17,
                          fontWeight: FontWeight.w600)),
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
