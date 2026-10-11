import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/fiat_transfer.dart';
import '../../../data/repositories/bank_repository.dart';
import '../../../data/repositories/beneficiary_repository.dart';
import 'widgets/fiat_form_widgets.dart';

/// Screen 4 — full "Add recipient" form. Verifies the account via the mock
/// [BeneficiaryRepository] and continues to the "Account verified" screen.
class AddRecipientFullScreen extends StatefulWidget {
  final FiatTransfer transfer;
  const AddRecipientFullScreen({super.key, required this.transfer});

  @override
  State<AddRecipientFullScreen> createState() => _AddRecipientFullScreenState();
}

class _AddRecipientFullScreenState extends State<AddRecipientFullScreen> {
  final BankRepository _bankRepo = MockBankRepository();
  final BeneficiaryRepository _beneficiaryRepo = MockBeneficiaryRepository();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();

  static const _relationships = ['Family', 'Friend', 'Business', 'Self'];
  static const _purposes = [
    'Family support',
    'Business payment',
    'Education',
    'Gift',
  ];

  List<String> _banks = [];
  String? _bank;
  String? _relationship;
  String? _purpose;
  bool _loading = true;
  bool _verifying = false;

  @override
  void initState() {
    super.initState();
    final prefill = widget.transfer.beneficiary;
    if (prefill != null) {
      _accountController.text = prefill.accountNumber;
    }
    _load();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _accountController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final banks = await _bankRepo.getBanks();
    if (!mounted) return;
    final prefillBank = widget.transfer.beneficiary?.bankName;
    setState(() {
      _banks = banks.map((b) => b.name).toList();
      _bank = (prefillBank != null && _banks.contains(prefillBank))
          ? prefillBank
          : (_banks.isNotEmpty ? _banks.first : null);
      _loading = false;
    });
  }

  Future<void> _verify() async {
    setState(() => _verifying = true);
    final verified = await _beneficiaryRepo.verifyAccount(
      bankName: _bank ?? '',
      accountNumber: _accountController.text.trim(),
      fullName: _nameController.text.trim(),
      relationship: _relationship,
      purpose: _purpose,
    );
    if (!mounted) return;
    setState(() => _verifying = false);
    Navigator.pushNamed(
      context,
      AppRoutes.fiatAccountVerified,
      arguments: widget.transfer.copyWith(
        beneficiary: verified,
        purpose: _purpose,
      ),
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
                          const FieldLabel('Full Name'),
                          AppTextInput(
                            controller: _nameController,
                            hint: 'John Dee',
                          ),
                          const SizedBox(height: 16),
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
                          const SizedBox(height: 16),
                          const FieldLabel('Relationship'),
                          AppDropdownField(
                            hint: 'Select relationship',
                            value: _relationship,
                            items: _relationships,
                            onChanged: (v) =>
                                setState(() => _relationship = v),
                          ),
                          const SizedBox(height: 16),
                          const FieldLabel('Purpose of Transfer'),
                          AppDropdownField(
                            hint: 'Select purpose',
                            value: _purpose,
                            items: _purposes,
                            onChanged: (v) => setState(() => _purpose = v),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    child: PrimaryButton(
                      _verifying ? 'Verifying...' : 'Verify Account',
                      onPressed: _verifying ? null : _verify,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
