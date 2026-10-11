/// A single transaction receipt shown in the Statements & Receipts section.
class TransactionReceipt {
  final String name;
  final String amount; // display amount, e.g. "€250.00"
  final String currencyAmount; // e.g. "EUR 250.00"
  final String reference;
  final String transactionId;
  final String date; // e.g. "15 September 2026"

  const TransactionReceipt({
    required this.name,
    required this.amount,
    required this.currencyAmount,
    required this.reference,
    required this.transactionId,
    required this.date,
  });

  String get listSubtitle => 'Ref $reference · $date';
}

/// Mock receipts used until a backend is wired in.
const List<TransactionReceipt> sampleReceipts = [
  TransactionReceipt(
    name: 'John Doe',
    amount: '€250.00',
    currencyAmount: 'EUR 250.00',
    reference: '1199',
    transactionId: '2026092-10428',
    date: '15 September 2026',
  ),
  TransactionReceipt(
    name: 'Michael Ade',
    amount: '€300.00',
    currencyAmount: 'EUR 300.00',
    reference: '1204',
    transactionId: '2026092-10512',
    date: '18 September 2026',
  ),
];
