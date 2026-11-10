import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_icon.dart';
import '../../data/models/rate_alert.dart';
import '../../data/repositories/rate_alert_repository.dart';
import '../transfer/fiat/widgets/fiat_form_widgets.dart';

/// "My Rate Alerts" — every saved alert, with its condition and status.
class RateAlertsScreen extends StatefulWidget {
  const RateAlertsScreen({super.key});

  @override
  State<RateAlertsScreen> createState() => _RateAlertsScreenState();
}

class _RateAlertsScreenState extends State<RateAlertsScreen> {
  final RateAlertRepository _repo = MockRateAlertRepository();
  List<RateAlert> _alerts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final alerts = await _repo.getAlerts();
    if (!mounted) return;
    setState(() {
      _alerts = alerts;
      _loading = false;
    });
  }

  Future<void> _open(RateAlert? alert) async {
    await Navigator.pushNamed(context, AppRoutes.rateAlertForm,
        arguments: alert);
    if (!mounted) return;
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('My Rate Alerts'),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: _alerts.isEmpty
                        ? _emptyState()
                        : SingleChildScrollView(
                            padding:
                                const EdgeInsets.fromLTRB(20, 20, 20, 24),
                            child: Column(
                              children: _alerts.map(_alertCard).toList(),
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    child: PrimaryButton('Create New Alert',
                        onPressed: () => _open(null)),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconBadge(
              icon: 'bell',
              halo: AppColors.infoHalo,
              size: 104,
              glyphSize: 42,
              glyphColor: AppColors.primary50,
            ),
            SizedBox(height: 20),
            Text('No rate alerts yet',
                style: TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 22,
                    fontWeight: FontWeight.w800)),
            SizedBox(height: 8),
            Text("Create one and we'll tell you when a rate hits your target.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textGrey, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget _alertCard(RateAlert alert) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _open(alert),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  ClipOval(
                    child: CountryFlag.fromCountryCode(
                        alert.pair.baseCountry,
                        height: 40,
                        width: 40),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(alert.pair.label,
                            style: const TextStyle(
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.w700,
                                fontSize: 15)),
                        const SizedBox(height: 2),
                        Text(alert.pair.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: AppColors.textGrey, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _statusPill(alert),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: AppColors.divider),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(alert.summary,
                            style: const TextStyle(
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.w700,
                                fontSize: 16)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const AppIcon('bell',
                                size: 15, color: AppColors.textGrey),
                            const SizedBox(width: 6),
                            Text(alert.delivery.label,
                                style: const TextStyle(
                                    color: AppColors.textGrey, fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const AppIcon('chevron-right', color: AppColors.textGrey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusPill(RateAlert alert) {
    final colour = alert.active ? AppColors.success : AppColors.textGrey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: alert.active ? AppColors.successNotice : AppColors.pageGrey,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(alert.active ? Icons.circle : Icons.pause,
              size: alert.active ? 8 : 13, color: colour),
          const SizedBox(width: 6),
          Text(alert.statusLabel,
              style: TextStyle(
                  color: colour,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
