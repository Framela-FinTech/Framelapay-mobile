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
    return const [
      FiatBeneficiary(
        fullName: 'Robert Fox',
        bankName: 'Access Bank',
        accountNumber: '0012123456',
        country: 'Ghana',
      ),
      FiatBeneficiary(
        fullName: 'Robert Fox',
        bankName: 'GTBank',
        accountNumber: '0022123456',
        country: 'Ghana',
      ),
      FiatBeneficiary(
        fullName: 'Robert Fox',
        bankName: 'Zenith Bank',
        accountNumber: '0032123456',
        country: 'Ghana',
      ),
      FiatBeneficiary(
        fullName: 'Robert Fox',
        bankName: 'First Bank',
        accountNumber: '0042123456',
        country: 'Ghana',
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
      accountNumber: accountNumber.isNotEmpty ? accountNumber : '0071231234',
      country: 'Nigeria',
      relationship: relationship,
      purpose: purpose,
    );
  }
}
