import '../models/wallet_balance.dart';

abstract class WalletRepository {
  Future<WalletBalance> getBalance();
}

class MockWalletRepository implements WalletRepository {
  @override
  Future<WalletBalance> getBalance() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const WalletBalance(
      currencyCode: 'NGN',
      fiatAmount: 1245600.00,
      usdcEquivalent: 2500.00,
    );
  }
}