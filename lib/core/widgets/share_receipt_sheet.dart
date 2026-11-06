import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Share-format picker for a receipt (Figma: PDF / Image).
///
/// Shared by every screen that offers "Share Receipt" — the receipt detail
/// screen, the stablecoin and fiat transaction details, and the fiat
/// transfer-completed screen — so the sheet stays identical across them.
Future<void> showShareReceiptSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) => SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Share Receipts',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(sheetContext),
                  icon: const Icon(Icons.close,
                      color: AppColors.primaryDark, size: 22),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _option(sheetContext, 'PDF'),
            const Divider(height: 1, color: AppColors.divider),
            _option(sheetContext, 'Image'),
            const SizedBox(height: 8),
          ],
        ),
      ),
    ),
  );
}

Widget _option(BuildContext sheetContext, String label) {
  return InkWell(
    onTap: () {
      Navigator.pop(sheetContext);
      ScaffoldMessenger.of(sheetContext).showSnackBar(
        SnackBar(content: Text('Receipt shared as $label')),
      );
    },
    child: SizedBox(
      height: 56,
      width: double.infinity,
      child: Center(
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    ),
  );
}
