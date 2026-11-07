/// The FramelaPay-side account a customer pays into for a bank transfer.
///
/// These are the same for every transfer today, which is why they are not
/// fields on `FiatTransfer`. A backend will later return a per-transaction
/// virtual account from here without any screen changing.
class CollectionAccount {
  final String accountName;
  final String bankName;
  final String accountNumber;

  const CollectionAccount({
    required this.accountName,
    required this.bankName,
    required this.accountNumber,
  });
}

abstract class CollectionAccountRepository {
  Future<CollectionAccount> getCollectionAccount();
}

class MockCollectionAccountRepository implements CollectionAccountRepository {
  @override
  Future<CollectionAccount> getCollectionAccount() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const CollectionAccount(
      accountName: 'FramelaPay Collections',
      bankName: 'Demo Settlement Bank',
      accountNumber: '0001234567',
    );
  }
}
