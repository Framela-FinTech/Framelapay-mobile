import 'dart:async';

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/country_dropdown.dart';
import '../../../data/models/fiat_beneficiary.dart';
import '../../../data/models/transfer_country.dart';
import '../../../data/repositories/bank_repository.dart';
import '../../../data/repositories/country_repository.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Add Beneficiary — recipient country, name and account number; entering a
/// full account number resolves the bank, after which the entry can be saved.
///
/// The board draws three states of this one screen: the form, a spinner while
/// the account is looked up, and the resolved form with the bank field and the
/// save action revealed. Currency is derived from the chosen country rather
/// than asked for, and the nickname is set later from Beneficiary Details.
class AddBeneficiaryScreen extends StatefulWidget {
  const AddBeneficiaryScreen({super.key});

  @override
  State<AddBeneficiaryScreen> createState() => _AddBeneficiaryScreenState();
}

class _AddBeneficiaryScreenState extends State<AddBeneficiaryScreen> {
  static const _accountLength = 10;

  final CountryRepository _countryRepo = MockCountryRepository();
  final BankRepository _bankRepo = MockBankRepository();

  final _account = TextEditingController();
  final _name = TextEditingController();

  List<TransferCountry> _countries = [];
  List<String> _banks = [];
  TransferCountry? _country;
  String? _bank;
  bool _loading = true;
  bool _resolving = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _account.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final countries = await _countryRepo.getCountries();
    if (!mounted) return;
    setState(() {
      _countries = countries;
      _country = countries.firstWhere(
        (c) => c.countryCode == 'NG',
        orElse: () => countries.first,
      );
      _loading = false;
    });
  }

  /// A full account number triggers the bank lookup the board shows as a
  /// spinner. Debounced so each keystroke does not start a new one.
  void _onAccountChanged(String value) {
    _debounce?.cancel();
    final digits = value.trim();
    if (digits.length < _accountLength) {
      if (_bank != null || _resolving) {
        setState(() {
          _bank = null;
          _resolving = false;
        });
      }
      return;
    }
    setState(() => _resolving = true);
    _debounce = Timer(const Duration(milliseconds: 600), _resolveBank);
  }

  Future<void> _resolveBank() async {
    final banks = await _bankRepo.getBanks();
    if (!mounted) return;
    setState(() {
      _banks = banks.map((b) => b.name).toList();
      _bank = _banks.isNotEmpty ? _banks.first : null;
      _resolving = false;
    });
  }

  bool get _canSave =>
      _bank != null &&
      _name.text.trim().isNotEmpty &&
      _account.text.trim().length >= _accountLength;

  void _save() {
    final beneficiary = FiatBeneficiary(
      fullName: _name.text.trim(),
      bankName: _bank ?? '',
      accountNumber: _account.text.trim(),
      country: _country?.name ?? '',
      currency: _country?.currencyCode,
    );
    Navigator.pushNamed(context, AppRoutes.confirmBeneficiary,
        arguments: beneficiary);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Add Beneficiary'),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FieldLabel('Recipient country'),
                    CountryDropdownField(
                      hint: 'Select country',
                      value: _country,
                      items: _countries,
                      onChanged: (c) => setState(() => _country = c),
                    ),
                    const SizedBox(height: 18),
                    const FieldLabel('Beneficiary name'),
                    AppTextInput(
                      hint: 'Enter full name',
                      controller: _name,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 18),
                    const FieldLabel('Account Number'),
                    AppTextInput(
                      hint: 'Enter account number',
                      controller: _account,
                      keyboardType: TextInputType.number,
                      maxLength: _accountLength,
                      onChanged: _onAccountChanged,
                    ),
                    if (_resolving) ...[
                      const SizedBox(height: 22),
                      const Center(
                        child: SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                              strokeWidth: 3, color: AppColors.accentYellow),
                        ),
                      ),
                    ],
                    if (_bank != null) ...[
                      const SizedBox(height: 18),
                      const FieldLabel('Recipient bank'),
                      AppDropdownField(
                        hint: 'Select bank',
                        value: _bank,
                        items: _banks,
                        onChanged: (v) => setState(() => _bank = v),
                      ),
                      const SizedBox(height: 28),
                      PrimaryButton(
                        'Save Beneficiary',
                        onPressed: _canSave ? _save : null,
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}
