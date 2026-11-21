import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/correction_request.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';
import 'personal_info_widgets.dart';

/// Step 1 of Name Correction Flow.
/// Matches Row 0, Frame 1 of `Personal Information Edit.png`.
class RequestNameCorrectionScreen extends StatefulWidget {
  final String currentName;

  const RequestNameCorrectionScreen({
    super.key,
    this.currentName = 'Cynthia Nkechi',
  });

  @override
  State<RequestNameCorrectionScreen> createState() =>
      _RequestNameCorrectionScreenState();
}

class _RequestNameCorrectionScreenState
    extends State<RequestNameCorrectionScreen> {
  late final TextEditingController _nameController;
  String _selectedReason = 'Typo in my details';

  final List<String> _reasons = [
    'Typo in my details',
    'Legal name change',
    'Marriage / Divorce',
    'Incorrect order of names',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Cynthia N. Okoro');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onContinue() {
    final requestedName = _nameController.text.trim();
    if (requestedName.isEmpty) return;

    final request = CorrectionRequest(
      requestType: 'Full name',
      currentValue: widget.currentName,
      requestedValue: requestedName,
      reason: _selectedReason,
      title: 'Full name correction',
      reference: 'FRM-PI-2048',
    );

    Navigator.pushNamed(
      context,
      AppRoutes.nameSupportingDocument,
      arguments: request,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Request Name Correction'),
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
                    const ScreenHeading('Correct your full name'),
                    const SizedBox(height: 8),
                    const Text(
                      'This verified detail requires review. Your current value remains on your profile while we assess the request.',
                      style: TextStyle(
                        color: AppColors.neutral60,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Current full name (locked)
                    const Text(
                      'Current full name',
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
                      child: Text(
                        widget.currentName,
                        style: const TextStyle(
                          color: AppColors.neutral60,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Correct full name
                    const Text(
                      'Correct full name',
                      style: TextStyle(
                        color: AppColors.neutral60,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
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

                    // Reason for correction
                    const Text(
                      'Reason for correction',
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
                          value: _selectedReason,
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.neutral60,
                          ),
                          items: _reasons.map((r) {
                            return DropdownMenuItem<String>(
                              value: r,
                              child: Text(
                                r,
                                style: const TextStyle(
                                  color: AppColors.primaryDark,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedReason = val);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Notice
                    const NoticeBanner(
                      'Your name must match your valid identity document.',
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
