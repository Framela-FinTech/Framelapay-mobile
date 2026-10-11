/// Which funding method a fiat transfer uses.
/// Shared by the Bank, Card and Wallet flows so the common screens
/// (transfer details, recipient, FX quote, review, completed, details)
/// can be parameterized by a single enum.
enum TransferMethod { bank, card, wallet }

extension TransferMethodLabel on TransferMethod {
  /// Human label used on the Transaction Details "Payment method" row.
  String get label {
    switch (this) {
      case TransferMethod.bank:
        return 'Bank Transfer';
      case TransferMethod.card:
        return 'Card';
      case TransferMethod.wallet:
        return 'Wallet';
    }
  }
}
