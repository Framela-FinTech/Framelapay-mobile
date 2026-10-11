/// A single-currency balance in the user's Framela wallet.
///
/// Separate from the existing `WalletBalance` (which is NGN-locked and used
/// by the home dashboard) because the Wallet transfer flow and the Convert
/// Funds sheet need multiple currencies with their own symbols.
class CurrencyWallet {
  final String code; // NGN, USD, GBP, UAH
  final String name; // Nigerian Naira, US Dollar, ...
  final String symbol; // ₦, $, £, ₴
  final double balance;

  const CurrencyWallet({
    required this.code,
    required this.name,
    required this.symbol,
    required this.balance,
  });

  /// e.g. "₦150,000.00"
  String get formattedBalance => '$symbol${_fmt(balance)}';

  /// ISO country code for the `country_flags` package (EU for the euro).
  String get countryCode {
    switch (code) {
      case 'USD':
        return 'US';
      case 'GBP':
        return 'GB';
      case 'EUR':
        return 'EU';
      case 'NGN':
        return 'NG';
      case 'UAH':
        return 'UA';
      default:
        return code;
    }
  }

  static String _fmt(double v) {
    final s = v.toStringAsFixed(2);
    final parts = s.split('.');
    final withCommas = parts[0].replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (m) => '${m[1]},',
    );
    return '$withCommas.${parts[1]}';
  }
}
