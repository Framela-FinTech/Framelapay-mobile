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

  /// True when this is an in-network FramelaPay tag rather than a bank
  /// account, e.g. "FRM-104829".
  bool get isFramelaTag => accountNumber.toUpperCase().startsWith('FRM');

  /// Short form used in list subtitles, e.g. "Nigeria · •••• 6789". A
  /// FramelaPay tag is shown whole, since it is an identifier, not a secret.
  String get listSubtitle =>
      isFramelaTag ? '$country · $accountNumber' : '$country · •••• $accountTail';

  /// Bank + masked account on one line, e.g. "GTBank · Account ending 6789".
  String get bankAccountLine => '$bankName · Account ending $accountTail';

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
/// Covers beneficiaries across multiple countries, banks, and currencies.
const List<FiatBeneficiary> sampleBeneficiaries = [
  FiatBeneficiary(
    fullName: 'John Doe',
    bankName: 'Zenith Bank',
    accountNumber: '70550345468',
    country: 'Nigeria',
    currency: 'NGN',
  ),
  FiatBeneficiary(
    fullName: 'Amara Okafor',
    bankName: 'Access Bank',
    accountNumber: '1029384201',
    country: 'Ghana',
    currency: 'GHS',
  ),
  FiatBeneficiary(
    fullName: 'Michael Ade',
    bankName: 'Oschadbank',
    accountNumber: '9988774201',
    country: 'Ukraine',
    currency: 'UAH',
  ),
  FiatBeneficiary(
    fullName: 'Robert Fox',
    bankName: 'FramelaPay',
    accountNumber: 'FRM-104829',
    country: 'FramelaPay',
    currency: 'USD',
  ),
  FiatBeneficiary(
    fullName: 'Sarah Jenkins',
    bankName: 'Barclays',
    accountNumber: '2045618821',
    country: 'United Kingdom',
    currency: 'GBP',
  ),
  FiatBeneficiary(
    fullName: 'David Miller',
    bankName: 'Chase Bank',
    accountNumber: '9843219012',
    country: 'United States',
    currency: 'USD',
  ),
  FiatBeneficiary(
    fullName: 'Emma Schneider',
    bankName: 'Deutsche Bank',
    accountNumber: '5543123341',
    country: 'Germany',
    currency: 'EUR',
  ),
  FiatBeneficiary(
    fullName: 'Kwame Mensah',
    bankName: 'KCB Bank',
    accountNumber: '4432115520',
    country: 'Kenya',
    currency: 'KES',
  ),
  FiatBeneficiary(
    fullName: 'Liam Wilson',
    bankName: 'RBC Royal Bank',
    accountNumber: '8876541144',
    country: 'Canada',
    currency: 'CAD',
  ),
];
