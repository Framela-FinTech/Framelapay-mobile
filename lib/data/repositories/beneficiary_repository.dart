import '../models/fiat_beneficiary.dart';

abstract class BeneficiaryRepository {
  /// Existing saved beneficiaries for the "Select recipient" list.
  Future<List<FiatBeneficiary>> getBeneficiaries();

  /// Verifies an account and returns the resolved beneficiary.
  /// Backend will replace this with a name-enquiry call.
  Future<FiatBeneficiary> verifyAccount({
    required String bankName,
    required String accountNumber,
    String? fullName,
    String? relationship,
    String? purpose,
  });
}

class MockBeneficiaryRepository implements BeneficiaryRepository {
  @override
  Future<List<FiatBeneficiary>> getBeneficiaries() async {
    await Future.delayed(const Duration(milliseconds: 300));
    // The saved-recipient set drawn on the Home Transfer board.
    return const [
      FiatBeneficiary(
        fullName: 'Ken Okafor',
        bankName: 'Zenith Bank',
        accountNumber: '0071236789',
        country: 'Nigeria',
        currency: 'NGN',
      ),
      FiatBeneficiary(
        fullName: 'Amara Okafor',
        bankName: 'Access Bank',
        accountNumber: '0098764201',
        country: 'Ghana',
        currency: 'GHS',
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
        fullName: 'Michael Ade',
        bankName: 'Oschadbank',
        accountNumber: '0054324201',
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
    ];
  }

  @override
  Future<FiatBeneficiary> verifyAccount({
    required String bankName,
    required String accountNumber,
    String? fullName,
    String? relationship,
    String? purpose,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Normalized to the coherent Nigeria payout scenario (see report).
    return FiatBeneficiary(
      fullName: fullName?.isNotEmpty == true ? fullName! : 'Ken Okafor',
      bankName: bankName.isNotEmpty ? bankName : 'GTBank',
      accountNumber: accountNumber.isNotEmpty ? accountNumber : '0071236789',
      country: 'Nigeria',
      relationship: relationship,
      purpose: purpose,
    );
  }
}
