import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/transfer_recipient.dart';

class EnterAmountScreen extends StatelessWidget {
  const EnterAmountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // In a real flow this would come from the previous screen's
    // selected contact — hardcoded here since navigation args from
    // the contact list aren't being consumed yet.
    const recipient = TransferRecipient(
      type: RecipientType.framelaUser,
      name: 'Cynthia Nkechi',
      handle: '@cynthian',
      walletAddress: '0x8a71...94cd',
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Send Stablecoin',
            style: TextStyle(color: Colors.black, fontSize: 16)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  const CircleAvatar(
                      backgroundColor: AppColors.inputFill,
                      child: Icon(Icons.attach_money,
                          color: AppColors.primaryDark)),
                  const SizedBox(width: 10),
                  const Text('USDC · Ethereum',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13)),
                  const Spacer(),
                  TextButton(onPressed: () {}, child: const Text('Change')),
                ],
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                    backgroundColor: AppColors.inputFill,
                    child: Icon(Icons.person, color: AppColors.primaryDark)),
                title: const Text('Cynthia Nkechi',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                subtitle: const Text('@cynthian · FramelaPay user',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                trailing:
                    const Icon(Icons.check_circle, color: AppColors.success),
              ),
              const SizedBox(height: 20),
              const Text('Enter amount',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(height: 4),
              const Text(
                  'Enter the amount of USDC you want to send to Cynthia Nkechi.',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
              const SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.number,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                decoration: const InputDecoration(
                  hintText: '0.00',
                  suffixText: 'USDC',
                  border: InputBorder.none,
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Available balance: 1,250.00 USDC',
                      style:
                          TextStyle(color: AppColors.textGrey, fontSize: 12)),
                  TextButton(onPressed: () {}, child: const Text('Use max')),
                ],
              ),
              const SizedBox(height: 8),
              const Text('Network Fee: 0.50 USDC',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
              const SizedBox(height: 20),
              const Text('Recent address',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              _walletTile('My MetaMask', '0x3a71...F3d9'),
              _walletTile('Coinbase Wallet', '0x89c4...2e10'),
              const SizedBox(height: 24),
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

  Widget _walletTile(String name, String address) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(
          backgroundColor: AppColors.inputFill,
          child: Icon(Icons.account_balance_wallet_outlined,
              color: AppColors.primaryDark)),
      title: Text(name,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      subtitle: Text(address,
          style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
    );
  }
}