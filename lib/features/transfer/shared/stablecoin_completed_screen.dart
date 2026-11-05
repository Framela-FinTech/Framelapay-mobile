import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../data/models/transfer_recipient.dart';

/// Landing screen once a stablecoin transfer clears.
///
/// Summary only — "View Transfer" opens the full
/// [TransactionDetailsScreen] with the per-field breakdown.
class StablecoinCompletedScreen extends StatelessWidget {
  final TransferRecipient recipient;
  final String amount;
  final String network;
  final String reference;
  final String completedAt;

  const StablecoinCompletedScreen({
    super.key,
    required this.recipient,
    this.amount = '350 USDC',
    this.network = 'Ethereum',
    this.reference = 'FRM-20261010-10429',
    this.completedAt = '10 October 2026 · 10:45 AM WAT',
  });

  @override
  Widget build(BuildContext context) {
    final recipientName = recipient.isFramelaUser
        ? (recipient.name ?? 'Recipient')
        : 'External wallet';

    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
          child: Column(
            children: [
              const _SuccessTick(),
              const SizedBox(height: 20),
              const Text('Transfer completed',
                  style: TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w800,
                      fontSize: 22)),
              const SizedBox(height: 32),
              _card(
                child: Column(
                  children: [
                    Text(amount,
                        style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w800,
                            fontSize: 32)),
                    const SizedBox(height: 10),
                    const Text('Sent to',
                        style: TextStyle(
                            color: AppColors.textGrey, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(recipientName,
                        style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 17)),
                    const SizedBox(height: 6),
                    Text('Network · $network',
                        style: const TextStyle(
                            color: AppColors.textGrey, fontSize: 15)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _card(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _row('Transaction reference', reference),
                    const Divider(height: 1, color: AppColors.divider),
                    _row('Completed', completedAt),
                  ],
                ),
              ),
              const SizedBox(height: 28),
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
                    AppRoutes.transactionDetails,
                    arguments: recipient,
                  ),
                  child: const Text('View Transfer'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    minimumSize: const Size.fromHeight(56),
                    side: const BorderSide(color: AppColors.divider),
                    foregroundColor: AppColors.primaryDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, AppRoutes.home, (route) => false),
                  child: const Text('Back Home',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card({required Widget child, EdgeInsets? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.symmetric(vertical: 26),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.card,
      ),
      child: child,
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textGrey, fontSize: 15)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 15)),
          ),
        ],
      ),
    );
  }
}

/// Green tick inside a soft halo, as the Figma success state shows it.
class _SuccessTick extends StatelessWidget {
  const _SuccessTick();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      height: 104,
      decoration: const BoxDecoration(
        color: AppColors.successSoft,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 84,
          height: 84,
          decoration: const BoxDecoration(
            color: AppColors.success,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 44),
        ),
      ),
    );
  }
}
