import 'exchange_rate.dart';

/// Which direction triggers the alert.
enum AlertCondition { atOrAbove, atOrBelow }

extension AlertConditionLabel on AlertCondition {
  /// As the picker lists it.
  String get label => switch (this) {
        AlertCondition.atOrAbove => 'Rate is at or above',
        AlertCondition.atOrBelow => 'Rate is at or below',
      };

  /// As the alert list shows it, before the target rate.
  String get shortLabel => switch (this) {
        AlertCondition.atOrAbove => 'At or above',
        AlertCondition.atOrBelow => 'At or below',
      };
}

/// How the alert reaches the user.
enum AlertDelivery { push, email, both }

extension AlertDeliveryLabel on AlertDelivery {
  String get label => switch (this) {
        AlertDelivery.push => 'Push notification',
        AlertDelivery.email => 'Email',
        AlertDelivery.both => 'Push notification + Email',
      };
}

/// A saved rate alert.
class RateAlert {
  final String id;
  final CurrencyPair pair;
  final AlertCondition condition;
  final double targetRate;
  final String quoteSymbol;
  final AlertDelivery delivery;
  final bool repeat;
  final bool active;

  const RateAlert({
    required this.id,
    required this.pair,
    required this.condition,
    required this.targetRate,
    this.quoteSymbol = '₦',
    this.delivery = AlertDelivery.push,
    this.repeat = true,
    this.active = true,
  });

  /// e.g. "₦1,520.00"
  String get formattedTarget => '$quoteSymbol${_fmt(targetRate)}';

  /// e.g. "At or above ₦1,520.00"
  String get summary => '${condition.shortLabel} $formattedTarget';

  String get statusLabel => active ? 'Active' : 'Paused';

  RateAlert copyWith({
    CurrencyPair? pair,
    AlertCondition? condition,
    double? targetRate,
    AlertDelivery? delivery,
    bool? repeat,
    bool? active,
  }) {
    return RateAlert(
      id: id,
      pair: pair ?? this.pair,
      condition: condition ?? this.condition,
      targetRate: targetRate ?? this.targetRate,
      quoteSymbol: quoteSymbol,
      delivery: delivery ?? this.delivery,
      repeat: repeat ?? this.repeat,
      active: active ?? this.active,
    );
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
