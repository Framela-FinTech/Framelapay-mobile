import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';
import 'kyc_widgets.dart';

/// Address Verification — residential address + city + proof-of-address upload.
class AddressVerificationScreen extends StatefulWidget {
  const AddressVerificationScreen({super.key});

  @override
  State<AddressVerificationScreen> createState() =>
      _AddressVerificationScreenState();
}

class _AddressVerificationScreenState extends State<AddressVerificationScreen> {
  final _address =
      TextEditingController(text: '12 Adetokunbo Ademola Street');
  String? _city = 'Lagos';

  @override
  void dispose() {
    _address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Address Verification'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FieldLabel('Residential address'),
                    TextField(
                      controller: _address,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        suffixIcon: const Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: AppIcon('location',
                              size: 20, color: AppColors.primaryDark),
                        ),
                        suffixIconConstraints:
                            const BoxConstraints(minWidth: 0, minHeight: 0),
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
                    const FieldLabel('City'),
                    AppDropdownField(
                      hint: 'Select city',
                      value: _city,
                      items: const ['Lagos', 'Abuja', 'Port Harcourt', 'Kano'],
                      onChanged: (v) => setState(() => _city = v),
                    ),
                    const SizedBox(height: 20),
                    const KycUploadCard(
                      icon: 'cloud-upload',
                      title: 'Upload proof of address',
                      hint: 'Utility bill or bank statement • PDF, JPG or PNG',
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: PrimaryButton(
                'Continue',
                onPressed: () => Navigator.pushNamed(
                    context, AppRoutes.profileKycSourceOfFunds),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
