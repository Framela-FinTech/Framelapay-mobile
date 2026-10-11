/// A row in the Wallet tab's "Recent Activity" list.
enum WalletActivityStatus { completed, failed }

class WalletActivity {
  final bool incoming; // true = money received (up/green), false = sent (down)
  final String title;
  final String time;
  final String amount; // pre-formatted, e.g. "USD · $250"
  final WalletActivityStatus status;

  const WalletActivity({
    required this.incoming,
    required this.title,
    required this.time,
    required this.amount,
    required this.status,
  });

  bool get isCompleted => status == WalletActivityStatus.completed;
}
