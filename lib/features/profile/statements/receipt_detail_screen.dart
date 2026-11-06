import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/widgets/share_receipt_sheet.dart';
import '../../../data/models/transaction_receipt.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Receipt detail — the branded receipt card plus Share / Back to Activity.
///
/// Renders the same card for every [ReceiptStatus]; the pill colour, the
/// footer note and the body rows come from the receipt itself.
class ReceiptDetailScreen extends StatelessWidget {
  final TransactionReceipt receipt;
  const ReceiptDetailScreen({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Receipt'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: _ReceiptCard(receipt: receipt),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                children: [
                  PrimaryButton(
                    'Share Receipt',
                    onPressed: () => showShareReceiptSheet(context),
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
                        context,
                        AppRoutes.activity,
                        (route) => route.isFirst,
                      ),
                      child: const Text(
                        'Back to Activity',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class _ReceiptCard extends StatelessWidget {
  final TransactionReceipt receipt;
  const _ReceiptCard({required this.receipt});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Brand mark + status pill ----
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/framelapay_logo.png',
                height: 26,
                errorBuilder: (_, __, ___) => const SizedBox(height: 26),
              ),
              _StatusPill(status: receipt.status),
            ],
          ),
          const SizedBox(height: 14),
          // ---- Headline amount + caption ----
          Center(
            child: Column(
              children: [
                Text(
                  receipt.headlineAmount,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  receipt.caption,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppColors.textGrey, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Divider(height: 1, color: AppColors.divider),
          // ---- Detail rows ----
          for (var i = 0; i < receipt.rows.length; i++) ...[
            _DetailRow(row: receipt.rows[i]),
            if (i != receipt.rows.length - 1)
              const Divider(height: 1, color: AppColors.divider),
          ],
          const SizedBox(height: 16),
          // ---- Reference + status note ----
          _ReferenceBox(
            reference: receipt.transactionId,
            note: receipt.statusNote,
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final ReceiptRow row;
  const _DetailRow({required this.row});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            row.label,
            style: const TextStyle(color: AppColors.textGrey, fontSize: 14),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              row.value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dashed-outline footer carrying the reference code and the status note.
class _ReferenceBox extends StatelessWidget {
  final String reference;
  final String note;
  const _ReferenceBox({required this.reference, required this.note});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        child: Column(
          children: [
            Text(
              reference,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              note,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.textGrey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

/// Draws a dashed rounded rectangle — avoids pulling in a border package.
class _DashedBorderPainter extends CustomPainter {
  static const double _radius = 12;
  static const double _dash = 5;
  static const double _gap = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Offset.zero & size,
        const Radius.circular(_radius),
      ));

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + _dash;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0.0, metric.length)),
          paint,
        );
        distance = next + _gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StatusPill extends StatelessWidget {
  final ReceiptStatus status;
  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    late final String label;
    late final Color foreground;
    switch (status) {
      case ReceiptStatus.completed:
        label = 'Completed';
        foreground = AppColors.success;
      case ReceiptStatus.failed:
        label = 'Failed';
        foreground = AppColors.error;
      case ReceiptStatus.pending:
        label = 'Pending';
        foreground = AppColors.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        // Figma uses a soft tint of the status colour behind the label.
        color: foreground.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foreground,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
