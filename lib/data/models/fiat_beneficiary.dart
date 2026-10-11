/// A person/account money is being sent to in the fiat flows.
/// Mirrors the stablecoin `TransferRecipient`, but for bank accounts.
class FiatBeneficiary {
  final String fullName;
  final String bankName;
  final String accountNumber;
  final String country;
  final String? relationship;
  final String? purpose;

  const FiatBeneficiary({
    required this.fullName,
    required this.bankName,
    required this.accountNumber,
    required this.country,
    this.relationship,
    this.purpose,
  });

  /// Masked account number for display, e.g. "*****1234".
  String get maskedAccount {
    if (accountNumber.length <= 4) return accountNumber;
    return '*****${accountNumber.substring(accountNumber.length - 4)}';
  }

  /// Short masked form used in list subtitles, e.g. "Nigeria ***1234".
  String get listSubtitle {
    final tail = accountNumber.length <= 4
        ? accountNumber
        : accountNumber.substring(accountNumber.length - 4);
    return '$country ***$tail';
  }

  FiatBeneficiary copyWith({
    String? fullName,
    String? bankName,
    String? accountNumber,
    String? country,
    String? relationship,
    String? purpose,
  }) {
    return FiatBeneficiary(
      fullName: fullName ?? this.fullName,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      country: country ?? this.country,
      relationship: relationship ?? this.relationship,
      purpose: purpose ?? this.purpose,
    );
  }
}
