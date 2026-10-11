import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../data/models/fiat_transfer.dart';
import '../../../data/models/fiat_beneficiary.dart';
import '../../../data/repositories/beneficiary_repository.dart';
import 'widgets/fiat_form_widgets.dart';

/// Screen 2 — pick an existing beneficiary or start adding a new one.
class SelectRecipientScreen extends StatefulWidget {
  final FiatTransfer transfer;
  const SelectRecipientScreen({super.key, required this.transfer});

  @override
  State<SelectRecipientScreen> createState() => _SelectRecipientScreenState();
}

class _SelectRecipientScreenState extends State<SelectRecipientScreen> {
  final BeneficiaryRepository _repo = MockBeneficiaryRepository();
  List<FiatBeneficiary> _beneficiaries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await _repo.getBeneficiaries();
    if (!mounted) return;
    setState(() {
      _beneficiaries = list;
      _loading = false;
    });
  }

  void _pick(FiatBeneficiary b) {
    Navigator.pushNamed(
      context,
      AppRoutes.fiatFxQuote,
      arguments: widget.transfer.copyWith(beneficiary: b),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Select Recipient'),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const ScreenHeading(
                      'Who are you sending money to?',
                      helper:
                          'Enter the details of the person you want to send money to.',
                    ),
                    const SizedBox(height: 20),
                    const AppTextInput(hint: 'Search recipient'),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Existing Beneficiary',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 15)),
                        TextButton(
                          onPressed: () {},
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ..._beneficiaries.map(_beneficiaryTile),
                    const SizedBox(height: 8),
                    _addNewTile(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _beneficiaryTile(FiatBeneficiary b) {
    return InkWell(
      onTap: () => _pick(b),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primaryDark,
              child: AppIcon('folder-user', color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(b.fullName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(b.listSubtitle,
                      style: const TextStyle(
                          color: AppColors.textGrey, fontSize: 12)),
                ],
              ),
            ),
            const AppIcon('chevron-right', color: AppColors.textGrey),
          ],
        ),
      ),
    );
  }

  Widget _addNewTile() {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.fiatAddRecipientShort,
        arguments: widget.transfer,
      ),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.accentYellow,
              child: Icon(Icons.add, color: AppColors.primaryDark, size: 18),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Add New Recipient',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  SizedBox(height: 2),
                  Text('Send to a new person',
                      style: TextStyle(
                          color: AppColors.textGrey, fontSize: 12)),
                ],
              ),
            ),
            AppIcon('chevron-right', color: AppColors.textGrey),
          ],
        ),
      ),
    );
  }
}
