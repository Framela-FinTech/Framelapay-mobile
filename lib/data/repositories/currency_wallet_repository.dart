import '../models/currency_wallet.dart';
import '../models/wallet_activity.dart';
import '../models/bank_account_details.dart';

/// Aggregate figures for the Wallet-tab balance card.
class WalletTotals {
  final String primaryFormatted; // e.g. "$12,550.00"
  final String secondaryFormatted; // e.g. "= ₦15,000,150.60"
  final bool kycVerified;

  const WalletTotals({
    required this.primaryFormatted,
    required this.secondaryFormatted,
    required this.kycVerified,
  });
}

/// Result of a wallet-to-wallet conversion quote.
class ConvertQuote {
  final double rate; // "to" units per 1 "from" unit
  final double fee; // in "to" currency
  final double receiveAmount; // amount * rate (minus nothing; fee shown separately)
  final String rateText; // e.g. "1 GBP = 1.2650 USD"

  const ConvertQuote({
    required this.rate,
    required this.fee,
    required this.receiveAmount,
    required this.rateText,
  });
}

abstract class CurrencyWalletRepository {
  Future<List<CurrencyWallet>> getWallets();

  Future<ConvertQuote> getConvertQuote({
    required String fromCode,
    required String toCode,
    required double amount,
  });

  Future<WalletTotals> getTotals();

  Future<List<WalletActivity>> getRecentActivity();

  Future<BankAccountDetails> getBankFundingDetails(String currencyCode);
}

class MockCurrencyWalletRepository implements CurrencyWalletRepository {
  // Rates expressed as "units per 1 USD".
  static const Map<String, double> _usdRates = {
    'NGN': 1620.50,
    'USD': 1.0,
    'GBP': 0.79,
    'EUR': 0.92,
    'UAH': 41.30,
  };

  @override
  Future<List<CurrencyWallet>> getWallets() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      CurrencyWallet(
          code: 'NGN', name: 'Nigerian Naira', symbol: '₦', balance: 150000),
      CurrencyWallet(
          code: 'USD', name: 'US Dollar', symbol: r'$', balance: 350000),
      CurrencyWallet(
          code: 'EUR', name: 'Euro', symbol: '€', balance: 2500),
      CurrencyWallet(
          code: 'GBP', name: 'British Pound', symbol: '£', balance: 1000),
      CurrencyWallet(
          code: 'UAH',
          name: 'Ukrainian Hryvnia',
          symbol: '₴',
          balance: 200000),
    ];
  }

  @override
  Future<WalletTotals> getTotals() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const WalletTotals(
      primaryFormatted: r'$12,550.00',
      secondaryFormatted: '= ₦15,000,150.60',
      kycVerified: true,
    );
  }

  @override
  Future<List<WalletActivity>> getRecentActivity() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      WalletActivity(
        incoming: true,
        title: 'Money received',
        time: 'Aug 6th, 21:29 AM',
        amount: r'USD · $250',
        status: WalletActivityStatus.completed,
      ),
      WalletActivity(
        incoming: true,
        title: 'Money received',
        time: 'Aug 6th, 21:29 AM',
        amount: r'USD · $250',
        status: WalletActivityStatus.completed,
      ),
      WalletActivity(
        incoming: false,
        title: 'Money sent',
        time: 'Aug 6th, 21:29 AM',
        amount: r'USD · $250',
        status: WalletActivityStatus.failed,
      ),
    ];
  }

  @override
  Future<BankAccountDetails> getBankFundingDetails(String currencyCode) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return BankAccountDetails(
      accountName: 'Cynthia Nkechi',
      iban: 'DE89 3704 0044 0532 0130 00',
      bic: 'COBADEFXXX',
      reference: 'FRM-123456',
      currencyCode: currencyCode,
    );
  }

  @override
  Future<ConvertQuote> getConvertQuote({
    required String fromCode,
    required String toCode,
    required double amount,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final fromPerUsd = _usdRates[fromCode] ?? 1.0;
    final toPerUsd = _usdRates[toCode] ?? 1.0;
    final rate = toPerUsd / fromPerUsd;
    const fee = 1.00;
    return ConvertQuote(
      rate: rate,
      fee: fee,
      receiveAmount: amount * rate,
      rateText: '1 $fromCode = ${rate.toStringAsFixed(4)} $toCode',
    );
  }
}
