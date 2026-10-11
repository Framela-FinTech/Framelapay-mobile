/// Bank funding details shown on the "Fund <currency> Wallet" screen.
class BankAccountDetails {
  final String accountName;
  final String iban;
  final String bic; // BIC / SWIFT
  final String reference;
  final String currencyCode;

  const BankAccountDetails({
    required this.accountName,
    required this.iban,
    required this.bic,
    required this.reference,
    required this.currencyCode,
  });
}
