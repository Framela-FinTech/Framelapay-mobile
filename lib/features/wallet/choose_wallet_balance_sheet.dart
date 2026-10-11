import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_icon.dart';
import '../../data/models/currency_wallet.dart';
import '../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Screen 3 — "Choose wallet balance" bottom sheet, opened from the balance
/// card's "All Accounts" pill. Returns the chosen selection key
/// ("all" or a currency code), or null if dismissed.
Future<String?> showChooseWalletBalanceSheet(
  BuildContext context,
  List<CurrencyWallet> wallets,
) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _ChooseWalletBalanceSheet(wallets: wallets),
  );
}

class _ChooseWalletBalanceSheet extends StatefulWidget {
  final List<CurrencyWallet> wallets;
  const _ChooseWalletBalanceSheet({required this.wallets});

  @override
  State<_ChooseWalletBalanceSheet> createState() =>
      _ChooseWalletBalanceSheetState();
}

class _ChooseWalletBalanceSheetState extends State<_ChooseWalletBalanceSheet> {
  String _selected = 'all';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Choose wallet balance',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _option('all', 'All wallets', 'Combined indicative balance'),
            ...widget.wallets.map(
              (w) => _option(w.code, '${w.name} wallet', w.formattedBalance),
            ),
            const SizedBox(height: 8),
            const Divider(),
            const Row(
              children: [
                Expanded(
                  child: Text('Preferred total currency',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                ),
                Text('EUR',
                    style: TextStyle(
                        color: AppColors.textGrey, fontSize: 13)),
                SizedBox(width: 4),
                AppIcon('chevron-right', size: 18, color: AppColors.textGrey),
              ],
            ),
            const SizedBox(height: 20),
            PrimaryButton('Confirm',
                onPressed: () => Navigator.pop(context, _selected)),
          ],
        ),
      ),
    );
  }

  Widget _option(String key, String title, String subtitle) {
    final selected = _selected == key;
    return InkWell(
      onTap: () => setState(() => _selected = key),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.accentYellow : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
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
                          color: AppColors.textGrey, fontSize: 12)),
                ],
              ),
            ),
            Radio<String>(
              value: key,
              groupValue: _selected,
              activeColor: AppColors.accentYellow,
              onChanged: (v) => setState(() => _selected = v!),
            ),
          ],
        ),
      ),
    );
  }
}
