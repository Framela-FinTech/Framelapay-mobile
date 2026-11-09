import 'package:country_flags/country_flags.dart';
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
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const Expanded(
                  child: Text('Choose wallet balance',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w800,
                          fontSize: 19)),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(20),
                  child: const Icon(Icons.close,
                      size: 22, color: AppColors.primaryDark),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
                'Switch between your combined balance and individual wallets.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
            const SizedBox(height: 20),
            _option(
              key: 'all',
              leading: Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                    color: AppColors.warningSoft, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const AppIcon('coins',
                    size: 20, color: AppColors.accentYellow),
              ),
              title: 'All wallets',
              subtitle: 'Combined indicative balance',
            ),
            ...widget.wallets.map(
              (w) => _option(
                key: w.code,
                leading: ClipOval(
                  child: CountryFlag.fromCountryCode(w.countryCode,
                      height: 38, width: 38),
                ),
                title: '${w.code} wallet',
                subtitle: '${w.formattedBalance} available',
              ),
            ),
            const SizedBox(height: 6),
            const Divider(height: 1, color: AppColors.divider),
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                      color: AppColors.iconTileSoft, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: const AppIcon('settings',
                      size: 20, color: AppColors.primaryDark),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('Preferred total currency',
                      style: TextStyle(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 15)),
                ),
                const Text('EUR',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
                const SizedBox(width: 4),
                const AppIcon('chevron-right',
                    size: 18, color: AppColors.textGrey),
              ],
            ),
            const SizedBox(height: 22),
            PrimaryButton('Confirm',
                onPressed: () => Navigator.pop(context, _selected)),
          ],
        ),
      ),
    );
  }

  Widget _option({
    required String key,
    required Widget leading,
    required String title,
    required String subtitle,
  }) {
    final selected = _selected == key;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => setState(() => _selected = key),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.primaryDark : AppColors.divider,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              leading,
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 15)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: const TextStyle(
                            color: AppColors.textGrey, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Drawn ring rather than a Radio: the board shows an unfilled
              // navy circle, and Radio's groupValue API is deprecated.
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        selected ? AppColors.primaryDark : AppColors.divider,
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: selected
                    ? Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryDark,
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
