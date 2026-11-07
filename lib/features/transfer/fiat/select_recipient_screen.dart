import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/bank_avatar.dart';
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
  String _query = '';
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

  /// Name, bank or account — whichever the person remembers.
  List<FiatBeneficiary> get _visible {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _beneficiaries;
    return _beneficiaries
        .where((b) =>
            b.displayName.toLowerCase().contains(q) ||
            b.bankName.toLowerCase().contains(q) ||
            b.accountNumber.toLowerCase().contains(q))
        .toList();
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
    final visible = _visible;
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Select Recipient'),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ScreenHeading(
                      'Who are you sending money to?',
                      helper: 'Choose a saved recipient or add someone new.',
                    ),
                    const SizedBox(height: 20),
                    AppTextInput(
                      hint: 'Search recipient',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(left: 14, right: 8),
                        child: AppIcon('search',
                            size: 20, color: AppColors.textGrey),
                      ),
                      onChanged: (v) => setState(() => _query = v),
                    ),
                    const SizedBox(height: 22),
                    SectionHeader(
                      'Saved Beneficiaries',
                      actionLabel: 'View all',
                      actionColor: AppColors.accentYellow,
                      onAction: () => Navigator.pushNamed(
                          context, AppRoutes.beneficiariesList),
                    ),
                    const SizedBox(height: 12),
                    if (visible.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Text('No recipient matches that search.',
                            style: TextStyle(
                                color: AppColors.textGrey, fontSize: 14)),
                      )
                    else
                      ...visible.map(_beneficiaryTile),
                    const SizedBox(height: 4),
                    _addNewTile(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _tile({required Widget avatar,
      required String title,
      required String subtitle,
      required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              avatar,
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 15)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: const TextStyle(
                            color: AppColors.textGrey, fontSize: 13)),
                  ],
                ),
              ),
              const AppIcon('chevron-right', color: AppColors.textGrey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _beneficiaryTile(FiatBeneficiary b) => _tile(
        avatar: BankAvatar(b.bankName),
        title: b.displayName,
        subtitle: b.listSubtitle,
        onTap: () => _pick(b),
      );

  Widget _addNewTile() => _tile(
        avatar: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColors.inputFill,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, color: AppColors.primaryDark, size: 20),
        ),
        title: 'Add New Recipient',
        subtitle: 'Send to a new person',
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.fiatAddRecipientShort,
          arguments: widget.transfer,
        ),
      );
}
