import '../models/bank.dart';

abstract class BankRepository {
  Future<List<Bank>> getBanks();
  Future<List<Bank>> getBanksForCountry(String countryCode);
}

/// Commercial and digital banks, organized by country.
/// Names here are the lookup keys for `kBankLogos` in
/// `lib/core/widgets/bank_avatar.dart`; a bank with no logo file renders the
/// generic glyph, so this list and that map do not have to stay in step.
class MockBankRepository implements BankRepository {
  static const Map<String, List<String>> _banksByCountry = {
    'NG': [
      'Access Bank',
      'FCMB',
      'Fidelity Bank',
      'First Bank',
      'Globus Bank',
      'GTBank',
      'Heritage Bank',
      'Jaiz Bank',
      'Keystone Bank',
      'Kuda Bank',
      'Moniepoint',
      'OPay',
      'Parallex Bank',
      'Polaris Bank',
      'PremiumTrust Bank',
      'Providus Bank',
      'Stanbic IBTC',
      'Sterling Bank',
      'SunTrust Bank',
      'Titan Trust Bank',
      'Union Bank',
      'United Bank for Africa',
      'Unity Bank',
      'Wema Bank',
      'Zenith Bank',
    ],
    'GB': [
      'Barclays',
      'HSBC UK',
      'Lloyds Bank',
      'NatWest',
      'Monzo',
      'Revolut',
      'Standard Chartered',
      'Santander UK',
    ],
    'US': [
      'Chase Bank',
      'Bank of America',
      'Wells Fargo',
      'Citibank',
      'Capital One',
      'Goldman Sachs',
      'PNC Bank',
    ],
    'GH': [
      'Access Bank Ghana',
      'Ecobank Ghana',
      'GCB Bank',
      'Stanbic Bank Ghana',
      'Fidelity Bank Ghana',
      'Zenith Bank Ghana',
    ],
    'KE': [
      'KCB Bank',
      'Equity Bank',
      'Co-operative Bank of Kenya',
      'NCBA Bank',
      'Standard Chartered Kenya',
      'Absa Bank Kenya',
    ],
    'UA': [
      'Oschadbank',
      'PrivatBank',
      'Monobank',
      'Ukreximbank',
      'Raiffeisen Bank',
    ],
    'ZA': [
      'Standard Bank',
      'First National Bank',
      'Absa Bank',
      'Nedbank',
      'Capitec Bank',
    ],
    'CA': [
      'RBC Royal Bank',
      'TD Canada Trust',
      'Scotiabank',
      'BMO Bank of Montreal',
      'CIBC',
    ],
    'DE': [
      'Deutsche Bank',
      'Commerzbank',
      'N26',
      'DZ Bank',
      'KfW Bank',
    ],
    'FR': [
      'BNP Paribas',
      'Crédit Agricole',
      'Société Générale',
      'BPCE',
    ],
    'AE': [
      'Emirates NBD',
      'First Abu Dhabi Bank',
      'Abu Dhabi Commercial Bank',
      'Dubai Islamic Bank',
    ],
  };

  @override
  Future<List<Bank>> getBanks() async {
    return getBanksForCountry('NG');
  }

  @override
  Future<List<Bank>> getBanksForCountry(String countryCode) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final list = _banksByCountry[countryCode.toUpperCase()] ??
        [
          'Partner Bank',
          'Standard Chartered',
          'HSBC',
          'Citibank',
          'International Commercial Bank',
        ];
    return list.map((name) => Bank(name: name)).toList();
  }
}
