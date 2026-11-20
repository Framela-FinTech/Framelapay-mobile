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

  /// ISO-2 country code for the `country_flags` package (e.g. EU for EUR, US for USD).
  /// Maps all supported and newly created wallet currencies to their respective country flags.
  String get countryCode {
    switch (code.toUpperCase()) {
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
      case 'GHS':
        return 'GH';
      case 'KES':
        return 'KE';
      case 'ZAR':
        return 'ZA';
      case 'CAD':
        return 'CA';
      case 'AED':
        return 'AE';
      case 'AUD':
        return 'AU';
      case 'INR':
        return 'IN';
      case 'CNY':
        return 'CN';
      case 'JPY':
        return 'JP';
      case 'BRL':
        return 'BR';
      case 'EGP':
        return 'EG';
      case 'RWF':
        return 'RW';
      case 'TZS':
        return 'TZ';
      case 'UGX':
        return 'UG';
      default:
        return code.length >= 2 ? code.substring(0, 2) : code;
    }
  }

  /// Thousands-separated amount with 2 decimals, e.g. 150000 -> "150,000.00".
  /// Public so conversion results and the convert form share one formatter.
  static String format(double v) => _fmt(v);

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
