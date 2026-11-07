import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
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
    // Figma adds a "Total you pay" line: the send amount plus the fee.
    final sendAmount = double.tryParse(_amountController.text.trim()) ?? 0;
    final totalText = _quote == null
        ? '—'
        : '${_destination!.currencySymbol}${_fmt(sendAmount + _quote!.fee)}';
    final receiveText = _quote == null
        ? '—'
        : '${_receiving!.currencySymbol}${_fmt(_quote!.receiveAmount)}';

    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Destination'),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ScreenHeading(
                      'Where Are You Sending Money?',
                      helper:
                          'Choose the destination and enter your send amount.',
                    ),
                    const SizedBox(height: 22),
                    const FieldLabel('Receiving country'),
                    AppDropdownField(
                      hint: 'Select receiving country',
                      value: _receiving?.name,
                      items: names,
                      onChanged: (v) {
                        setState(() =>
                            _receiving = _countries.firstWhere((c) => c.name == v));
                        _recompute();
                      },
                    ),
                    const SizedBox(height: 18),
                    const FieldLabel('Amount you send'),
                    _amountRow(),
                    const SizedBox(height: 22),
                    const SectionTitle('Transfer breakdown'),
                    const SizedBox(height: 10),
                    _breakdownCard(rateText, feeText, totalText, receiveText),
                    const SizedBox(height: 18),
                    const NoticeBanner(
                      'No hidden fees. Your final rate and fees are shown in the '
                      'quote before you confirm.',
                    ),
                    const SizedBox(height: 40),
                    PrimaryButton(
                      'Continue',
                      onPressed: _quote == null
                          ? null
                          : () => Navigator.pushNamed(
                                context,
                                AppRoutes.fiatSelectRecipient,
                                arguments: _buildTransfer(),
                              ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  /// Amount field with the send-currency picker on its right, split by a rule.
  /// Figma folds the old separate "Destination Country" dropdown into this.
  Widget _amountRow() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark),
              onChanged: (_) => _recompute(),
              decoration: InputDecoration(
                prefixText: _destination?.currencySymbol ?? r'$',
                prefixStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark),
                hintText: '500.00',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 18),
              ),
            ),
          ),
          Container(width: 1, height: 28, color: AppColors.divider),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _destination?.currencyCode,
                icon: const AppIcon('chevron-down',
                    size: 22, color: AppColors.primaryDark),
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDark),
                items: _countries
                    .map((c) => c.currencyCode)
                    .toSet()
                    .map((code) => DropdownMenuItem<String>(
                        value: code, child: Text(code)))
                    .toList(),
                onChanged: (code) {
                  if (code == null) return;
                  setState(() => _destination = _countries
                      .firstWhere((c) => c.currencyCode == code));
                  _recompute();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _breakdownCard(
      String rate, String fee, String total, String receives) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          SummaryRow('Indicative exchange rate', rate),
          const Divider(height: 1, color: AppColors.divider),
          SummaryRow('Transfer fee', fee),
          const Divider(height: 1, color: AppColors.divider),
          SummaryRow('Total you pay', total),
          const Divider(height: 1, color: AppColors.divider),
          SummaryRow('Recipient gets', receives, bold: true),
        ],
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
