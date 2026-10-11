import '../models/bank.dart';

abstract class BankRepository {
  Future<List<Bank>> getBanks();
}

class MockBankRepository implements BankRepository {
  @override
  Future<List<Bank>> getBanks() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return const [
      Bank(name: 'Access Bank'),
      Bank(name: 'GTBank'),
      Bank(name: 'Zenith Bank'),
      Bank(name: 'First Bank'),
      Bank(name: 'United Bank for Africa'),
      Bank(name: 'Kuda Bank'),
    ];
  }
}
