import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';

/// One label/value line on a receipt.
class ReceiptLine {
  final String label;
  final String value;
  const ReceiptLine(this.label, this.value);
}

/// The branded receipt artifact: logo + status pill, headline amount, detail
/// rows, and a dashed reference footer.
///
/// Parameterized by primitives rather than by a model, because the two callers
/// own different ones ([TransactionReceipt] in Statements, [FiatTransfer] in
/// the transfer flow) and neither should have to fabricate the other's fields.
class ReceiptCard extends StatelessWidget {
  final String statusLabel;
  final Color statusColor;

  /// Pill fill. Defaults to a soft tint of [statusColor]; pass a token when
  /// the board specifies an exact fill.
  final Color? statusBackground;

  final String headlineAmount;
  final String caption;
  final List<ReceiptLine> rows;
  final String reference;
  final String note;

  const ReceiptCard({
    super.key,
    required this.statusLabel,
    required this.statusColor,
    required this.headlineAmount,
    required this.caption,
    required this.rows,
    required this.reference,
    required this.note,
    this.statusBackground,
  });

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
              _StatusPill(
                label: statusLabel,
                foreground: statusColor,
                background: statusBackground,
              ),
            ],
          ),
          const SizedBox(height: 14),
          // ---- Headline amount + caption ----
          Center(
            child: Column(
              children: [
                Text(
                  headlineAmount,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  caption,
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(color: AppColors.textGrey, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Divider(height: 1, color: AppColors.divider),
          // ---- Detail rows ----
          for (var i = 0; i < rows.length; i++) ...[
            _DetailRow(row: rows[i]),
            if (i != rows.length - 1)
              const Divider(height: 1, color: AppColors.divider),
          ],
          const SizedBox(height: 16),
          // ---- Reference + status note ----
          _ReferenceBox(reference: reference, note: note),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final ReceiptLine row;
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
              style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
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
  final String label;
  final Color foreground;
  final Color? background;
  const _StatusPill({
    required this.label,
    required this.foreground,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        // Figma uses a soft tint of the status colour behind the label.
        color: background ?? foreground.withValues(alpha: 0.12),
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
