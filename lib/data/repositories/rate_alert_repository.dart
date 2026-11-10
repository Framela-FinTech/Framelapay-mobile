import '../models/exchange_rate.dart';
import '../models/rate_alert.dart';

abstract class RateAlertRepository {
  Future<List<RateAlert>> getAlerts();
  Future<RateAlert> saveAlert(RateAlert alert);
  Future<void> deleteAlert(String id);
}

class MockRateAlertRepository implements RateAlertRepository {
  static CurrencyPair _pair(
      String code, String name, String country) =>
      CurrencyPair(
        baseCode: code,
        baseName: name,
        baseCountry: country,
        quoteCode: 'NGN',
        quoteName: 'Nigerian Naira',
        quoteCountry: 'NG',
      );

  /// The board's three alerts. Held statically so edits survive the repo
  /// being reinstantiated per screen, which is how these mocks are used.
  static final List<RateAlert> _alerts = [
    RateAlert(
      id: 'a1',
      pair: _pair('USD', 'US Dollar', 'US'),
      condition: AlertCondition.atOrAbove,
      targetRate: 1520.00,
    ),
    RateAlert(
      id: 'a2',
      pair: _pair('EUR', 'Euro', 'EU'),
      condition: AlertCondition.atOrAbove,
      targetRate: 1650.00,
    ),
    RateAlert(
      id: 'a3',
      pair: _pair('GBP', 'British Pound', 'GB'),
      condition: AlertCondition.atOrBelow,
      targetRate: 1845.00,
      active: false,
    ),
  ];

  static int _nextId = 4;

  @override
  Future<List<RateAlert>> getAlerts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_alerts);
  }

  @override
  Future<RateAlert> saveAlert(RateAlert alert) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _alerts.indexWhere((a) => a.id == alert.id);
    if (index == -1) {
      final created = RateAlert(
        id: 'a${_nextId++}',
        pair: alert.pair,
        condition: alert.condition,
        targetRate: alert.targetRate,
        quoteSymbol: alert.quoteSymbol,
        delivery: alert.delivery,
        repeat: alert.repeat,
        active: alert.active,
      );
      _alerts.add(created);
      return created;
    }
    _alerts[index] = alert;
    return alert;
  }

  @override
  Future<void> deleteAlert(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _alerts.removeWhere((a) => a.id == id);
  }
}
