import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../data/models/currency_wallet.dart';
import '../../../data/repositories/currency_wallet_repository.dart';
import '../fiat/widgets/fiat_form_widgets.dart';

/// Screen 16 (Wallet) — "Convert Funds" bottom sheet.
///
/// Returns a success-message string (e.g. "£1,000 converted to $216.50") when
/// a conversion completes, or null if dismissed. The caller shows a success
/// banner with that message.
Future<String?> showConvertFundsSheet(
  BuildContext context,
  List<CurrencyWallet> wallets,
) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _ConvertFundsSheet(wallets: wallets),
  );
}

class _ConvertFundsSheet extends StatefulWidget {
  final List<CurrencyWallet> wallets;
  const _ConvertFundsSheet({required this.wallets});

  @override
  State<_ConvertFundsSheet> createState() => _ConvertFundsSheetState();
}

class _ConvertFundsSheetState extends State<_ConvertFundsSheet> {
  final CurrencyWalletRepository _repo = MockCurrencyWalletRepository();
  final TextEditingController _amountController = TextEditingController();

  late CurrencyWallet _from;
  late CurrencyWallet _to;
  ConvertQuote? _quote;

  static const _validSeconds = 43; // 00:43
  int _remaining = _validSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _from = widget.wallets.firstWhere((w) => w.code == 'GBP',
        orElse: () => widget.wallets.first);
    _to = widget.wallets.firstWhere((w) => w.code == 'USD',
        orElse: () => widget.wallets.last);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_remaining == 0) {
        _timer?.cancel();
        return;
      }
      setState(() => _remaining--);
    });
    _recompute();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  String get _validText {
    final m = (_remaining ~/ 60).toString().padLeft(2, '0');
    final s = (_remaining % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  CurrencyWallet _byCode(String code) =>
      widget.wallets.firstWhere((w) => w.code == code);

  Future<void> _recompute() async {
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    final quote = await _repo.getConvertQuote(
      fromCode: _from.code,
      toCode: _to.code,
      amount: amount,
    );
    if (!mounted) return;
    setState(() => _quote = quote);
  }

  void _swap() {
    setState(() {
      final tmp = _from;
      _from = _to;
      _to = tmp;
    });
    _recompute();
  }

  void _convert() {
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    final received = _quote?.receiveAmount ?? 0;
    final msg =
        '${_from.symbol}${_fmt(amount)} converted to ${_to.symbol}${_fmt(received)}';
    Navigator.pop(context, msg);
  }

  @override
  Widget build(BuildContext context) {
    final codes = widget.wallets.map((w) => '${w.code} · ${w.name}').toList();
    final feeText = _quote == null ? '—' : '${_to.symbol}${_fmt(_quote!.fee)}';
    final receiveText = _quote == null
        ? '—'
        : '${_to.symbol}${_fmt(_quote!.receiveAmount)}';
    final rateText = _quote?.rateText ?? '—';

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Convert Funds',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const FieldLabel('From wallet'),
            AppDropdownField(
              hint: 'Select wallet',
              value: '${_from.code} · ${_from.name}',
              items: codes,
              onChanged: (v) {
                if (v == null) return;
                setState(() => _from = _byCode(v.split(' · ').first));
                _recompute();
              },
            ),
            const SizedBox(height: 8),
            Center(
              child: InkWell(
                onTap: _swap,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      color: AppColors.inputFill, shape: BoxShape.circle),
                  child: const AppIcon('coin-swap',
                      color: AppColors.primaryDark, size: 20),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const FieldLabel('To wallet'),
            AppDropdownField(
              hint: 'Select wallet',
              value: '${_to.code} · ${_to.name}',
              items: codes,
              onChanged: (v) {
                if (v == null) return;
                setState(() => _to = _byCode(v.split(' · ').first));
                _recompute();
              },
            ),
            const SizedBox(height: 16),
            const FieldLabel('Amount to convert'),
            AppTextInput(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              prefixText: '${_from.symbol} ',
              hint: '0.00',
            ),
            const SizedBox(height: 16),
            SummaryRow('Exchange rate', rateText),
            SummaryRow('Fee', feeText),
            SummaryRow("You'll receive", receiveText, bold: true),
            const SizedBox(height: 12),
            Center(child: TimerPill('Rate valid for $_validText')),
            const SizedBox(height: 16),
            PrimaryButton('Convert now', onPressed: _convert),
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
