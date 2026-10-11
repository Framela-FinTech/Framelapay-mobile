/// A single FX quote for a send/receive currency pair.
class FxQuote {
  final double rate; // receive units per 1 send unit
  final double fee; // in send currency
  final double receiveAmount; // sendAmount * rate

  const FxQuote({
    required this.rate,
    required this.fee,
    required this.receiveAmount,
  });
}

abstract class FxRepository {
  Future<FxQuote> getQuote({
    required String sendCurrency,
    required String receiveCurrency,
    required double sendAmount,
  });
}

class MockFxRepository implements FxRepository {
  // Mock rates expressed as "receive units per 1 USD".
  // Kept intentionally simple; a real backend returns live rates.
  static const Map<String, double> _usdRates = {
    'USD': 1.0,
    'NGN': 1620.50,
    'GHS': 15.20,
    'GBP': 0.79,
    'UAH': 41.30,
  };

  @override
  Future<FxQuote> getQuote({
    required String sendCurrency,
    required String receiveCurrency,
    required double sendAmount,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final sendPerUsd = _usdRates[sendCurrency] ?? 1.0;
    final receivePerUsd = _usdRates[receiveCurrency] ?? 1.0;
    final rate = receivePerUsd / sendPerUsd;
    const fee = 2.50;
    return FxQuote(
      rate: rate,
      fee: fee,
      receiveAmount: sendAmount * rate,
    );
  }
}
