import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../../data/models/transfer_country.dart';
import 'app_icon.dart';

/// Country picker showing the flag beside the name.
///
/// Typed to [TransferCountry] rather than to a plain string so the flag can
/// come from the country's ISO code, the same way the wallet screens already
/// render `CountryFlag.fromCountryCode`.
class CountryDropdownField extends StatelessWidget {
  final String hint;
  final TransferCountry? value;
  final List<TransferCountry> items;
  final ValueChanged<TransferCountry?>? onChanged;

  const CountryDropdownField({
    super.key,
    required this.hint,
    required this.items,
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<TransferCountry>(
      initialValue: value,
      isExpanded: true,
      // The list is the whole world, so cap the popup rather than let it run
      // the height of the screen.
      menuMaxHeight: 420,
      icon: const AppIcon('chevron-down',
          size: 22, color: AppColors.primaryDark),
      style: const TextStyle(fontSize: 16, color: AppColors.primaryDark),
      hint: Text(hint,
          style: const TextStyle(fontSize: 16, color: AppColors.textGrey)),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.all(16),
        border: _border(),
        enabledBorder: _border(),
        focusedBorder: _border(focused: true),
      ),
      items: [
        for (final c in items)
          DropdownMenuItem<TransferCountry>(
            value: c,
            child: Row(
              children: [
                _flag(c.countryCode),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(c.name, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
      ],
      onChanged: onChanged,
    );
  }

  static Widget _flag(String code) => ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: CountryFlag.fromCountryCode(code, height: 16, width: 22),
      );

  static OutlineInputBorder _border({bool focused = false}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: focused ? AppColors.primaryDark : AppColors.divider,
        ),
      );
}
