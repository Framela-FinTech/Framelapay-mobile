/// A country option in the "Destination / Receiving Country" dropdowns,
/// paired with its currency so the FX summary can be derived from a selection.
class TransferCountry {
  final String name;

  /// ISO 3166-1 alpha-2, for the `country_flags` package — the same convention
  /// [CurrencyWallet.countryCode] already uses.
  final String countryCode;

  final String currencyCode; // e.g. USD, NGN
  final String currencySymbol; // e.g. $, ₦

  const TransferCountry({
    required this.name,
    required this.countryCode,
    required this.currencyCode,
    required this.currencySymbol,
  });
}
