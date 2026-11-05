import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/widgets/app_icon.dart';

/// Summary of the chosen token and network, carried across the stablecoin
/// steps (Enter Recipient, Enter Amount, Review) with a "Change" shortcut.
class AssetNetworkBar extends StatelessWidget {
  final String assetCode;
  final String assetName;
  final String network;
  final VoidCallback? onChange;

  /// Stand-in for the USDC brand mark until the real asset lands.
  static const _usdcBlue = AppColors.usdcBlue;

  const AssetNetworkBar({
    super.key,
    this.assetCode = 'USDC',
    this.assetName = 'USD Coin',
    this.network = 'Ethereum',
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          const AppIcon('coins', size: 28, color: _usdcBlue),
          const SizedBox(width: 10),
          _labels(assetCode, assetName),
          const SizedBox(width: 12),
          Container(width: 1, height: 36, color: AppColors.divider),
          const SizedBox(width: 12),
          const AppIcon('data', size: 24, color: AppColors.primaryDark),
          const SizedBox(width: 10),
          Expanded(child: _labels(network, 'Selected network')),
          if (onChange != null)
            GestureDetector(
              onTap: onChange,
              child: const Text('Change',
                  style: TextStyle(
                      color: AppColors.accentYellow,
                      fontSize: 15,
                      fontWeight: FontWeight.w700)),
            ),
        ],
      ),
    );
  }

  Widget _labels(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: AppColors.primaryDark,
                fontSize: 15,
                fontWeight: FontWeight.w600)),
        Text(subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: AppColors.textGrey, fontSize: 12)),
      ],
    );
  }
}
