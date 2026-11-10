import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_icon.dart';
import '../../data/models/exchange_rate.dart';
import '../../data/repositories/exchange_rate_repository.dart';
import '../transfer/fiat/widgets/fiat_form_widgets.dart';
import 'widgets/exchange_widgets.dart';
import 'widgets/rate_chart.dart';

/// Exchange Rates — the featured pair with its chart, then every rate.
class ExchangeRatesScreen extends StatefulWidget {
  const ExchangeRatesScreen({super.key});

  @override
  State<ExchangeRatesScreen> createState() => _ExchangeRatesScreenState();
}

class _ExchangeRatesScreenState extends State<ExchangeRatesScreen> {
  final ExchangeRateRepository _repo = MockExchangeRateRepository();

  List<ExchangeRate> _rates = [];
  ExchangeRate? _featured;
  RateRange _range = RateRange.d7;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final rates = await _repo.getRates();
    if (!mounted) return;
    final pair = _featured?.pair ?? rates.first.pair;
    final detail = await _repo.getRateDetail(pair, _range);
    if (!mounted) return;
    setState(() {
      _rates = rates;
      _featured = detail;
      _loading = false;
    });
  }

  Future<void> _setRange(RateRange range) async {
    setState(() => _range = range);
    final detail = await _repo.getRateDetail(_featured!.pair, range);
    if (!mounted) return;
    setState(() => _featured = detail);
  }

  Future<void> _changePair() async {
    final pair = await Navigator.pushNamed(context, AppRoutes.selectCurrencyPair)
        as CurrencyPair?;
    if (pair == null || !mounted) return;
    final detail = await _repo.getRateDetail(pair, _range);
    if (!mounted) return;
    setState(() => _featured = detail);
  }

  void _openPair(ExchangeRate rate) =>
      Navigator.pushNamed(context, AppRoutes.ratePairDetail,
          arguments: rate.pair);

  @override
  Widget build(BuildContext context) {
    final featured = _featured;
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Exchange Rates'),
      body: SafeArea(
        child: _loading || featured == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                                'Check currency rates and convert instantly.',
                                style: TextStyle(
                                    color: AppColors.textGrey, fontSize: 14)),
                          ),
                          const SizedBox(height: 18),
                          _featuredCard(featured),
                          const SizedBox(height: 22),
                          const SectionTitle('All rates'),
                          const SizedBox(height: 12),
                          ..._rates.map(_rateTile),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    child: PrimaryButton(
                      'Convert Funds',
                      onPressed: () => Navigator.pushNamed(
                          context, AppRoutes.convertSelectWallet),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _featuredCard(ExchangeRate rate) {
    return InfoCard(
      padding: const EdgeInsets.all(16),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Currency pair',
                style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
            GestureDetector(
              onTap: _changePair,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.infoSoft,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Change pair',
                        style: TextStyle(
                            color: AppColors.chartLine,
                            fontSize: 14,
                            fontWeight: FontWeight.w700)),
                    SizedBox(width: 2),
                    AppIcon('chevron-down',
                        size: 18, color: AppColors.chartLine),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _pairRow(rate.pair),
        const SizedBox(height: 14),
        const Divider(height: 1, color: AppColors.divider),
        const SizedBox(height: 14),
        const Text('Exchange rate',
            style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
        const SizedBox(height: 4),
        Row(
          children: [
            Flexible(
              child: Text(rate.formattedRate,
                  style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 22,
                      fontWeight: FontWeight.w800)),
            ),
            const SizedBox(width: 8),
            ChangePill(rate.formattedChangeWithRange, isUp: rate.isUp),
          ],
        ),
        const SizedBox(height: 8),
        const Row(
          children: [
            AppIcon('info-circle', size: 16, color: AppColors.textGrey),
            SizedBox(width: 6),
            Text('Illustrative rate · Not live',
                style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 16),
        RangeTabs(selected: _range, onChanged: _setRange),
        const SizedBox(height: 12),
        RateChart(points: rate.points),
      ],
    );
  }

  Widget _pairRow(CurrencyPair pair) {
    return Row(
      children: [
        Expanded(
          child: CurrencyBadge(
              code: pair.baseCode,
              name: pair.baseName,
              country: pair.baseCountry),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Icon(Icons.swap_horiz, size: 20, color: AppColors.textGrey),
        ),
        Expanded(
          child: CurrencyBadge(
              code: pair.quoteCode,
              name: pair.quoteName,
              country: pair.quoteCountry),
        ),
      ],
    );
  }

  Widget _rateTile(ExchangeRate rate) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => _openPair(rate),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              ClipOval(
                child: CountryFlag.fromCountryCode(rate.pair.baseCountry,
                    height: 40, width: 40),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(rate.pair.label,
                        style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 15)),
                    const SizedBox(height: 2),
                    Text(rate.pair.description,
                        style: const TextStyle(
                            color: AppColors.textGrey, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(rate.formattedValue,
                      style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 15)),
                  const SizedBox(height: 2),
                  ChangePill(rate.formattedChange,
                      isUp: rate.isUp, filled: false),
                ],
              ),
              const AppIcon('chevron-right', color: AppColors.textGrey),
            ],
          ),
        ),
      ),
    );
  }
}
