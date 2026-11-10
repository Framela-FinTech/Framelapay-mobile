import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/exchange_rate.dart';
import '../transfer/fiat/widgets/fiat_form_widgets.dart';

/// "Currency pair updated" — confirmation after changing the featured pair.
/// Pops the chosen pair back so Exchange Rates can reload on it.
class CurrencyPairUpdatedScreen extends StatelessWidget {
  final CurrencyPair pair;
  const CurrencyPairUpdatedScreen({super.key, required this.pair});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Currency Pair Updated'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                          color: AppColors.success, shape: BoxShape.circle),
                      child: const Icon(Icons.check,
                          color: Colors.white, size: 36),
                    ),
                    const SizedBox(height: 18),
                    const ScreenHeading(
                      'Currency pair updated',
                      helper:
                          'Your preferred exchange rate pair has been changed '
                          'successfully.',
                      center: true,
                    ),
                    const SizedBox(height: 22),
                    InfoCard(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: CountryFlag.fromCountryCode(
                                  pair.baseCountry,
                                  height: 34,
                                  width: 34),
                            ),
                            Transform.translate(
                              offset: const Offset(-8, 0),
                              child: ClipOval(
                                child: CountryFlag.fromCountryCode(
                                    pair.quoteCountry,
                                    height: 34,
                                    width: 34),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(pair.label,
                                style: const TextStyle(
                                    color: AppColors.primaryDark,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(pair.description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: AppColors.textGrey, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                children: [
                  PrimaryButton('View Rate',
                      onPressed: () => Navigator.pop(context, pair)),
                  const SizedBox(height: 12),
                  SecondaryButton('Back to Exchange Rates',
                      onPressed: () => Navigator.pop(context, pair)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
