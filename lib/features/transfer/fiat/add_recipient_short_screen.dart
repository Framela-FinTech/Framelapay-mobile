import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/fiat_transfer.dart';
import '../../../data/models/fiat_beneficiary.dart';
import '../../../data/repositories/bank_repository.dart';
import 'widgets/fiat_form_widgets.dart';

/// Screen 3 — short "Add recipient" form (Bank + Account Number).
/// Continues to the full form (screen 4), carrying what's entered.
///
/// Note: the design labels the account-number field "Account Name"; it is
/// treated as the Account Number here (see report).
class AddRecipientShortScreen extends StatefulWidget {
  final FiatTransfer transfer;
  const AddRecipientShortScreen({super.key, required this.transfer});

  @override
  State<AddRecipientShortScreen> createState() =>
      _AddRecipientShortScreenState();
}

class _AddRecipientShortScreenState extends State<AddRecipientShortScreen> {
  final BankRepository _bankRepo = MockBankRepository();
  final TextEditingController _accountController = TextEditingController();
  List<String> _banks = [];
  String? _bank;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _accountController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final banks = await _bankRepo.getBanks();
    if (!mounted) return;
    setState(() {
      _banks = banks.map((b) => b.name).toList();
      _bank = _banks.isNotEmpty ? _banks.first : null;
      _loading = false;
    });
  }

  void _continue() {
    final partial = FiatBeneficiary(
      fullName: '',
      bankName: _bank ?? '',
      accountNumber: _accountController.text.trim(),
      country: '',
    );
    Navigator.pushNamed(
      context,
      AppRoutes.fiatAddRecipientFull,
      arguments: widget.transfer.copyWith(beneficiary: partial),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Add Recipient'),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          const ScreenHeading(
                            'Add recipient',
                            helper:
                                'Please enter the recipient details accurately.',
                          ),
                          const SizedBox(height: 20),
                          const FieldLabel('Bank'),
                          AppDropdownField(
                            hint: 'Select bank',
                            value: _bank,
                            items: _banks,
                            onChanged: (v) => setState(() => _bank = v),
                          ),
                          const SizedBox(height: 16),
                          const FieldLabel('Account Number'),
                          AppTextInput(
                            controller: _accountController,
                            keyboardType: TextInputType.number,
                            hint: '123456789',
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    child: PrimaryButton('Verify Account', onPressed: _continue),
                  ),
                ],
              ),
      ),
    );
  }
}
