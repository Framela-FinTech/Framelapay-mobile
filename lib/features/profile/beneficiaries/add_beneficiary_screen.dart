import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/fiat_beneficiary.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Add Beneficiary — collect recipient bank details, then "Verify Account"
/// moves on to the Confirm Beneficiary screen.
class AddBeneficiaryScreen extends StatefulWidget {
  const AddBeneficiaryScreen({super.key});

  @override
  State<AddBeneficiaryScreen> createState() => _AddBeneficiaryScreenState();
}

class _AddBeneficiaryScreenState extends State<AddBeneficiaryScreen> {
  String? _country = 'Nigeria';
  String? _currency = 'NGN';
  String? _bank = 'Partner Bank';
  final _account = TextEditingController();
  final _name = TextEditingController();
  final _nickname = TextEditingController();

  @override
  void dispose() {
    _account.dispose();
    _name.dispose();
    _nickname.dispose();
    super.dispose();
  }

  void _verify() {
    final beneficiary = FiatBeneficiary(
      fullName: _name.text.trim().isEmpty ? 'New recipient' : _name.text.trim(),
      bankName: _bank ?? '',
      accountNumber: _account.text.trim(),
      country: _country ?? '',
      currency: _currency,
      nickname: _nickname.text.trim().isEmpty ? null : _nickname.text.trim(),
    );
    Navigator.pushNamed(context, AppRoutes.confirmBeneficiary,
        arguments: beneficiary);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Add Beneficiary'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FieldLabel('Recipient country'),
              AppDropdownField(
                hint: 'Select country',
                value: _country,
                items: const ['Nigeria', 'Germany', 'United States', 'Ghana'],
                onChanged: (v) => setState(() => _country = v),
              ),
              const SizedBox(height: 16),
              const FieldLabel('Recipient currency'),
              AppDropdownField(
                hint: 'Select currency',
                value: _currency,
                items: const ['NGN', 'EUR', 'USD', 'GHS'],
                onChanged: (v) => setState(() => _currency = v),
              ),
              const SizedBox(height: 16),
              const FieldLabel('Recipient bank'),
              AppDropdownField(
                hint: 'Select bank',
                value: _bank,
                items: const ['Partner Bank', 'Example Bank', 'First Union'],
                onChanged: (v) => setState(() => _bank = v),
              ),
              const SizedBox(height: 16),
              const FieldLabel('Account number'),
              AppTextInput(
                hint: 'Enter account number',
                controller: _account,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              const FieldLabel('Beneficiary name'),
              AppTextInput(hint: 'Enter full name', controller: _name),
              const SizedBox(height: 16),
              const FieldLabel('Nick name'),
              AppTextInput(hint: 'Optional', controller: _nickname),
              const SizedBox(height: 24),
              PrimaryButton('Verify Account', onPressed: _verify),
            ],
          ),
        ),
      ),
    );
  }
}
