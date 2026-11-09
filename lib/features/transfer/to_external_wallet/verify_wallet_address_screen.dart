import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../data/models/transfer_recipient.dart';
import '../fiat/widgets/fiat_form_widgets.dart';

/// Confirm an external wallet address before review.
///
/// Like its sibling, this screen has no frame on the Home Transfer board —
/// row 4 draws only the FramelaPay-user path — so it follows the house
/// conventions rather than a specific design.
class VerifyWalletAddressScreen extends StatelessWidget {
  const VerifyWalletAddressScreen({super.key});

  static const _recipient = TransferRecipient(
    type: RecipientType.externalWallet,
    walletAddress: '0x71F3A2c4B6e98F29',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Verify Address'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ScreenHeading(
                      'Verify wallet address',
                      helper:
                          'Confirm that the wallet address is correct and '
                          'compatible with the selected network.',
                    ),
                    const SizedBox(height: 22),
                    _addressCard(context),
                    const SizedBox(height: 18),
                    InfoCard(
                      children: [
                        const SummaryRow('Asset', 'USDC · USD Coin'),
                        const Divider(height: 1, color: AppColors.divider),
                        const SummaryRow('Network', 'Ethereum · ERC-20'),
                        const Divider(height: 1, color: AppColors.divider),
                        SummaryRow(
                            'Recipient address', _recipient.shortAddress),
                        const Divider(height: 1, color: AppColors.divider),
                        _checkRow('Network compatibility', 'Compatible'),
                        const Divider(height: 1, color: AppColors.divider),
                        _checkRow('Address format', 'Valid format'),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const NoticeBanner(
                      'This transfer goes directly to the wallet address on '
                      'the Ethereum network. Once sent, it cannot be reversed.',
                      type: NoticeType.warning,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: PrimaryButton(
                'Continue',
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.reviewTransfer,
                  arguments: _recipient,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addressCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
                color: AppColors.iconTileSoft, shape: BoxShape.circle),
            alignment: Alignment.center,
            child:
                const AppIcon('wallet', size: 20, color: AppColors.primary50),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('External wallet',
                    style: TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
                const SizedBox(height: 2),
                Text(_recipient.shortAddress,
                    style: const TextStyle(
                        color: AppColors.textGrey, fontSize: 13)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Text('Edit',
                style: TextStyle(
                    color: AppColors.primary50,
                    fontWeight: FontWeight.w600,
                    fontSize: 14)),
          ),
        ],
      ),
    );
  }

  /// A summary row whose value carries a green tick.
  static Widget _checkRow(String label, String value) {
    return SummaryRow(
      label,
      value,
      trailing: const Icon(Icons.check_circle,
          color: AppColors.success, size: 18),
    );
  }
}
