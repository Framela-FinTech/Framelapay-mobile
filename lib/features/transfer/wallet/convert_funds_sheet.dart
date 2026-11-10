import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/currency_wallet.dart';
import '../fiat/widgets/fiat_form_widgets.dart';
import 'convert_funds_form.dart';

/// "Convert Funds" as a bottom sheet — the presentation Home Transfer row 2
/// draws, for converting mid-transfer without leaving Send Money.
///
/// The Wallet tab reaches the same form as a full screen instead; see
/// `convert_funds_screen.dart`. Both share [ConvertFundsForm].
///
/// Returns a success message when a conversion completes, or null if
/// dismissed. The caller shows a success banner with that message.
Future<String?> showConvertFundsSheet(
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
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SectionTitle('Convert Funds'),
                InkWell(
                  onTap: () => Navigator.pop(sheetContext),
                  borderRadius: BorderRadius.circular(20),
                  child: const Icon(Icons.close,
                      size: 22, color: AppColors.primaryDark),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1, color: AppColors.divider),
            const SizedBox(height: 16),
            ConvertFundsForm(
              wallets: wallets,
              onConverted: (result) =>
                  Navigator.pop(sheetContext, result.bannerMessage),
            ),
          ],
        ),
      ),
    ),
  );
}
