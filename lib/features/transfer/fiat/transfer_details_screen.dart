import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/fiat_transfer.dart';
import '../../../data/models/transfer_country.dart';
import '../../../data/repositories/country_repository.dart';
import '../../../data/repositories/fx_repository.dart';
import 'widgets/fiat_form_widgets.dart';

/// Screen 1 — shared first step of every fiat flow (Bank / Card / Wallet).
/// Collects destination/receiving country + send amount and shows a live
/// FX summary pulled from the mock [FxRepository].
class TransferDetailsScreen extends StatefulWidget {
  final FiatTransfer transfer;
  const TransferDetailsScreen({super.key, required this.transfer});

  @override
  State<TransferDetailsScreen> createState() => _TransferDetailsScreenState();
}

class _TransferDetailsScreenState extends State<TransferDetailsScreen> {
  final CountryRepository _countryRepo = MockCountryRepository();
  final FxRepository _fxRepo = MockFxRepository();
  final TextEditingController _amountController =
      TextEditingController(text: '500.00');

  List<TransferCountry> _countries = [];
  TransferCountry? _destination; // send side
  TransferCountry? _receiving; // receive side
  FxQuote? _quote;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final countries = await _countryRepo.getCountries();
    if (!mounted) return;
    setState(() {
      _countries = countries;
      _destination = countries.firstWhere((c) => c.currencyCode == 'USD',
          orElse: () => countries.first);
      _receiving = countries.firstWhere((c) => c.currencyCode == 'NGN',
          orElse: () => countries.last);
      _loading = false;
    });
    _recompute();
  }

  Future<void> _recompute() async {
    if (_destination == null || _receiving == null) return;
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    final quote = await _fxRepo.getQuote(
      sendCurrency: _destination!.currencyCode,
      receiveCurrency: _receiving!.currencyCode,
      sendAmount: amount,
    );
    if (!mounted) return;
    setState(() => _quote = quote);
  }

  FiatTransfer _buildTransfer() {
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    final quote = _quote;
    return widget.transfer.copyWith(
      sendCurrencyCode: _destination!.currencyCode,
      sendCurrencySymbol: _destination!.currencySymbol,
      receiveCurrencyCode: _receiving!.currencyCode,
      receiveCurrencySymbol: _receiving!.currencySymbol,
      sendAmount: amount,
      fxRate: quote?.rate,
      fee: quote?.fee,
      receiveAmount: quote?.receiveAmount,
    );
  }

  @override
  Widget build(BuildContext context) {
    final names = _countries.map((c) => c.name).toList();
    final rateText = _quote == null
        ? '—'
        : '1 ${_destination!.currencyCode} = ${_fmt(_quote!.rate)} ${_receiving!.currencyCode}';
    final feeText =
        _quote == null ? '—' : '${_destination!.currencySymbol}${_fmt(_quote!.fee)}';
    final receiveText = _quote == null
        ? '—'
        : '${_receiving!.currencySymbol}${_fmt(_quote!.receiveAmount)}';

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Transfer'),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          const ScreenHeading(
                            'Where are you sending money?',
                            helper:
                                'Enter the details of the person you want to send money to.',
                          ),
                          const SizedBox(height: 20),
                          const FieldLabel('Destination Country'),
                          AppDropdownField(
                            hint: 'Select destination country',
                            value: _destination?.name,
                            items: names,
                            onChanged: (v) {
                              setState(() => _destination = _countries
                                  .firstWhere((c) => c.name == v));
                              _recompute();
                            },
                          ),
                          const SizedBox(height: 16),
                          const FieldLabel('Receiving Country'),
                          AppDropdownField(
                            hint: 'Select destination country',
                            value: _receiving?.name,
                            items: names,
                            onChanged: (v) {
                              setState(() => _receiving = _countries
                                  .firstWhere((c) => c.name == v));
                              _recompute();
                            },
                          ),
                          const SizedBox(height: 16),
                          const FieldLabel('Amount you send'),
                          AppTextInput(
                            controller: _amountController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            prefixText:
                                '${_destination?.currencySymbol ?? r'$'} ',
                            hint: '500.00',
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.inputFill,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                SummaryRow('FX Rate', rateText),
                                SummaryRow('Transfer Fee', feeText),
                                const Divider(),
                                SummaryRow('Recipient gets', receiveText,
                                    bold: true),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          const NoticeBanner(
                            'No hidden fees. Exchange rate and fees are shown before you confirm.',
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    child: PrimaryButton(
                      'Continue',
                      onPressed: _quote == null
                          ? null
                          : () => Navigator.pushNamed(
                                context,
                                AppRoutes.fiatSelectRecipient,
                                arguments: _buildTransfer(),
                              ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  static String _fmt(double v) {
    final s = v.toStringAsFixed(2);
    final parts = s.split('.');
    final withCommas = parts[0].replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (m) => '${m[1]},',
    );
    return '$withCommas.${parts[1]}';
  }
}
