import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../data/models/processing_step.dart';
import '../../../data/models/transfer_auth_flow.dart';
import '../../../data/models/transfer_recipient.dart';
import 'widgets/recipient_summary_card.dart';

class ReviewTransferScreen extends StatelessWidget {
  final TransferRecipient recipient;
  final String amount;
  final String network;
  final String networkStandard;
  final String networkFee;
  final String totalAmount;

  const ReviewTransferScreen({
    super.key,
    required this.recipient,
    this.amount = '250.00 USDC',
    this.network = 'Ethereum',
    this.networkStandard = 'ERC-20',
    this.networkFee = '0.50 USDC',
    this.totalAmount = '250.50 USDC',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: AppColors.primaryDark),
        title: const Text('Review',
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
              const Text('Review transfer',
                  style: TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 17)),
              const SizedBox(height: 4),
              const Text('Please review the details carefully before sending.',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 15)),
              const SizedBox(height: 18),
              RecipientSummaryCard(recipient: recipient),
              const SizedBox(height: 14),
              _detailsCard(),
              const SizedBox(height: 14),
              _noticeBanner(),
              const SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(56),
                  ),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.verifyFingerprint,
                    arguments: _stablecoinAuthFlow(),
                  ),
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// White card holding the four transfer figures, hairline-separated.
  Widget _detailsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          _row(
            'You send',
            amount,
            leading: const AppIcon('coins', size: 28, color: Color(0xFF2775CA)),
          ),
          const Divider(height: 1, color: AppColors.divider),
          _row(
            'Network',
            network,
            sub: networkStandard,
            leading: const AppIcon('data',
                size: 24, color: AppColors.primaryDark),
          ),
          const Divider(height: 1, color: AppColors.divider),
          _row('Network fee', networkFee),
          const Divider(height: 1, color: AppColors.divider),
          _row('Total amount', totalAmount),
        ],
      ),
    );
  }

  Widget _noticeBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kStablecoinPaleBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline,
              size: 26, color: AppColors.primaryDark),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'This transfer will be sent directly to the wallet address on the '
              '${network.toLowerCase()} network. Once sent, it cannot be reversed.',
              style: const TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
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

  /// One figure row; [leading] is the small mark Figma puts beside the value,
  /// [sub] the grey qualifier underneath it (the network standard).
  Widget _row(String label, String value, {Widget? leading, String? sub}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.primaryDark, fontSize: 15)),
          const Spacer(),
          if (leading != null) ...[leading, const SizedBox(width: 10)],
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value,
                  style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 17)),
              if (sub != null)
                Text(sub,
                    style: const TextStyle(
                        color: AppColors.textGrey, fontSize: 15)),
            ],
          ),
        ],
      ),
    );
  }
}