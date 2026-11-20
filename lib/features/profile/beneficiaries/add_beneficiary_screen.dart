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
/// Supports banks and currencies across multiple countries.
class AddBeneficiaryScreen extends StatefulWidget {
  const AddBeneficiaryScreen({super.key});

  @override
  State<AddBeneficiaryScreen> createState() => _AddBeneficiaryScreenState();
}

class _AddBeneficiaryScreenState extends State<AddBeneficiaryScreen> {
  static const _accountLength = 10;

  final CountryRepository _countryRepo = MockCountryRepository();
  final BankRepository _bankRepo = MockBankRepository();

  final _account = TextEditingController(text: '00001001011');
  final _name = TextEditingController(text: 'Kingsley Joe');

  List<TransferCountry> _countries = [];
  List<String> _banks = [];
  TransferCountry? _country;
  String? _bank = 'Partner Bank';
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
    final defaultCountry = countries.firstWhere(
      (c) => c.countryCode == 'NG',
      orElse: () => countries.first,
    );
    final banks = await _bankRepo.getBanksForCountry(defaultCountry.countryCode);
    if (!mounted) return;
    setState(() {
      _countries = countries;
      _country = defaultCountry;
      _banks = banks.map((b) => b.name).toList();
      _bank = _banks.isNotEmpty ? _banks.first : 'Partner Bank';
      _loading = false;
    });
  }

  Future<void> _onCountryChanged(TransferCountry? c) async {
    setState(() {
      _country = c;
      _bank = null;
    });
    if (c != null) {
      final banks = await _bankRepo.getBanksForCountry(c.countryCode);
      if (!mounted) return;
      setState(() {
        _banks = banks.map((b) => b.name).toList();
        if (_account.text.trim().length >= _accountLength) {
          _bank = _banks.isNotEmpty ? _banks.first : 'Partner Bank';
        }
      });
    }
  }

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
    final code = _country?.countryCode ?? 'NG';
    final banks = await _bankRepo.getBanksForCountry(code);
    if (!mounted) return;
    setState(() {
      _banks = banks.map((b) => b.name).toList();
      _bank = _banks.isNotEmpty ? _banks.first : 'Partner Bank';
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
      bankName: _bank ?? 'Partner Bank',
      accountNumber: _account.text.trim(),
      country: _country?.name ?? 'Nigeria',
      currency: _country?.currencyCode ?? 'NGN',
    );
    Navigator.pushNamed(
      context,
      AppRoutes.beneficiarySaved,
      arguments: beneficiary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Add Beneficiary'),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const FieldLabel('Recipient country'),
                              CountryDropdownField(
                                hint: 'Select country',
                                value: _country,
                                items: _countries,
                                onChanged: _onCountryChanged,
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
                              if (_bank != null) ...[
                                const SizedBox(height: 18),
                                const FieldLabel('Recipient bank'),
                                AppDropdownField(
                                  hint: 'Select bank',
                                  value: _bank,
                                  items: _banks,
                                  onChanged: (v) => setState(() => _bank = v),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      if (_bank != null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                          child: PrimaryButton(
                            'Save Beneficiary',
                            onPressed: _canSave ? _save : null,
                          ),
                        ),
                    ],
                  ),
                  if (_resolving)
                    Container(
                      color: Colors.black.withOpacity(0.35),
                      child: const Center(
                        child: SizedBox(
                          width: 36,
                          height: 36,
                          child: CircularProgressIndicator(
                            strokeWidth: 3.5,
                            color: AppColors.accentYellow,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
