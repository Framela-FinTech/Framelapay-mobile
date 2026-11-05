import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../data/models/transfer_recipient.dart';

/// Figma uses a pale blue for the chips on the stablecoin summary cards.
const Color kStablecoinPaleBlue = Color(0xFFDCE7F7);
const Color kStablecoinLinkBlue = Color(0xFF2563EB);

/// Small pill used for "FramelaPay user" / "selected".
class StablecoinChip extends StatelessWidget {
  final String label;
  final Color foreground;
  const StablecoinChip(this.label, {super.key, required this.foreground});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: kStablecoinPaleBlue,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label,
          style: TextStyle(
              color: foreground, fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }
}

/// The chosen recipient, shown on both Enter Amount and Review.
class RecipientSummaryCard extends StatelessWidget {
  final TransferRecipient recipient;
  const RecipientSummaryCard({super.key, required this.recipient});

  @override
  Widget build(BuildContext context) {
    final isUser = recipient.isFramelaUser;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.inputFill,
            child: AppIcon(isUser ? 'folder-user' : 'wallet',
                size: 26, color: AppColors.primaryDark),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isUser ? (recipient.name ?? '') : 'External wallet',
                    style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 17)),
                Text(
                    isUser
                        ? (recipient.handle ?? '')
                        : _truncate(recipient.walletAddress),
                    style: const TextStyle(
                        color: AppColors.textGrey, fontSize: 14)),
                if (isUser) ...[
                  const SizedBox(height: 6),
                  const StablecoinChip('FramelaPay user',
                      foreground: kStablecoinLinkBlue),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          const StablecoinChip('selected', foreground: AppColors.primaryDark),
        ],
      ),
    );
  }

  static String _truncate(String address) {
    if (address.length <= 14) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }
}
