class WalletBalance {
  final String currencyCode; // NGN, USD, etc.
  final double fiatAmount;
  final double usdcEquivalent;

  const WalletBalance({
    required this.currencyCode,
    required this.fiatAmount,
    required this.usdcEquivalent,
  });

  String get formattedFiat =>
      '₦${fiatAmount.toStringAsFixed(2).replaceAllMapped(
            RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]},',
          )}';
}