import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Account Statements — pick wallet, duration and date range, then generate a
/// statement that lands on the "statement ready" screen.
class AccountStatementsScreen extends StatefulWidget {
  const AccountStatementsScreen({super.key});

  @override
  State<AccountStatementsScreen> createState() =>
      _AccountStatementsScreenState();
}

class _AccountStatementsScreenState extends State<AccountStatementsScreen> {
  String _wallet = 'EUR Wallet';
  String _duration = 'Last 3 months';
  DateTime _from = DateTime(2026, 6, 1);
  DateTime _to = DateTime(2026, 9, 30);
  final _email = TextEditingController();

  static const _wallets = ['EUR Wallet', 'USD Wallet', 'GBP Wallet', 'NGN Wallet'];
  static const _durations = [
    'Last 3 months',
    'Last 6 months',
    'Last 12 months',
    'Custom range',
  ];

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _pick(bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? _from : _to,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked == null) return;
    setState(() {
      if (isFrom) {
        _from = picked;
      } else {
        _to = picked;
      }
    });
  }

  void _generate() {
    Navigator.pushNamed(
      context,
      AppRoutes.statementReady,
      arguments: '$_wallet • ${_fmt(_from)} to ${_fmt(_to)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Account Statements'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const FieldLabel('Wallet'),
                    AppDropdownField(
                      hint: 'Select wallet',
                      value: _wallet,
                      items: _wallets,
                      onChanged: (v) => setState(() => _wallet = v ?? _wallet),
                    ),
                    const SizedBox(height: 16),
                    const FieldLabel('Duration'),
                    AppDropdownField(
                      hint: 'Select duration',
                      value: _duration,
                      items: _durations,
                      onChanged: (v) =>
                          setState(() => _duration = v ?? _duration),
                    ),
                    const SizedBox(height: 16),
                    const FieldLabel('From'),
                    _dateField(_fmt(_from), () => _pick(true)),
                    const SizedBox(height: 16),
                    const FieldLabel('To'),
                    _dateField(_fmt(_to), () => _pick(false)),
                    const SizedBox(height: 16),
                    const FieldLabel('Email'),
                    AppTextInput(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      hint: 'Send a copy to this email',
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: PrimaryButton('Generate Statement', onPressed: _generate),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateField(String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(value, style: const TextStyle(fontSize: 14)),
            ),
            const AppIcon('calendar', size: 18, color: AppColors.textGrey),
          ],
        ),
      ),
    );
  }
}
