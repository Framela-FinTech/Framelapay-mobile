/// How far back the rate chart looks.
enum RateRange { d1, d7, m1, m3 }

extension RateRangeLabel on RateRange {
  String get label => switch (this) {
        RateRange.d1 => '1D',
        RateRange.d7 => '7D',
        RateRange.m1 => '1M',
        RateRange.m3 => '3M',
      };
}

/// A currency pair, e.g. USD/NGN.
class CurrencyPair {
  final String baseCode;
  final String baseName;
  final String baseCountry; // ISO-2, for country_flags
  final String quoteCode;
  final String quoteName;
  final String quoteCountry;

  const CurrencyPair({
    required this.baseCode,
    required this.baseName,
    required this.baseCountry,
    required this.quoteCode,
    required this.quoteName,
    required this.quoteCountry,
  });

  String get label => '$baseCode / $quoteCode';
  String get tightLabel => '$baseCode/$quoteCode';
  String get description => '$baseName to $quoteName';

  @override
  bool operator ==(Object other) =>
      other is CurrencyPair &&
      other.baseCode == baseCode &&
      other.quoteCode == quoteCode;

  @override
  int get hashCode => Object.hash(baseCode, quoteCode);
}

/// One point on the rate chart. [label] is the x-axis caption, shown only for
/// a few points.
class RatePoint {
  final String label;
  final double value;
  const RatePoint(this.label, this.value);
}

/// A pair's current rate plus the series behind it.
class ExchangeRate {
  final CurrencyPair pair;
  final double rate;
  final String quoteSymbol;

  /// Movement over [range], as a percentage. Negative means the rate fell.
  final double changePercent;
  final RateRange range;
  final List<RatePoint> points;

  const ExchangeRate({
    required this.pair,
    required this.rate,
    required this.quoteSymbol,
    required this.changePercent,
    this.range = RateRange.d7,
    this.points = const [],
  });

  bool get isUp => changePercent >= 0;

  /// e.g. "+1.0%"
  String get formattedChange =>
      '${isUp ? '+' : ''}${changePercent.toStringAsFixed(1)}%';

  /// e.g. "+1.0% (7D)"
  String get formattedChangeWithRange =>
      '$formattedChange (${range.label})';

  /// e.g. "1 USD = ₦1,500.00"
  String get formattedRate =>
      '1 ${pair.baseCode} = $quoteSymbol${_fmt(rate)}';

  /// e.g. "₦1,500.00"
  String get formattedValue => '$quoteSymbol${_fmt(rate)}';

  double get high => points.isEmpty
      ? rate
      : points.map((p) => p.value).reduce((a, b) => a > b ? a : b);

  double get low => points.isEmpty
      ? rate
      : points.map((p) => p.value).reduce((a, b) => a < b ? a : b);

  String get formattedHigh => '$quoteSymbol${_fmt(high)}';
  String get formattedLow => '$quoteSymbol${_fmt(low)}';

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
