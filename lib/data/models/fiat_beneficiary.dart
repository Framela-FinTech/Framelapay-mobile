/// A person/account money is being sent to in the fiat flows.
/// Mirrors the stablecoin `TransferRecipient`, but for bank accounts.
class FiatBeneficiary {
  final String fullName;
  final String bankName;
  final String accountNumber;
  final String country;
  final String? relationship;
  final String? purpose;

  /// Optional friendly label shown instead of [fullName] in saved lists.
  final String? nickname;

  /// Optional currency code (e.g. "EUR") for the beneficiary's account —
  /// shown in the saved-beneficiary list/detail subtitles.
  final String? currency;

  const FiatBeneficiary({
    required this.fullName,
    required this.bankName,
    required this.accountNumber,
    required this.country,
    this.relationship,
    this.purpose,
    this.nickname,
    this.currency,
  });

  /// Name to display: the [nickname] when set, otherwise the [fullName].
  String get displayName =>
      (nickname != null && nickname!.trim().isNotEmpty) ? nickname! : fullName;

  /// Last four digits of the account number, e.g. "1234".
  String get accountTail => accountNumber.length <= 4
      ? accountNumber
      : accountNumber.substring(accountNumber.length - 4);

  /// Masked account number for display, e.g. "*****1234".
  String get maskedAccount {
    if (accountNumber.length <= 4) return accountNumber;
    return '*****$accountTail';
  }

  /// Short masked form used in list subtitles, e.g. "Nigeria ***1234".
  String get listSubtitle {
    return '$country ***$accountTail';
  }

  FiatBeneficiary copyWith({
    String? fullName,
    String? bankName,
    String? accountNumber,
    String? country,
    String? relationship,
    String? purpose,
    String? nickname,
    String? currency,
  }) {
    return FiatBeneficiary(
      fullName: fullName ?? this.fullName,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      country: country ?? this.country,
      relationship: relationship ?? this.relationship,
      purpose: purpose ?? this.purpose,
      nickname: nickname ?? this.nickname,
      currency: currency ?? this.currency,
    );
  }
}

/// Mock saved beneficiaries shown in the Profile → Beneficiaries screens.
/// Separate from the transfer flow's MockBeneficiaryRepository so the names
/// match the design sheet.
const List<FiatBeneficiary> sampleBeneficiaries = [
  FiatBeneficiary(
    fullName: 'John Doe',
    bankName: 'Example Bank',
    accountNumber: '00001234',
    country: 'Germany',
    currency: 'EUR',
  ),
  FiatBeneficiary(
    fullName: 'Michael Ade',
    bankName: 'Partner Bank',
    accountNumber: '00009832',
    country: 'Nigeria',
    currency: 'NGN',
  ),
  FiatBeneficiary(
    fullName: 'Cynthia Business Ltd',
    bankName: 'First Union',
    accountNumber: '00004408',
    country: 'United States',
    currency: 'USD',
  ),
];
