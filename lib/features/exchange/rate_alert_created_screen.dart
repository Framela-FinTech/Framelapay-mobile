import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_icon.dart';
import '../../data/models/rate_alert.dart';
import '../transfer/fiat/widgets/fiat_form_widgets.dart';

/// "Rate alert created" — confirmation after saving a new alert.
class RateAlertCreatedScreen extends StatelessWidget {
  final RateAlert alert;
  const RateAlertCreatedScreen({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Rate Alert'),
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
                    ScreenHeading(
                      'Rate alert created',
                      helper:
                          "We'll notify you when ${alert.pair.label} reaches "
                          '${alert.formattedTarget}.',
                      center: true,
                    ),
                    const SizedBox(height: 22),
                    InfoCard(
                      children: [
                        _row('coin-swap', 'Pair', alert.pair.label),
                        const Divider(height: 1, color: AppColors.divider),
                        _row('bell', 'Condition', alert.condition.shortLabel),
                        const Divider(height: 1, color: AppColors.divider),
                        _row('chart-up', 'Target rate',
                            alert.formattedTarget),
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
                  PrimaryButton(
                    'View My Alerts',
                    onPressed: () => Navigator.pushReplacementNamed(
                        context, AppRoutes.rateAlerts),
                  ),
                  const SizedBox(height: 12),
                  SecondaryButton(
                    'Back to Rates',
                    onPressed: () => Navigator.popUntil(
                      context,
                      (r) =>
                          r.settings.name == AppRoutes.exchangeRates ||
                          r.isFirst,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
                color: AppColors.iconTileSoft, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: AppIcon(icon, size: 17, color: AppColors.primary50),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: AppColors.textGrey, fontSize: 13)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
