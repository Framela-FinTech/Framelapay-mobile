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
  final double fee; // in the "from" currency, already deducted
  final double receiveAmount; // (amount - fee) * rate
  final String rateText; // e.g. "1 GBP = 1.2650 USD"

  /// The board labels the fee row "Fee (included · 1%)".
  static const double feeRate = 0.01;

  const ConvertQuote({
    required this.rate,
    required this.fee,
    required this.receiveAmount,
    required this.rateText,
  });
}

abstract class CurrencyWalletRepository {
  Future<List<CurrencyWallet>> getWallets();

  /// Currencies the user is eligible to open a wallet in but has not yet.
  Future<List<CurrencyWallet>> getAvailableCurrencies();

  /// Opens a wallet in [code] so it appears in [getWallets].
  Future<void> openWallet(String code);

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
    // Kept in step with MockFxRepository: the two disagreeing meant the
    // convert sheet quoted a different NGN rate from Destination and FX Quote.
    'NGN': 1567.50,
    'USD': 1.0,
    'GBP': 0.79,
    'EUR': 0.92,
    'UAH': 41.30,
  };

  /// Wallets held from the start.
  static const List<CurrencyWallet> _initialWallets = [
    CurrencyWallet(
        code: 'NGN', name: 'Nigerian Naira', symbol: '₦', balance: 500000),
    CurrencyWallet(
        code: 'USD', name: 'US Dollar', symbol: r'$', balance: 350000),
    CurrencyWallet(code: 'EUR', name: 'Euro', symbol: '€', balance: 2500),
    CurrencyWallet(
        code: 'GBP', name: 'British Pound', symbol: '£', balance: 1000),
    CurrencyWallet(
        code: 'UAH', name: 'Ukrainian Hryvnia', symbol: '₴', balance: 200000),
  ];

  /// Currencies a wallet can be opened in but that are not held initially.
  static const List<CurrencyWallet> _openableWallets = [
    CurrencyWallet(code: 'GHS', name: 'Ghanaian Cedi', symbol: '₵', balance: 0),
    CurrencyWallet(code: 'KES', name: 'Kenyan Shilling', symbol: 'KSh', balance: 0),
    CurrencyWallet(code: 'ZAR', name: 'South African Rand', symbol: 'R', balance: 0),
    CurrencyWallet(code: 'CAD', name: 'Canadian Dollar', symbol: r'$', balance: 0),
    CurrencyWallet(code: 'AED', name: 'UAE Dirham', symbol: 'د.إ', balance: 0),
  ];

  /// Codes opened during this run. Static so the choice survives the repo
  /// being reinstantiated per screen, which is how the mocks are used.
  static final Set<String> _opened = {};

  @override
  Future<List<CurrencyWallet>> getWallets() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      ..._initialWallets,
      ..._openableWallets.where((w) => _opened.contains(w.code)),
    ];
  }

  @override
  Future<List<CurrencyWallet>> getAvailableCurrencies() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _openableWallets.where((w) => !_opened.contains(w.code)).toList();
  }

  @override
  Future<void> openWallet(String code) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _opened.add(code);
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
    // 1% of the amount, taken in the source currency before conversion.
    final fee = amount * ConvertQuote.feeRate;
    return ConvertQuote(
      rate: rate,
      fee: fee,
      receiveAmount: (amount - fee) * rate,
      rateText: '1 $fromCode = ${rate.toStringAsFixed(4)} $toCode',
    );
  }
}
