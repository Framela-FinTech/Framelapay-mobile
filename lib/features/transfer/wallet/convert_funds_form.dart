import 'dart:async';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../data/models/conversion_result.dart';
import '../../../data/models/currency_wallet.dart';
import '../../../data/repositories/currency_wallet_repository.dart';
import '../fiat/widgets/fiat_form_widgets.dart';

/// The convert form itself: from/to wallet pickers, amount, quote rows, the
/// rate-validity pill and the Convert action.
///
/// Shared by both presentations the boards specify — the bottom sheet opened
/// mid-transfer from Send Money (Home Transfer row 2), and the full-screen
/// Convert Funds step reached from the Wallet tab (Conversion board).
class ConvertFundsForm extends StatefulWidget {
  final List<CurrencyWallet> wallets;

  /// The wallet to start on, when the caller has already chosen one.
  final CurrencyWallet? initialFrom;

  final ValueChanged<ConversionResult> onConverted;

  const ConvertFundsForm({
    super.key,
    required this.wallets,
    required this.onConverted,
    this.initialFrom,
  });

  @override
  State<ConvertFundsForm> createState() => _ConvertFundsFormState();
}

class _ConvertFundsFormState extends State<ConvertFundsForm> {
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
    _from = widget.initialFrom ??
        widget.wallets.firstWhere((w) => w.code == 'NGN',
            orElse: () => widget.wallets.first);
    _to = widget.wallets.firstWhere((w) => w.code != _from.code,
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

  double get _amount => double.tryParse(
      _amountController.text.trim().replaceAll(',', '')) ??
      0;

  Future<void> _recompute() async {
    final quote = await _repo.getConvertQuote(
      fromCode: _from.code,
      toCode: _to.code,
      amount: _amount,
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

  void _useAll() {
    _amountController.text = _from.balance.toStringAsFixed(2);
    _recompute();
  }

  void _convert() {
    final quote = _quote;
    if (quote == null) return;
    widget.onConverted(ConversionResult(
      from: _from,
      to: _to,
      amountConverted: _amount,
      fee: quote.fee,
      amountReceived: quote.receiveAmount,
      rateText: quote.rateText,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final rateText = _quote?.rateText ?? '—';
    final feeText = _quote == null
        ? '—'
        : '${_from.symbol}${CurrencyWallet.format(_quote!.fee)}';
    final receiveText = _quote == null
        ? '—'
        : '${_to.symbol}${CurrencyWallet.format(_quote!.receiveAmount)}';
    final feePercent = (ConvertQuote.feeRate * 100).toStringAsFixed(0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('From wallet'),
        _walletPicker(_from, (w) {
          setState(() => _from = w);
          _recompute();
        }),
        const SizedBox(height: 10),
        Center(
          child: InkWell(
            onTap: _swap,
            borderRadius: BorderRadius.circular(22),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.divider),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.swap_vert,
                  color: AppColors.primaryDark, size: 22),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const FieldLabel('To wallet'),
        _walletPicker(_to, (w) {
          setState(() => _to = w);
          _recompute();
        }),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FieldLabel('Amount to convert (${_from.code})'),
            GestureDetector(
              onTap: _useAll,
              child: const Text('Use All',
                  style: TextStyle(
                      color: AppColors.accentYellow,
                      fontWeight: FontWeight.w700,
                      fontSize: 14)),
            ),
          ],
        ),
        AppTextInput(
          controller: _amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          hint: '0.00',
          // Without this the quote rows only refreshed on a wallet change.
          onChanged: (_) => _recompute(),
        ),
        const SizedBox(height: 18),
        InfoCard(
          children: [
            SummaryRow('Exchange rate', rateText),
            const Divider(height: 1, color: AppColors.divider),
            SummaryRow('Fee (included · $feePercent%)', feeText),
            const Divider(height: 1, color: AppColors.divider),
            SummaryRow('You will receive', receiveText, bold: true),
          ],
        ),
        const SizedBox(height: 16),
        TimerPill('Rate valid for ', highlight: _validText),
        const SizedBox(height: 22),
        PrimaryButton('Convert', onPressed: _amount > 0 ? _convert : null),
      ],
    );
  }

  /// White card showing the wallet's flag, name and balance; tapping opens a
  /// picker. The boards draw these rather than plain dropdowns.
  Widget _walletPicker(CurrencyWallet w, ValueChanged<CurrencyWallet> onPick) {
    return InkWell(
      onTap: () => _pickWallet(onPick),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            ClipOval(
              child: CountryFlag.fromCountryCode(w.countryCode,
                  height: 38, width: 38),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${w.code} Wallet',
                      style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(w.name,
                      style: const TextStyle(
                          color: AppColors.textGrey, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(w.formattedBalance,
                    style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                const SizedBox(height: 2),
                const Text('Available balance',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
              ],
            ),
            const SizedBox(width: 6),
            const AppIcon('chevron-down', color: AppColors.primaryDark),
          ],
        ),
      ),
    );
  }

  Future<void> _pickWallet(ValueChanged<CurrencyWallet> onPick) async {
    final picked = await showModalBottomSheet<CurrencyWallet>(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 18),
            const SectionTitle('Choose wallet'),
            const SizedBox(height: 10),
            for (final w in widget.wallets)
              ListTile(
                leading: ClipOval(
                  child: CountryFlag.fromCountryCode(w.countryCode,
                      height: 34, width: 34),
                ),
                title: Text('${w.code} Wallet',
                    style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
                subtitle: Text(w.name,
                    style: const TextStyle(
                        color: AppColors.textGrey, fontSize: 13)),
                trailing: Text(w.formattedBalance,
                    style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                onTap: () => Navigator.pop(context, w),
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
    if (picked != null) onPick(picked);
  }
}
