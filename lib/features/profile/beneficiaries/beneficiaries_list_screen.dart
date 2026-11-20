import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/bank_avatar.dart';
import '../../../data/models/fiat_beneficiary.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Beneficiaries list — search saved recipients, tap a row to open its details,
/// or tap "Add New Recipient" at the bottom to add a new beneficiary.
class BeneficiariesListScreen extends StatefulWidget {
  const BeneficiariesListScreen({super.key});

  @override
  State<BeneficiariesListScreen> createState() =>
      _BeneficiariesListScreenState();
}

class _BeneficiariesListScreenState extends State<BeneficiariesListScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final results = q.isEmpty
        ? sampleBeneficiaries
        : sampleBeneficiaries
            .where((b) =>
                b.displayName.toLowerCase().contains(q) ||
                b.accountNumber.toLowerCase().contains(q) ||
                b.bankName.toLowerCase().contains(q))
            .toList();

    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Beneficiaries'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            // The Figma board contains duplicate search fields
            // ("Search beneficiaries" and "Search recipient"); consolidated to one.
            AppTextInput(
              controller: _searchController,
              hint: 'Search recipient',
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: AppIcon('search', size: 20, color: AppColors.textGrey),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SectionTitle('Saved Beneficiaries'),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'View all',
                    style: TextStyle(
                      color: AppColors.accentYellow,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...results.map((b) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _beneficiaryCard(b),
                )),
            const SizedBox(height: 4),
            _addNewRecipientCard(),
          ],
        ),
      ),
    );
  }

  Widget _beneficiaryCard(FiatBeneficiary b) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.beneficiaryDetails,
        arguments: b,
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            if (b.isFramelaTag)
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.iconTileSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: AppIcon('folder-user',
                      size: 20, color: AppColors.primaryDark),
                ),
              )
            else
              BankAvatar(b.bankName, size: 42),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    b.displayName,
                    style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    b.listSubtitle,
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const AppIcon(
              'chevron-right',
              size: 18,
              color: AppColors.textGrey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _addNewRecipientCard() {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRoutes.addBeneficiary),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.iconTileSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.add, size: 20, color: AppColors.primaryDark),
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add New Recipient',
                    style: TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Send to a new person',
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const AppIcon(
              'chevron-right',
              size: 18,
              color: AppColors.textGrey,
            ),
          ],
        ),
      ),
    );
  }
}
