import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/transfer_recipient.dart';

class VerifyWalletAddressScreen extends StatelessWidget {
  const VerifyWalletAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const recipient = TransferRecipient(
      type: RecipientType.externalWallet,
      walletAddress: '0x71F3A2c4B6e9....8F29',
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Send USDC',
            style: TextStyle(color: Colors.black, fontSize: 16)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text('Verify wallet address',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
              const SizedBox(height: 4),
              const Text(
                'Confirm that the wallet address is correct and compatible with the selected network.',
                style: TextStyle(color: AppColors.textGrey, fontSize: 12),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                    backgroundColor: AppColors.inputFill,
                    child: Icon(Icons.account_balance_wallet_outlined,
                        color: AppColors.primaryDark)),
                title: const Text('External wallet',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                subtitle: const Text('0x71F3A2c4B6e9....8F29',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                trailing:
                    TextButton(onPressed: () {}, child: const Text('Edit')),
              ),
              const Divider(height: 32),
              _row('Asset', 'USDC · USD Coin'),
              _row('Network', 'Ethereum · ERC-20'),
              _row('Recipient address', '0x8a71...94cd'),
              _verifiedRow('Network compatibility', 'Compatible'),
              _verifiedRow('Address format', 'Valid · Correct format'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4E5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'This transfer will be sent directly to the wallet address on the Ethereum network. Once sent, it cannot be reversed.',
                  style: TextStyle(fontSize: 11, color: Colors.black87),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.reviewTransfer,
                  arguments: recipient,
                ),
                child: const Text('Continue'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _verifiedRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
          Row(
            children: [
              const Icon(Icons.check_circle,
                  color: AppColors.success, size: 16),
              const SizedBox(width: 4),
              Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppColors.success)),
            ],
          ),
        ],
      ),
    );
  }
}