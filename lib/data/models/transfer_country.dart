/// A country option in the "Destination / Receiving Country" dropdowns,
/// paired with its currency so the FX summary can be derived from a selection.
class TransferCountry {
  final String name;
  final String currencyCode; // e.g. USD, NGN
  final String currencySymbol; // e.g. $, ₦

  const TransferCountry({
    required this.name,
    required this.currencyCode,
    required this.currencySymbol,
  });
}
