import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';
import 'kyc_widgets.dart';

/// Identity Verification — document type + issuing country + document upload.
class IdentityVerificationScreen extends StatefulWidget {
  const IdentityVerificationScreen({super.key});

  @override
  State<IdentityVerificationScreen> createState() =>
      _IdentityVerificationScreenState();
}

class _IdentityVerificationScreenState
    extends State<IdentityVerificationScreen> {
  String? _docType = 'International passport';
  String? _country = 'Nigeria';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Identity Verification'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FieldLabel('Document type'),
                    AppDropdownField(
                      hint: 'Select document type',
                      value: _docType,
                      items: const [
                        'International passport',
                        'National ID card',
                        'Driving licence',
                      ],
                      onChanged: (v) => setState(() => _docType = v),
                    ),
                    const SizedBox(height: 16),
                    const FieldLabel('Issuing country'),
                    AppDropdownField(
                      hint: 'Select country',
                      value: _country,
                      items: const ['Nigeria', 'Ghana', 'Germany', 'United States'],
                      onChanged: (v) => setState(() => _country = v),
                    ),
                    const SizedBox(height: 20),
                    const KycUploadCard(
                      icon: 'scan',
                      title: 'Capture identity document',
                      hint: 'Upload a clear image of the information page',
                    ),
                    const SizedBox(height: 16),
                    const NoticeBanner(
                        'Your document must be valid, readable and belong to you.',
                        type: NoticeType.info),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: PrimaryButton(
                'Continue',
                onPressed: () => Navigator.pushNamed(
                    context, AppRoutes.profileKycAddress),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
