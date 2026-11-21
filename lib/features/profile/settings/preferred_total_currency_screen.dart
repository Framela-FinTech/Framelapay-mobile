import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Preferred Total Currency screen.
/// Matches Frame 2 of `Preferred total currency.png`.
class PreferredTotalCurrencyScreen extends StatefulWidget {
  const PreferredTotalCurrencyScreen({super.key});

  @override
  State<PreferredTotalCurrencyScreen> createState() =>
      _PreferredTotalCurrencyScreenState();
}

class _PreferredTotalCurrencyScreenState
    extends State<PreferredTotalCurrencyScreen> {
  String _selectedCode = 'EUR';

  final List<({String code, String name, String countryCode})> _currencies = [
    (code: 'EUR', name: 'Euro', countryCode: 'EU'),
    (code: 'USD', name: 'US Dollar', countryCode: 'US'),
    (code: 'NGN', name: 'Nigerian Naira', countryCode: 'NG'),
  ];

  void _onSave() {
    Navigator.pushNamed(context, AppRoutes.preferenceSaved);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Preferred Total Currency'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Choose the currency used to display your combined wallet balance.',
                      style: TextStyle(
                        color: AppColors.neutral60,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ..._currencies.map((curr) {
                      final isSelected = _selectedCode == curr.code;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () {
                            setState(() => _selectedCode = curr.code);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryDark
                                    : AppColors.divider,
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                ClipOval(
                                  child: SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: CountryFlag.fromCountryCode(
                                      curr.countryCode,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${curr.code} Wallet',
                                        style: const TextStyle(
                                          color: AppColors.primaryDark,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        curr.name,
                                        style: const TextStyle(
                                          color: AppColors.neutral60,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primaryDark
                                          : AppColors.divider,
                                      width: isSelected ? 6 : 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: PrimaryButton(
                'Saved Preference',
                onPressed: _onSave,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
