import '../models/bank.dart';

abstract class BankRepository {
  Future<List<Bank>> getBanks();
}

/// Nigerian commercial and digital banks, alphabetical.
///
/// Names here are the lookup keys for `kBankLogos` in
/// `lib/core/widgets/bank_avatar.dart`; a bank with no logo file renders the
/// generic glyph, so this list and that map do not have to stay in step.
class MockBankRepository implements BankRepository {
  @override
  Future<List<Bank>> getBanks() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return const [
      Bank(name: 'Access Bank'),
      Bank(name: 'FCMB'),
      Bank(name: 'Fidelity Bank'),
      Bank(name: 'First Bank'),
      Bank(name: 'Globus Bank'),
      Bank(name: 'GTBank'),
      Bank(name: 'Heritage Bank'),
      Bank(name: 'Jaiz Bank'),
      Bank(name: 'Keystone Bank'),
      Bank(name: 'Kuda Bank'),
      Bank(name: 'Moniepoint'),
      Bank(name: 'OPay'),
      Bank(name: 'Parallex Bank'),
      Bank(name: 'Polaris Bank'),
      Bank(name: 'PremiumTrust Bank'),
      Bank(name: 'Providus Bank'),
      Bank(name: 'Stanbic IBTC'),
      Bank(name: 'Sterling Bank'),
      Bank(name: 'SunTrust Bank'),
      Bank(name: 'Titan Trust Bank'),
      Bank(name: 'Union Bank'),
      Bank(name: 'United Bank for Africa'),
      Bank(name: 'Unity Bank'),
      Bank(name: 'Wema Bank'),
      Bank(name: 'Zenith Bank'),
    ];
  }
}
