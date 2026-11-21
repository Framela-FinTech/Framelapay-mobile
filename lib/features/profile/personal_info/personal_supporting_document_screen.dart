import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/correction_request.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';
import 'personal_info_widgets.dart';

/// Step 2 of Personal Information correction/editing flows.
/// Matches Frame 2 of Row 0, Row 1, and Row 2 of `Personal Information Edit.png`.
class PersonalSupportingDocumentScreen extends StatefulWidget {
  final CorrectionRequest request;

  const PersonalSupportingDocumentScreen({
    super.key,
    required this.request,
  });

  @override
  State<PersonalSupportingDocumentScreen> createState() =>
      _PersonalSupportingDocumentScreenState();
}

class _PersonalSupportingDocumentScreenState
    extends State<PersonalSupportingDocumentScreen> {
  String? _attachedFileName;

  @override
  void initState() {
    super.initState();
    // Default simulated attached file to match figma where user proceeds
    if (widget.request.requestType == 'Full name') {
      _attachedFileName = 'National_ID_Card.pdf';
    } else if (widget.request.requestType == 'Date of birth') {
      _attachedFileName = 'Birth_Certificate.pdf';
    } else {
      _attachedFileName = 'Utility_Bill_Statement.pdf';
    }
  }

  void _chooseFile() {
    setState(() {
      _attachedFileName = widget.request.requestType == 'Residential address'
          ? 'Utility_Bill_May2026.pdf'
          : 'National_Identity_Card.pdf';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Attached $_attachedFileName')),
    );
  }

  void _onContinue() {
    final updated = CorrectionRequest(
      requestType: widget.request.requestType,
      currentValue: widget.request.currentValue,
      requestedValue: widget.request.requestedValue,
      reason: widget.request.reason,
      documentName: _attachedFileName ?? 'Attached',
      reference: widget.request.reference,
      status: widget.request.status,
      title: widget.request.title,
      extraDetail: widget.request.extraDetail,
    );

    Navigator.pushNamed(
      context,
      AppRoutes.reviewPersonalCorrection,
      arguments: updated,
    );
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.request.requestType;

    String appBarTitle;
    String heading;
    String subtext;
    String uploadTitle;
    String uploadSub;
    String notice;
    String buttonLabel;

    if (type == 'Full name') {
      appBarTitle = 'Add Supporting Document';
      heading = 'Supporting document';
      subtext = 'Provide a clear document that shows your correct full name.';
      uploadTitle = 'Upload document';
      uploadSub = 'Clear photo or PDF - All details visible';
      notice =
          'Your current profile details stay unchanged until the request is approved.';
      buttonLabel = 'Review';
    } else if (type == 'Date of birth') {
      appBarTitle = 'Submit Document';
      heading = 'Upload supporting document';
      subtext = 'Passport, birth certificate or national identity document';
      uploadTitle = 'Upload supporting document';
      uploadSub = 'Passport, birth certificate or national identity document';
      notice =
          'The document must clearly show your full name and correct date of birth.';
      buttonLabel = 'Submit Request';
    } else {
      appBarTitle = 'Submit Document';
      heading = 'Proof of address';
      subtext =
          'Upload a utility bill or bank statement issued within the last 3 months. It must show your name new address.';
      uploadTitle = 'Upload proof of address';
      uploadSub = 'Utility bill or bank statement issued within 3 months';
      notice =
          'The document must show your name and new residential address.';
      buttonLabel = 'Continue';
    }

    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar(appBarTitle),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StepSubtitle('STEP 2 OF 3'),
                    ScreenHeading(heading),
                    const SizedBox(height: 8),
                    Text(
                      subtext,
                      style: const TextStyle(
                        color: AppColors.neutral60,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Upload Box
                    UploadBox(
                      title: uploadTitle,
                      subtitle: uploadSub,
                      attachedFileName: _attachedFileName,
                      onChooseFile: _chooseFile,
                    ),
                    const SizedBox(height: 20),

                    // Notice
                    NoticeBanner(
                      notice,
                      icon: type == 'Residential address'
                          ? Icons.access_time
                          : Icons.info_outline,
                    ),
                  ],
                ),
              ),
            ),
            BottomBar(
              child: PrimaryButton(
                buttonLabel,
                onPressed: _onContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
