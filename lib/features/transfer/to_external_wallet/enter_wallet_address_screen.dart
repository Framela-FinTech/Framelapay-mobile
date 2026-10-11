import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';

class EnterWalletAddressScreen extends StatelessWidget {
  const EnterWalletAddressScreen({super.key});

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
              const SizedBox(height: 20),
              const Text('Enter recipient address',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
              const SizedBox(height: 6),
              const Text(
                "Paste the wallet address or scan a QR code to get the recipient's address.",
                style: TextStyle(color: AppColors.textGrey, fontSize: 12),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Wallet address',
                  hintText: '0x...',
                  suffixIcon: const Icon(Icons.qr_code_scanner),
                  filled: true,
                  fillColor: AppColors.inputFill,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Amount',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(height: 12),
              TextField(
                keyboardType: TextInputType.number,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
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
                    context, AppRoutes.verifyWalletAddress),
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