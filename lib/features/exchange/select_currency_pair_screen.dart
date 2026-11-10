import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/exchange_rate.dart';
import '../../data/repositories/exchange_rate_repository.dart';
import '../transfer/fiat/widgets/fiat_form_widgets.dart';

/// "Select currency pair" — pick the two sides of the featured pair.
/// Returns the chosen [CurrencyPair] to Exchange Rates.
class SelectCurrencyPairScreen extends StatefulWidget {
  const SelectCurrencyPairScreen({super.key});

  @override
  State<SelectCurrencyPairScreen> createState() =>
      _SelectCurrencyPairScreenState();
}

class _SelectCurrencyPairScreenState extends State<SelectCurrencyPairScreen> {
  final ExchangeRateRepository _repo = MockExchangeRateRepository();

  List<CurrencyOption> _currencies = [];
  CurrencyOption? _from;
  CurrencyOption? _to;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final currencies = await _repo.getCurrencies();
    if (!mounted) return;
    setState(() {
      _currencies = currencies;
      _from = currencies.firstWhere((c) => c.code == 'USD',
          orElse: () => currencies.first);
      _to = currencies.firstWhere((c) => c.code == 'NGN',
          orElse: () => currencies.last);
      _loading = false;
    });
  }

  bool get _valid => _from != null && _to != null && _from!.code != _to!.code;

  Future<void> _save() async {
    final pair = CurrencyPair(
      baseCode: _from!.code,
      baseName: _from!.name,
      baseCountry: _from!.country,
      quoteCode: _to!.code,
      quoteName: _to!.name,
      quoteCountry: _to!.country,
    );
    // The confirmation screen hands the pair back to Exchange Rates.
    final result = await Navigator.pushReplacementNamed(
        context, AppRoutes.currencyPairUpdated, arguments: pair);
    if (!mounted) return;
    Navigator.pop(context, result ?? pair);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Select Currency Pair'),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ScreenHeading(
                            'Select currency pair',
                            helper:
                                'Choose the currencies you want to compare.',
                          ),
                          const SizedBox(height: 22),
                          const FieldLabel('From currency'),
                          _picker(_from, (v) => setState(() => _from = v)),
                          const SizedBox(height: 18),
                          const FieldLabel('To currency'),
                          _picker(_to, (v) => setState(() => _to = v)),
                          if (!_valid) ...[
                            const SizedBox(height: 14),
                            const NoticeBanner(
                              'Pick two different currencies to compare.',
                              type: NoticeType.warning,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    child: PrimaryButton('Save Change',
                        onPressed: _valid ? _save : null),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _picker(CurrencyOption? value, ValueChanged<CurrencyOption> onPick) {
    return AppDropdownField(
      hint: 'Select currency',
      value: value?.label,
      items: _currencies.map((c) => c.label).toList(),
      onChanged: (label) {
        if (label == null) return;
        onPick(_currencies.firstWhere((c) => c.label == label));
      },
    );
  }
}
