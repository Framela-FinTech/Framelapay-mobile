import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/transfer_recipient.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final TransferRecipient recipient;
  final String transactionId;
  final String assetSent;
  final String network;
  final String networkFee;
  final String paymentMethod;
  final String dateTime;

  const TransactionDetailsScreen({
    super.key,
    required this.recipient,
    this.transactionId = 'FRM123456789',
    this.assetSent = '350 USDC',
    this.network = 'Ethereum',
    this.networkFee = '\$2.50 USDC',
    this.paymentMethod = 'Stablecoin',
    this.dateTime = '17 May 2026, 10:45 AM',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Transaction Details',
            style: TextStyle(color: Colors.black, fontSize: 16)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                    color: AppColors.success, shape: BoxShape.circle),
                child: const Icon(Icons.check, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 16),
              const Text('Transfer completed',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
              const SizedBox(height: 4),
              Text(transactionId,
                  style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
              const SizedBox(height: 24),
              _detailRow('Transaction Id', transactionId),
              _detailRow('Asset sent', assetSent),
              _detailRow('Network', network),
              _detailRow('Network fee', networkFee),
              // Branch: recipient-specific rows
              if (recipient.isFramelaUser) ...[
                _detailRow('Recipient', '${recipient.name} (${recipient.handle})'),
              ] else ...[
                _detailRow('Recipient', 'External wallet'),
              ],
              _detailRow('Wallet address', recipient.walletAddress),
              _detailRow('Recipient receives', assetSent),
              _detailRow('Payment method', paymentMethod),
              _detailRow('Status', 'Completed'),
              _detailRow('Date & Time', dateTime),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {},
                child: const Text('Share Receipt'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
               child: const Text('Back to Home')),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.right,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}