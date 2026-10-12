import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/transfer_recipient.dart';
import '../../../data/models/processing_step.dart';
import '../../../data/models/transfer_auth_flow.dart';
import '../../../core/routes/app_routes.dart';

class ReviewTransferScreen extends StatelessWidget {
  final TransferRecipient recipient;
  final String amount;
  final String network;
  final String networkFee;
  final String totalAmount;

  const ReviewTransferScreen({
    super.key,
    required this.recipient,
    this.amount = '250.00 USDC',
    this.network = 'Ethereum (ERC-20)',
    this.networkFee = '0.50 USDC',
    this.totalAmount = '250.50 USDC',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Send USDC',
            style: TextStyle(color: Colors.black, fontSize: 16)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Review transfer',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)),
                    const SizedBox(height: 4),
                    const Text(
                        'Please review the details carefully before sending.',
                        style:
                            TextStyle(color: AppColors.textGrey, fontSize: 12)),
                    const SizedBox(height: 16),
                    _buildRecipientTile(),
                    const Divider(height: 32),
                    _row('You send', amount),
                    _row('Network', network),
                    _row('Network fee', networkFee),
                    const Divider(),
                    _row('Total amount', totalAmount, bold: true),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF4E5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'This transfer will be sent directly to the wallet address on the selected network. Once sent, it cannot be reversed.',
                        style: TextStyle(fontSize: 11, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.verifyFingerprint,
                        arguments: _stablecoinAuthFlow(),
                      ),
                  child: const Text('Continue'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the neutral auth/processing continuation for the stablecoin flow.
  /// These are the same steps the processing screen showed before; the
  /// completion target is the stablecoin transaction-details screen, which
  /// still takes a `TransferRecipient` — so behavior is unchanged.
  TransferAuthFlow _stablecoinAuthFlow() {
    return TransferAuthFlow(
      completionRoute: AppRoutes.transactionDetails,
      completionArgs: recipient,
      processingSteps: const [
        ProcessingStep(
            title: 'Transfer initiated',
            time: '10:41 AM',
            subtitle: 'Your transfer has been created',
            done: true),
        ProcessingStep(
            title: 'Broadcasting network',
            time: '10:42 AM',
            subtitle: 'Sending your transaction to Ethereum network.',
            done: true),
        ProcessingStep(
            title: 'Awaiting confirmation',
            subtitle: 'This may take a few minutes.'),
        ProcessingStep(
            title: 'Finalizing transfer', subtitle: 'Almost there...'),
      ],
    );
  }

  /// Branches display based on recipient type — FramelaPay user shows
  /// avatar + name + handle; external wallet shows wallet icon + truncated address.
  Widget _buildRecipientTile() {
    if (recipient.isFramelaUser) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const CircleAvatar(
            backgroundColor: AppColors.inputFill,
            child: Icon(Icons.person, color: AppColors.primaryDark)),
        title: Text(recipient.name ?? '',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text('${recipient.handle ?? ''} · FramelaPay user',
            style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
        trailing: TextButton(onPressed: () {}, child: const Text('Edit')),
      );
    } else {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const CircleAvatar(
            backgroundColor: AppColors.inputFill,
            child: Icon(Icons.account_balance_wallet_outlined,
                color: AppColors.primaryDark)),
        title: const Text('External wallet',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(_truncateAddress(recipient.walletAddress),
            style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
        trailing: TextButton(onPressed: () {}, child: const Text('Edit')),
      );
    }
  }

  String _truncateAddress(String address) {
    if (address.length <= 14) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
          Text(value,
              style: TextStyle(
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
                  fontSize: 13)),
        ],
      ),
    );
  }
}