import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../data/models/transfer_recipient.dart';
import '../shared/widgets/asset_network_bar.dart';
import '../shared/widgets/recipient_summary_card.dart';

class EnterAmountScreen extends StatelessWidget {
  const EnterAmountScreen({super.key});

  /// The fee strip is the panel blue; "Use max" uses the deeper Primary 40.
  static const _panelBlue = AppColors.infoPanel;
  static const _linkBlue = AppColors.primary40;

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
      backgroundColor: AppColors.pageGrey,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: AppColors.primaryDark),
        title: const Text('Enter Amount',
            style: TextStyle(
                color: AppColors.primaryDark,
                fontSize: 20,
                fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AssetNetworkBar(onChange: () => Navigator.pop(context)),
              const SizedBox(height: 14),
              const RecipientSummaryCard(recipient: recipient),
              const SizedBox(height: 26),
              const Text('Enter amount',
                  style: TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 17)),
              const SizedBox(height: 4),
              Text(
                  'Enter the amount of USDC you want to send to ${recipient.name ?? 'this recipient'}.',
                  style: const TextStyle(
                      color: AppColors.textGrey, fontSize: 15)),
              const SizedBox(height: 18),
              const Text('Amount',
                  style: TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 17)),
              const SizedBox(height: 8),
              _amountField(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Available balance: 1,250.00 USDC',
                      style: TextStyle(
                          color: AppColors.primaryDark, fontSize: 15)),
                  GestureDetector(
                    onTap: () {},
                    child: const Text('Use max',
                        style: TextStyle(
                            color: _linkBlue,
                            fontSize: 15,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: _panelBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Network Fee',
                        style: TextStyle(
                            color: AppColors.textGrey, fontSize: 15)),
                    Text(r'$ 0.50 USDC',
                        style: TextStyle(
                            color: AppColors.textGrey, fontSize: 15)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
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
                    AppRoutes.reviewTransfer,
                    arguments: recipient,
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

  Widget _amountField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Expanded(
            child: TextField(
              keyboardType: TextInputType.number,
              style: TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: '0.00',
                hintStyle: TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
          Container(width: 1, height: 28, color: AppColors.divider),
          const SizedBox(width: 12),
          const Text('USDC',
              style: TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 17,
                  fontWeight: FontWeight.w600)),
          const AppIcon('chevron-right',
              size: 22, color: AppColors.primaryDark),
        ],
      ),
    );
  }
}
