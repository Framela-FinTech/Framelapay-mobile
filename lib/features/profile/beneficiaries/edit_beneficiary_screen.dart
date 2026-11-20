import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../data/models/fiat_beneficiary.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Edit Beneficiary — only the recipient name is editable; account number
/// and bank are locked with a lock icon suffix.
/// Matches Row 2, Frame 1 of the `Beneficiary.png` Figma board.
class EditBeneficiaryScreen extends StatefulWidget {
  final FiatBeneficiary beneficiary;

  const EditBeneficiaryScreen({super.key, required this.beneficiary});

  @override
  State<EditBeneficiaryScreen> createState() => _EditBeneficiaryScreenState();
}

class _EditBeneficiaryScreenState extends State<EditBeneficiaryScreen> {
  late final TextEditingController _name =
      TextEditingController(text: widget.beneficiary.displayName);

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Edit Beneficiary'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 88,
                            height: 88,
                            decoration: const BoxDecoration(
                              color: Color(0xFF8FA8BF),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                _initials(widget.beneficiary.displayName),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.beneficiary.displayName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    const FieldLabel('Recipient name'),
                    AppTextInput(controller: _name),
                    const SizedBox(height: 18),
                    const FieldLabel('Account number'),
                    _lockedField(widget.beneficiary.accountNumber),
                    const SizedBox(height: 18),
                    const FieldLabel('Bank'),
                    _lockedField(widget.beneficiary.bankName),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: PrimaryButton(
                'Save Changes',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Changes saved')),
                  );
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lockedField(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w500,
            ),
          ),
          const AppIcon(
            'lock',
            size: 18,
            color: AppColors.textGrey,
          ),
        ],
      ),
    );
  }
}
