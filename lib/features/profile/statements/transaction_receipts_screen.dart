import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../data/models/transaction_receipt.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Transaction Receipts list — search by recipient/reference, tap a row to open
/// its receipt.
class TransactionReceiptsScreen extends StatefulWidget {
  const TransactionReceiptsScreen({super.key});

  @override
  State<TransactionReceiptsScreen> createState() =>
      _TransactionReceiptsScreenState();
}

class _TransactionReceiptsScreenState extends State<TransactionReceiptsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final results = q.isEmpty
        ? sampleReceipts
        : sampleReceipts
            .where((r) =>
                r.name.toLowerCase().contains(q) ||
                r.reference.toLowerCase().contains(q))
            .toList();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Transaction Receipts'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              TextField(
                onChanged: (v) => setState(() => _query = v),
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  prefixIcon: const AppIcon('search',
                      size: 18, color: AppColors.textGrey),
                  hintText: 'Search recipient or reference',
                  hintStyle: const TextStyle(
                      fontSize: 14, color: AppColors.textGrey),
                  filled: true,
                  fillColor: AppColors.inputFill,
                  contentPadding: const EdgeInsets.symmetric(vertical: 4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _receiptRow(results[i]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _receiptRow(TransactionReceipt r) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRoutes.receiptDetail,
          arguments: r),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(r.listSubtitle,
                      style: const TextStyle(
                          color: AppColors.textGrey, fontSize: 11)),
                ],
              ),
            ),
            Text(r.amount,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(width: 4),
            const AppIcon('chevron-right', size: 18, color: AppColors.textGrey),
          ],
        ),
      ),
    );
  }
}
