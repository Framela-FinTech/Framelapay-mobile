import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_icon.dart';
import '../../data/models/exchange_rate.dart';
import '../../data/models/rate_alert.dart';
import '../../data/repositories/exchange_rate_repository.dart';
import '../../data/repositories/rate_alert_repository.dart';
import '../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Create or edit a rate alert.
///
/// One screen for four of the board's frames: "Set Rate Alert" with each of
/// its two dropdowns open, and "Alert Details". Editing adds the status pill
/// and swaps the actions for Save / Pause / Delete.
class RateAlertFormScreen extends StatefulWidget {
  /// Null creates a new alert; non-null edits that one.
  final RateAlert? alert;

  /// Pair to start on when creating.
  final CurrencyPair? pair;

  const RateAlertFormScreen({super.key, this.alert, this.pair});

  @override
  State<RateAlertFormScreen> createState() => _RateAlertFormScreenState();
}

class _RateAlertFormScreenState extends State<RateAlertFormScreen> {
  final RateAlertRepository _repo = MockRateAlertRepository();
  final ExchangeRateRepository _rateRepo = MockExchangeRateRepository();
  final TextEditingController _target = TextEditingController();

  late CurrencyPair _pair;
  AlertCondition? _condition;
  AlertDelivery? _delivery;
  bool _repeat = true;
  ExchangeRate? _current;
  bool _saving = false;

  bool get _isEditing => widget.alert != null;

  @override
  void initState() {
    super.initState();
    final alert = widget.alert;
    _pair = alert?.pair ??
        widget.pair ??
        const CurrencyPair(
          baseCode: 'USD',
          baseName: 'US Dollar',
          baseCountry: 'US',
          quoteCode: 'NGN',
          quoteName: 'Nigerian Naira',
          quoteCountry: 'NG',
        );
    if (alert != null) {
      _condition = alert.condition;
      _delivery = alert.delivery;
      _repeat = alert.repeat;
      _target.text = alert.formattedTarget;
    }
    _loadRate();
  }

  @override
  void dispose() {
    _target.dispose();
    super.dispose();
  }

  Future<void> _loadRate() async {
    final rate = await _rateRepo.getRateDetail(_pair, RateRange.d7);
    if (!mounted) return;
    setState(() => _current = rate);
  }

  double get _targetValue =>
      double.tryParse(_target.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;

  bool get _valid =>
      _condition != null && _delivery != null && _targetValue > 0;

  Future<void> _save() async {
    setState(() => _saving = true);
    final saved = await _repo.saveAlert(RateAlert(
      id: widget.alert?.id ?? '',
      pair: _pair,
      condition: _condition!,
      targetRate: _targetValue,
      delivery: _delivery!,
      repeat: _repeat,
      active: widget.alert?.active ?? true,
    ));
    if (!mounted) return;
    setState(() => _saving = false);

    if (_isEditing) {
      Navigator.pop(context);
      return;
    }
    Navigator.pushReplacementNamed(context, AppRoutes.rateAlertCreated,
        arguments: saved);
  }

  Future<void> _togglePause() async {
    final alert = widget.alert!;
    await _repo.saveAlert(alert.copyWith(active: !alert.active));
    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.white,
        title: const Text('Delete this alert?'),
        content: const Text(
            'You will stop receiving notifications for this rate.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await _repo.deleteAlert(widget.alert!.id);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar(_isEditing ? 'Alert Details' : 'Set Rate Alert'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _pairCard(),
                    const SizedBox(height: 20),
                    const FieldLabel('Notify me when'),
                    AppDropdownField(
                      hint: 'Select',
                      value: _condition?.label,
                      items: AlertCondition.values
                          .map((c) => c.label)
                          .toList(),
                      onChanged: (v) => setState(() => _condition =
                          AlertCondition.values
                              .firstWhere((c) => c.label == v)),
                    ),
                    const SizedBox(height: 18),
                    const FieldLabel('Target rate'),
                    AppTextInput(
                      controller: _target,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      hint: 'e.g. 12,500',
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 18),
                    const FieldLabel('Delivery method'),
                    AppDropdownField(
                      hint: 'Select Notification Method',
                      value: _delivery?.label,
                      items:
                          AlertDelivery.values.map((d) => d.label).toList(),
                      onChanged: (v) => setState(() => _delivery =
                          AlertDelivery.values
                              .firstWhere((d) => d.label == v)),
                    ),
                    const SizedBox(height: 18),
                    const FieldLabel('Repeat alert'),
                    _repeatRow(),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const AppIcon('bell',
                            size: 16, color: AppColors.textGrey),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                              "We'll notify you when the target rate is "
                              'reached.',
                              style: TextStyle(
                                  color: AppColors.textGrey, fontSize: 13)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: _isEditing ? _editActions() : _createActions(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createActions() {
    return Column(
      children: [
        PrimaryButton(
          _saving ? 'Saving...' : 'Set Rate Alert',
          onPressed: _valid && !_saving ? _save : null,
        ),
        const SizedBox(height: 12),
        SecondaryButton(
          'Convert Funds',
          onPressed: () =>
              Navigator.pushNamed(context, AppRoutes.convertSelectWallet),
        ),
      ],
    );
  }

  Widget _editActions() {
    return Column(
      children: [
        PrimaryButton(
          _saving ? 'Saving...' : 'Save Changes',
          onPressed: _valid && !_saving ? _save : null,
        ),
        const SizedBox(height: 12),
        SecondaryButton(
          widget.alert!.active ? 'Pause Alert' : 'Resume Alert',
          onPressed: _togglePause,
        ),
        const SizedBox(height: 4),
        TextButton(
          onPressed: _delete,
          child: const Text('Delete Alert',
              style: TextStyle(
                  color: AppColors.error,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }

  Widget _pairCard() {
    final rate = _current;
    return InfoCard(
      padding: const EdgeInsets.all(16),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipOval(
              child: CountryFlag.fromCountryCode(_pair.baseCountry,
                  height: 36, width: 36),
            ),
            Transform.translate(
              offset: const Offset(-10, 0),
              child: ClipOval(
                child: CountryFlag.fromCountryCode(_pair.quoteCountry,
                    height: 36, width: 36),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_pair.label,
                      style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 16)),
                  const SizedBox(height: 2),
                  Text(_pair.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppColors.textGrey, fontSize: 13)),
                ],
              ),
            ),
            if (_isEditing) ...[
              const SizedBox(width: 8),
              _statusPill(widget.alert!),
            ],
          ],
        ),
        const SizedBox(height: 14),
        const Divider(height: 1, color: AppColors.divider),
        const SizedBox(height: 14),
        const Text('Current indicative rate',
            style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
        const SizedBox(height: 4),
        Text(rate?.formattedRate ?? '—',
            style: const TextStyle(
                color: AppColors.primaryDark,
                fontSize: 20,
                fontWeight: FontWeight.w800)),
      ],
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
                  color: colour, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _repeatRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text('Repeat alert',
                style: TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
          ),
          // The board draws this toggle amber on Set Rate Alert and blue on
          // Alert Details; amber matches the rest of the app.
          Switch(
            value: _repeat,
            activeThumbColor: AppColors.white,
            activeTrackColor: AppColors.accentYellow,
            onChanged: (v) => setState(() => _repeat = v),
          ),
        ],
      ),
    );
  }
}
