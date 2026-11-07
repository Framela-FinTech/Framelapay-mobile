import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/fiat_transfer.dart';
import '../../../data/models/fiat_beneficiary.dart';
import '../../../data/repositories/bank_repository.dart';
import 'widgets/fiat_form_widgets.dart';

/// Screen 3 — "Recipient Details" (Bank + Account number).
/// Continues to the sending-purpose form (screen 4), carrying what's entered.
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
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Add Recipient'),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ScreenHeading(
                      'Recipient Details',
                      helper:
                          "Enter the recipient's bank details accurately.",
                    ),
                    const SizedBox(height: 22),
                    const FieldLabel('Bank'),
                    AppDropdownField(
                      hint: 'Select bank',
                      value: _bank,
                      items: _banks,
                      onChanged: (v) => setState(() => _bank = v),
                    ),
                    const SizedBox(height: 18),
                    const FieldLabel('Account number'),
                    AppTextInput(
                      controller: _accountController,
                      keyboardType: TextInputType.number,
                      hint: '0123456789',
                    ),
                    // The board puts the CTA directly under the fields rather
                    // than pinned, which also stops the footer squeezing the
                    // form when the keyboard opens.
                    const SizedBox(height: 28),
                    PrimaryButton('Verify Account', onPressed: _continue),
                  ],
                ),
              ),
      ),
    );
  }
}
