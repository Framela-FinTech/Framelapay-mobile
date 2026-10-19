enum ActivityTransactionStatus { completed, pending, failed }

class ActivityTransaction {
  final String month;
  final String date;
  final String title;
  final String subtitle;
  final String amount;
  final bool incoming;
  final String category;
  final String currency;
  final ActivityTransactionStatus status;
  final String icon;

  const ActivityTransaction({
    required this.month,
    required this.date,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.incoming,
    required this.category,
    required this.currency,
    required this.status,
    required this.icon,
  });
}
