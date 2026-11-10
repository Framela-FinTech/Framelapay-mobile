import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/exchange_rate.dart';
import '../../data/repositories/exchange_rate_repository.dart';
import '../transfer/fiat/widgets/fiat_form_widgets.dart';
import 'widgets/exchange_widgets.dart';
import 'widgets/rate_chart.dart';

/// One pair in detail: the rate, its chart, and the range's high and low.
class RatePairDetailScreen extends StatefulWidget {
  final CurrencyPair pair;
  const RatePairDetailScreen({super.key, required this.pair});

  @override
  State<RatePairDetailScreen> createState() => _RatePairDetailScreenState();
}

class _RatePairDetailScreenState extends State<RatePairDetailScreen> {
  final ExchangeRateRepository _repo = MockExchangeRateRepository();
  ExchangeRate? _rate;
  RateRange _range = RateRange.d7;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final rate = await _repo.getRateDetail(widget.pair, _range);
    if (!mounted) return;
    setState(() => _rate = rate);
  }

  Future<void> _setRange(RateRange range) async {
    setState(() => _range = range);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final rate = _rate;
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar(widget.pair.tightLabel),
      body: SafeArea(
        child: rate == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InfoCard(
                            padding: const EdgeInsets.all(16),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: CurrencyBadge(
                                        code: rate.pair.baseCode,
                                        name: rate.pair.baseName,
                                        country: rate.pair.baseCountry),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 6),
                                    child: Icon(Icons.swap_horiz,
                                        size: 20, color: AppColors.textGrey),
                                  ),
                                  Expanded(
                                    child: CurrencyBadge(
                                        code: rate.pair.quoteCode,
                                        name: rate.pair.quoteName,
                                        country: rate.pair.quoteCountry),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              const Divider(
                                  height: 1, color: AppColors.divider),
                              const SizedBox(height: 14),
                              const Text('Exchange rate',
                                  style: TextStyle(
                                      color: AppColors.textGrey,
                                      fontSize: 14)),
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
                                  ChangePill(rate.formattedChangeWithRange,
                                      isUp: rate.isUp),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // The board nests the tabs and chart in their
                              // own grey panel on this screen.
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.pageGrey,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  children: [
                                    RangeTabs(
                                        selected: _range,
                                        onChanged: _setRange),
                                    const SizedBox(height: 12),
                                    RateChart(points: rate.points),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                  child: _statCard(
                                      '${_range.label} High',
                                      rate.formattedHigh)),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: _statCard('${_range.label} Low',
                                      rate.formattedLow)),
                            ],
                          ),
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

  Widget _statCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(color: AppColors.textGrey, fontSize: 14)),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 19,
                  fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
