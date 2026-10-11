import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Statements & Receipts hub. Two destinations (Account Statements form and
/// the Transaction Receipts list) plus a quick statement-generation block.
class StatementsHubScreen extends StatefulWidget {
  const StatementsHubScreen({super.key});

  @override
  State<StatementsHubScreen> createState() => _StatementsHubScreenState();
}

class _StatementsHubScreenState extends State<StatementsHubScreen> {
  String _wallet = 'EUR Wallet';
  static const _wallets = ['EUR Wallet', 'USD Wallet', 'GBP Wallet', 'NGN Wallet'];

  void _generate() {
    Navigator.pushNamed(
      context,
      AppRoutes.statementReady,
      arguments: '$_wallet • Last 3 months',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Statements & Receipts'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _tile(
                icon: 'receipt',
                title: 'Account Statements',
                subtitle: 'Choose wallet and period below',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.accountStatements),
              ),
              _tile(
                icon: 'coins',
                title: 'Transaction Receipts',
                subtitle: 'Browse and download receipts',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.transactionReceipts),
              ),
              const SizedBox(height: 16),
              const FieldLabel('Wallet'),
              AppDropdownField(
                hint: 'Select wallet',
                value: _wallet,
                items: _wallets,
                onChanged: (v) => setState(() => _wallet = v ?? _wallet),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    side: const BorderSide(color: AppColors.divider),
                    foregroundColor: AppColors.primaryDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.accountStatements),
                  child: const Text('Choose Period'),
                ),
              ),
              const SizedBox(height: 12),
              PrimaryButton('Generate Statement', onPressed: _generate),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primaryDark,
              child: AppIcon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          color: AppColors.textGrey, fontSize: 11)),
                ],
              ),
            ),
            const AppIcon('chevron-right', color: AppColors.textGrey),
          ],
        ),
      ),
    );
  }
}
