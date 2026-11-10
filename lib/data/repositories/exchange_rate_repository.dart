import 'dart:math';

import '../models/exchange_rate.dart';

abstract class ExchangeRateRepository {
  /// Every pair shown in the "All rates" list.
  Future<List<ExchangeRate>> getRates();

  /// One pair with the series behind it for [range].
  Future<ExchangeRate> getRateDetail(CurrencyPair pair, RateRange range);

  /// Currencies that can be picked on either side of a pair.
  Future<List<CurrencyOption>> getCurrencies();
}

/// A currency offered in the pair picker.
class CurrencyOption {
  final String code;
  final String name;
  final String country; // ISO-2
  const CurrencyOption(this.code, this.name, this.country);

  String get label => '$code - $name';
}

class MockExchangeRateRepository implements ExchangeRateRepository {
  static const _currencies = [
    CurrencyOption('USD', 'US Dollar', 'US'),
    CurrencyOption('EUR', 'Euro', 'EU'),
    CurrencyOption('GBP', 'British Pound', 'GB'),
    CurrencyOption('CAD', 'Canadian Dollar', 'CA'),
    CurrencyOption('AED', 'UAE Dirham', 'AE'),
    CurrencyOption('NGN', 'Nigerian Naira', 'NG'),
  ];

  /// The board's rates against NGN, with their 7-day movement.
  static const _board = <String, (double rate, double change)>{
    'USD': (1500.00, 1.0),
    'EUR': (1620.50, 0.8),
    'GBP': (1870.20, -0.3),
    'CAD': (1095.40, 0.5),
    'AED': (408.20, 0.2),
  };

  static const _quoteSymbol = '₦';

  CurrencyPair _pairFor(String base) {
    final b = _currencies.firstWhere((c) => c.code == base);
    final q = _currencies.firstWhere((c) => c.code == 'NGN');
    return CurrencyPair(
      baseCode: b.code,
      baseName: b.name,
      baseCountry: b.country,
      quoteCode: q.code,
      quoteName: q.name,
      quoteCountry: q.country,
    );
  }

  @override
  Future<List<CurrencyOption>> getCurrencies() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _currencies;
  }

  @override
  Future<List<ExchangeRate>> getRates() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      for (final entry in _board.entries)
        ExchangeRate(
          pair: _pairFor(entry.key),
          rate: entry.value.$1,
          quoteSymbol: _quoteSymbol,
          changePercent: entry.value.$2,
        ),
    ];
  }

  @override
  Future<ExchangeRate> getRateDetail(
      CurrencyPair pair, RateRange range) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final board = _board[pair.baseCode] ?? (1500.00, 1.0);
    final rate = board.$1;
    final change = board.$2;
    return ExchangeRate(
      pair: pair,
      rate: rate,
      quoteSymbol: _quoteSymbol,
      changePercent: change,
      range: range,
      points: _series(rate, change, range),
    );
  }

  /// A deterministic series that ends at [rate] and starts [change]% below it,
  /// with enough wobble to read as a real chart. Seeded by the rate so the
  /// same pair always draws the same line.
  static List<RatePoint> _series(
      double endRate, double changePercent, RateRange range) {
    final count = switch (range) {
      RateRange.d1 => 12,
      RateRange.d7 => 14,
      RateRange.m1 => 20,
      RateRange.m3 => 24,
    };
    final startRate = endRate / (1 + changePercent / 100);
    final random = Random(endRate.round());
    final amplitude = (endRate - startRate).abs().clamp(endRate * 0.002, endRate);

    return [
      for (var i = 0; i < count; i++)
        RatePoint(
          _labelFor(range, i, count),
          // Linear walk from start to end, plus a small deterministic wobble
          // that fades out so the line lands exactly on `endRate`.
          startRate +
              (endRate - startRate) * (i / (count - 1)) +
              (i == count - 1
                  ? 0
                  : (random.nextDouble() - 0.5) *
                      amplitude *
                      0.6 *
                      (1 - i / count)),
        ),
    ];
  }

  /// Only a few points carry an x-axis caption; the rest are blank.
  static String _labelFor(RateRange range, int i, int count) {
    final showEvery = (count / 4).round();
    if (i % showEvery != 0 || i == 0) return '';
    return switch (range) {
      RateRange.d1 => '${(i * 24 / count).round()}:00',
      RateRange.d7 => '${3 + (i * 7 / count).round()} Oct',
      RateRange.m1 => 'Wk ${(i * 4 / count).round()}',
      RateRange.m3 => 'Mo ${(i * 3 / count).round()}',
    };
  }
}
