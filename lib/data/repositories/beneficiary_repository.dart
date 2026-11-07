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
      ),
      FiatBeneficiary(
        fullName: 'Amara Okafor',
        bankName: 'Access Bank',
        accountNumber: '0098764201',
        country: 'Ghana',
      ),
      FiatBeneficiary(
        fullName: 'Michael Ade',
        bankName: 'GTBank',
        accountNumber: '0054324201',
        country: 'Ukraine',
      ),
      FiatBeneficiary(
        fullName: 'Robert Fox',
        bankName: 'FramelaPay',
        accountNumber: 'FRM-104829',
        country: 'FramelaPay',
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
