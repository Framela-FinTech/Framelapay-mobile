import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/fiat_beneficiary.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Edit Beneficiary — only the display name/nickname is editable; changing the
/// verified bank details requires adding and verifying a new account.
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Edit Beneficiary'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FieldLabel('Beneficiary name'),
              AppTextInput(controller: _name),
              const SizedBox(height: 16),
              const NoticeBanner(
                'Changing verified bank details requires adding and verifying '
                'a new account.',
                type: NoticeType.info,
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                'Save Changes',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Changes saved')),
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
