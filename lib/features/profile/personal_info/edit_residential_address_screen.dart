import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/correction_request.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';
import 'personal_info_widgets.dart';

/// Step 1 of Residential Address Update Flow.
/// Matches Row 2, Frame 1 of `Personal Information Edit.png`.
class EditResidentialAddressScreen extends StatefulWidget {
  final String currentAddress;

  const EditResidentialAddressScreen({
    super.key,
    this.currentAddress = '12 Adetokunbo Ademola Street',
  });

  @override
  State<EditResidentialAddressScreen> createState() =>
      _EditResidentialAddressScreenState();
}

class _EditResidentialAddressScreenState
    extends State<EditResidentialAddressScreen> {
  late final TextEditingController _addressController;
  late final TextEditingController _postalController;

  String _country = 'Nigeria';
  String _state = 'Lagos';
  String _city = 'Lagos';

  final List<String> _countries = [
    'Nigeria',
    'United Kingdom',
    'United States',
    'Ghana',
    'Kenya',
    'Canada',
    'Germany',
  ];

  final List<String> _states = [
    'Lagos',
    'Abuja FCT',
    'Rivers',
    'Oyo',
    'Enugu',
    'Delta',
  ];

  final List<String> _cities = [
    'Lagos',
    'Victoria Island',
    'Ikeja',
    'Lekki',
    'Yaba',
    'Surulere',
  ];

  @override
  void initState() {
    super.initState();
    _addressController =
        TextEditingController(text: '24 Adetokunbo Ademola Street');
    _postalController = TextEditingController(text: '1234566');
  }

  @override
  void dispose() {
    _addressController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  void _onContinue() {
    final newAddress = _addressController.text.trim();
    if (newAddress.isEmpty) return;

    final fullNewAddress =
        '$newAddress, $_city, $_state';

    final request = CorrectionRequest(
      requestType: 'Residential address',
      currentValue:
          '${widget.currentAddress}, Victoria Island, Lagos',
      requestedValue: fullNewAddress,
      reason: 'Relocation to new address',
      title: 'Address change',
      reference: 'FRM-AV-2048',
      extraDetail: _postalController.text.trim(),
    );

    Navigator.pushNamed(
      context,
      AppRoutes.addressSupportingDocument,
      arguments: request,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Edit Residential Address'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StepSubtitle('STEP 1 OF 3'),
                    const ScreenHeading('Update your address'),
                    const SizedBox(height: 8),
                    const Text(
                      'Your new address requires verification. Your current address will remain on your profile until the correction is approved.',
                      style: TextStyle(
                        color: AppColors.neutral60,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Current address (locked)
                    const Text(
                      'Current address',
                      style: TextStyle(
                        color: AppColors.neutral60,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.inputFill,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.divider, width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.currentAddress,
                              style: const TextStyle(
                                color: AppColors.neutral60,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.lock_outline,
                            size: 18,
                            color: AppColors.neutral60,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // New address
                    const Text(
                      'New address',
                      style: TextStyle(
                        color: AppColors.neutral60,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _addressController,
                      style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.white,
                        suffixIcon: const Icon(
                          Icons.location_on_outlined,
                          color: AppColors.neutral60,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.divider),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.divider),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppColors.primaryDark),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Country / Region dropdown
                    const Text(
                      'Country / Region',
                      style: TextStyle(
                        color: AppColors.neutral60,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.divider, width: 1),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _country,
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.neutral60,
                          ),
                          items: _countries.map((c) {
                            return DropdownMenuItem<String>(
                              value: c,
                              child: Text(
                                c,
                                style: const TextStyle(
                                  color: AppColors.primaryDark,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _country = val);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // State dropdown
                    const Text(
                      'State',
                      style: TextStyle(
                        color: AppColors.neutral60,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.divider, width: 1),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _state,
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.neutral60,
                          ),
                          items: _states.map((s) {
                            return DropdownMenuItem<String>(
                              value: s,
                              child: Text(
                                s,
                                style: const TextStyle(
                                  color: AppColors.primaryDark,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _state = val);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // City dropdown
                    const Text(
                      'City',
                      style: TextStyle(
                        color: AppColors.neutral60,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.divider, width: 1),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _city,
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.neutral60,
                          ),
                          items: _cities.map((ci) {
                            return DropdownMenuItem<String>(
                              value: ci,
                              child: Text(
                                ci,
                                style: const TextStyle(
                                  color: AppColors.primaryDark,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _city = val);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Postal code input
                    const Text(
                      'Postal code',
                      style: TextStyle(
                        color: AppColors.neutral60,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _postalController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.divider),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.divider),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppColors.primaryDark),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Notice
                    const NoticeBanner(
                      'The document must show your name and new residential address.',
                      icon: Icons.access_time,
                    ),
                  ],
                ),
              ),
            ),
            BottomBar(
              child: PrimaryButton(
                'Continue',
                onPressed: _onContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
