import 'activity_transaction.dart';

/// Lifecycle state of a receipt — drives the status pill and the footer note.
enum ReceiptStatus { completed, pending, failed }

/// One label/value line in the receipt body.
///
/// The three receipt states show different field sets (a failed receipt carries
/// a refund status and failure reason, a pending one an estimated completion),
/// so the body is data-driven rather than a fixed set of named fields.
class ReceiptRow {
  final String label;
  final String value;
  const ReceiptRow(this.label, this.value);
}

/// A single transaction receipt shown in the Statements & Receipts section.
class TransactionReceipt {
  // ---- List row ----
  final String name;
  final String amount; // display amount, e.g. "€250.00"
  final String currencyAmount; // e.g. "EUR 250.00"
  final String reference;
  final String transactionId; // e.g. "FRM-20261010-10429"
  final String date; // e.g. "15 September 2026"

  // ---- Receipt detail ----
  final ReceiptStatus status;
  final String headlineAmount; // large amount on the receipt card
  final String caption; // e.g. "Money sent · Ken Okafor"
  final List<ReceiptRow> rows;
  final String statusNote; // e.g. "Transaction successful"

  const TransactionReceipt({
    required this.name,
    required this.amount,
    required this.currencyAmount,
    required this.reference,
    required this.transactionId,
    required this.date,
    required this.status,
    required this.headlineAmount,
    required this.caption,
    required this.rows,
    required this.statusNote,
  });

  String get listSubtitle => 'Ref $reference · $date';

  /// Builds the receipt shown when a History row is tapped.
  ///
  /// [ActivityTransaction] carries far less than a real receipt does, so the
  /// rows here are derived from what a list row knows. Once receipts come from
  /// the backend this is replaced by a fetch on the transaction id.
  factory TransactionReceipt.fromActivity(ActivityTransaction transaction) {
    final parts = transaction.subtitle.split(' · ');
    final method = parts.first;
    final unsigned = transaction.amount.replaceFirst(RegExp(r'^[+-]'), '');
    final digits = transaction.date.replaceAll(RegExp(r'[^0-9]'), '');

    final status = switch (transaction.status) {
      ActivityTransactionStatus.completed => ReceiptStatus.completed,
      ActivityTransactionStatus.pending => ReceiptStatus.pending,
      ActivityTransactionStatus.failed => ReceiptStatus.failed,
    };
    final note = switch (status) {
      ReceiptStatus.completed => 'Transaction successful',
      ReceiptStatus.pending => 'Processing transaction',
      ReceiptStatus.failed => 'Transaction unsuccessful',
    };

    return TransactionReceipt(
      name: transaction.title,
      amount: transaction.amount,
      currencyAmount: '${transaction.currency} $unsigned',
      reference: digits,
      transactionId: 'FRM-$digits',
      date: transaction.date,
      status: status,
      headlineAmount: unsigned,
      caption: transaction.title,
      statusNote: note,
      rows: [
        ReceiptRow(transaction.incoming ? 'Received' : 'Sent', unsigned),
        ReceiptRow('Category', transaction.category),
        ReceiptRow('Payment method', method),
        ReceiptRow('Currency', transaction.currency),
        ReceiptRow('Date and time', transaction.date),
        if (status == ReceiptStatus.failed)
          const ReceiptRow('Failure reason', 'Rate expired before confirmation'),
        if (status == ReceiptStatus.pending)
          const ReceiptRow('Estimated completion', 'Within 1 hour'),
      ],
    );
  }
}

/// Mock receipts used until a backend is wired in — one per receipt state.
const List<TransactionReceipt> sampleReceipts = [
  TransactionReceipt(
    name: 'Ken Okafor',
    amount: '₦783,750.00',
    currencyAmount: 'NGN 783,750.00',
    reference: '10429',
    transactionId: 'FRM-20261010-10429',
    date: '10 October 2026',
    status: ReceiptStatus.completed,
    headlineAmount: '₦783,750.00',
    caption: 'Money sent · Ken Okafor',
    statusNote: 'Transaction successful',
    rows: [
      ReceiptRow('From', 'Cynthia Nkechi'),
      ReceiptRow('To', 'Ken Okafor · GTBank'),
      ReceiptRow('Account', '•••• 6789'),
      ReceiptRow('You sent', '\$500.00'),
      ReceiptRow('Transfer fee', '\$2.50'),
      ReceiptRow('Total paid', '\$502.50'),
      ReceiptRow('Exchange rate', '1 USD = ₦1,567.50'),
      ReceiptRow('Purpose', 'Family support'),
      ReceiptRow('Payment method', 'Bank Transfer'),
      ReceiptRow('Date and time', '10 Oct 2026 · 10:45 AM WAT'),
    ],
  ),
  TransactionReceipt(
    name: 'EUR to NGN',
    amount: '€250.00',
    currencyAmount: 'EUR 250.00',
    reference: '10430',
    transactionId: 'FRM-20261010-10430',
    date: '10 October 2026',
    status: ReceiptStatus.failed,
    headlineAmount: '€250.00',
    caption: 'Currency exchange · EUR to NGN',
    statusNote: 'Transaction unsuccessful',
    rows: [
      ReceiptRow('From', 'EUR wallet'),
      ReceiptRow('To', 'NGN wallet'),
      ReceiptRow('Amount to convert', '€250.00'),
      ReceiptRow('Requested rate', '1 EUR = ₦1,850.00'),
      ReceiptRow('Transfer fee', '€0.00'),
      ReceiptRow('Refund status', 'Amount returned to EUR wallet'),
      ReceiptRow('Failure reason', 'Rate expired before confirmation'),
      ReceiptRow('Date and time', '10 Oct 2026 · 10:30 AM WAT'),
    ],
  ),
  TransactionReceipt(
    name: 'Michael Ade',
    amount: '€250.00',
    currencyAmount: 'EUR 250.00',
    reference: '10431',
    transactionId: 'FRM-20261010-10431',
    date: '10 October 2026',
    status: ReceiptStatus.pending,
    headlineAmount: '€250.00',
    caption: 'Currency exchange · EUR to NGN',
    statusNote: 'Processing transaction',
    rows: [
      ReceiptRow('From', 'Cynthia Nkechi'),
      ReceiptRow('To', 'Michael Ade'),
      ReceiptRow('You sent', '€500.00'),
      ReceiptRow('Transfer fee', '€0.00'),
      ReceiptRow('Total paid', '€500.00'),
      ReceiptRow('Purpose', 'Personal transfer'),
      ReceiptRow('Payment method', 'EUR wallet transfer'),
      ReceiptRow('Date and time', '10 Oct 2026 · 10:32 AM WAT'),
      ReceiptRow('Estimated completion', 'Within 1 hour'),
    ],
  ),
];
