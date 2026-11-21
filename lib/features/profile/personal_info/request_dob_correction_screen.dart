import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/correction_request.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';
import 'personal_info_widgets.dart';

/// Step 1 of Date of Birth Correction Flow.
/// Matches Row 1, Frame 1 of `Personal Information Edit.png`.
class RequestDobCorrectionScreen extends StatefulWidget {
  final String currentDob;

  const RequestDobCorrectionScreen({
    super.key,
    this.currentDob = '14 March 1995',
  });

  @override
  State<RequestDobCorrectionScreen> createState() =>
      _RequestDobCorrectionScreenState();
}

class _RequestDobCorrectionScreenState
    extends State<RequestDobCorrectionScreen> {
  late final TextEditingController _dobController;
  String _selectedReason = 'Typographical error';

  final List<String> _reasons = [
    'Typographical error',
    'Official document change',
    'Calendar format discrepancy',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _dobController = TextEditingController(text: '14th March 1996');
  }

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1996, 3, 14),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      setState(() {
        _dobController.text =
            '${picked.day} ${months[picked.month - 1]} ${picked.year}';
      });
    }
  }

  void _onContinue() {
    final requestedDob = _dobController.text.trim();
    if (requestedDob.isEmpty) return;

    final request = CorrectionRequest(
      requestType: 'Date of birth',
      currentValue: widget.currentDob,
      requestedValue: requestedDob,
      reason: _selectedReason,
      title: 'Date of birth correction',
      reference: 'FRM-PI-2048',
    );

    Navigator.pushNamed(
      context,
      AppRoutes.dobSupportingDocument,
      arguments: request,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Correct Date Of Birth'),
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
                    const ScreenHeading('Correct your date of birth'),
                    const SizedBox(height: 8),
                    const Text(
                      'Your date of birth requires verification. Your current date of birth will remain on your profile until the correction is approved.',
                      style: TextStyle(
                        color: AppColors.neutral60,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Current date of birth (locked)
                    const Text(
                      'Current date of birth',
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
                          Text(
                            widget.currentDob,
                            style: const TextStyle(
                              color: AppColors.neutral60,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
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

                    // Correct date of birth (picker)
                    const Text(
                      'Correct date of birth',
                      style: TextStyle(
                        color: AppColors.neutral60,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _pickDate,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.divider, width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _dobController.text.isEmpty
                                  ? 'mm/dd/yyyy'
                                  : _dobController.text,
                              style: TextStyle(
                                color: _dobController.text.isEmpty
                                    ? AppColors.neutral60
                                    : AppColors.primaryDark,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 18,
                              color: AppColors.neutral60,
                            ),
                          ],
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
                      'Your date of birth must match your identity document.',
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
