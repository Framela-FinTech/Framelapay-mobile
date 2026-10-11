import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../data/models/fiat_beneficiary.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Beneficiaries list — search saved recipients, tap a row to open its details,
/// or add a new beneficiary.
class BeneficiariesListScreen extends StatefulWidget {
  const BeneficiariesListScreen({super.key});

  @override
  State<BeneficiariesListScreen> createState() =>
      _BeneficiariesListScreenState();
}

class _BeneficiariesListScreenState extends State<BeneficiariesListScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final results = q.isEmpty
        ? sampleBeneficiaries
        : sampleBeneficiaries
            .where((b) =>
                b.displayName.toLowerCase().contains(q) ||
                b.accountNumber.toLowerCase().contains(q))
            .toList();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Beneficiaries'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const FieldLabel('Search beneficiaries'),
              TextField(
                onChanged: (v) => setState(() => _query = v),
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search name or account',
                  hintStyle: const TextStyle(
                      fontSize: 14, color: AppColors.textGrey),
                  filled: true,
                  fillColor: AppColors.inputFill,
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _row(results[i]),
                ),
              ),
              const SizedBox(height: 8),
              PrimaryButton(
                'Add Beneficiary',
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.addBeneficiary),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(FiatBeneficiary b) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRoutes.beneficiaryDetails,
          arguments: b),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(b.displayName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text('${b.currency ?? b.country} •••• ${b.accountTail}',
                      style: const TextStyle(
                          color: AppColors.textGrey, fontSize: 12)),
                ],
              ),
            ),
            const AppIcon('chevron-right', size: 18, color: AppColors.textGrey),
          ],
        ),
      ),
    );
  }
}
