import 'currency_wallet.dart';

/// The outcome of a completed currency conversion, carried from the convert
/// form through the completion screen to the receipt.
class ConversionResult {
  final CurrencyWallet from;
  final CurrencyWallet to;

  /// Amount taken from [from], in its own currency.
  final double amountConverted;

  /// Fee taken in [from]'s currency, already deducted.
  final double fee;

  /// Amount credited to [to], in its own currency.
  final double amountReceived;

  final String rateText;
  final String reference;
  final String dateTime;

  const ConversionResult({
    required this.from,
    required this.to,
    required this.amountConverted,
    required this.fee,
    required this.amountReceived,
    required this.rateText,
    this.reference = 'FRM-20261103-1500',
    this.dateTime = '3 November 2026 · 3:00 PM WAT',
  });

  String get formattedConverted =>
      '${from.symbol}${CurrencyWallet.format(amountConverted)}';
  String get formattedFee => '${from.symbol}${CurrencyWallet.format(fee)}';
  String get formattedReceived =>
      '${to.symbol}${CurrencyWallet.format(amountReceived)}';

  /// e.g. "£1,000.00 converted to $1,265.82" — the inline banner's wording.
  String get bannerMessage =>
      '$formattedConverted converted to $formattedReceived';
}
