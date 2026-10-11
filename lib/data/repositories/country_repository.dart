import '../models/transfer_country.dart';

abstract class CountryRepository {
  Future<List<TransferCountry>> getCountries();
}

class MockCountryRepository implements CountryRepository {
  @override
  Future<List<TransferCountry>> getCountries() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return const [
      TransferCountry(
          name: 'United States', currencyCode: 'USD', currencySymbol: r'$'),
      TransferCountry(
          name: 'Nigeria', currencyCode: 'NGN', currencySymbol: '₦'),
      TransferCountry(
          name: 'Ghana', currencyCode: 'GHS', currencySymbol: '₵'),
      TransferCountry(
          name: 'United Kingdom', currencyCode: 'GBP', currencySymbol: '£'),
      TransferCountry(
          name: 'Ukraine', currencyCode: 'UAH', currencySymbol: '₴'),
    ];
  }
}
