// The rate chart is hand-painted, so its edge cases are worth pinning:
// a flat series (which would divide by zero when scaling), a series too
// short to draw, and the range tabs actually reloading the series.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:framela/data/models/exchange_rate.dart';
import 'package:framela/data/repositories/exchange_rate_repository.dart';
import 'package:framela/features/exchange/widgets/rate_chart.dart';

void main() {
  Future<void> pumpChart(WidgetTester tester, List<RatePoint> points) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SizedBox(width: 320, child: RateChart(points: points)),
      ),
    ));
    await tester.pump();
  }

  testWidgets('paints a normal series', (tester) async {
    await pumpChart(tester, const [
      RatePoint('', 1460),
      RatePoint('4 Oct', 1472),
      RatePoint('', 1488),
      RatePoint('6 Oct', 1500),
    ]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('survives a flat series', (tester) async {
    await pumpChart(tester, const [
      RatePoint('', 1500),
      RatePoint('', 1500),
      RatePoint('', 1500),
    ]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('falls back when there is nothing to draw', (tester) async {
    await pumpChart(tester, const [RatePoint('', 1500)]);
    expect(find.text('No rate history'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('every range produces a usable series ending on the quoted rate', () async {
    final repo = MockExchangeRateRepository();
    const pair = CurrencyPair(
      baseCode: 'USD',
      baseName: 'US Dollar',
      baseCountry: 'US',
      quoteCode: 'NGN',
      quoteName: 'Nigerian Naira',
      quoteCountry: 'NG',
    );
    for (final range in RateRange.values) {
      final rate = await repo.getRateDetail(pair, range);
      expect(rate.points.length, greaterThan(2), reason: range.label);
      // The series must land exactly on the headline rate, or the chart and
      // the number above it disagree.
      expect(rate.points.last.value, closeTo(rate.rate, 0.001),
          reason: range.label);
      expect(rate.high, greaterThanOrEqualTo(rate.low), reason: range.label);
    }
  });
}
