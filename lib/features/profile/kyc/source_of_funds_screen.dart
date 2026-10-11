import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Source of Funds — primary source, employment status and expected activity.
class SourceOfFundsScreen extends StatefulWidget {
  const SourceOfFundsScreen({super.key});

  @override
  State<SourceOfFundsScreen> createState() => _SourceOfFundsScreenState();
}

class _SourceOfFundsScreenState extends State<SourceOfFundsScreen> {
  String? _source = 'Employment income';
  String? _status = 'Employed';
  String? _activity = 'Under €1,000';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Source of Funds'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FieldLabel('Primary source of funds'),
                    AppDropdownField(
                      hint: 'Select source',
                      value: _source,
                      items: const [
                        'Employment income',
                        'Business income',
                        'Investments',
                        'Savings',
                      ],
                      onChanged: (v) => setState(() => _source = v),
                    ),
                    const SizedBox(height: 16),
                    const FieldLabel('Employment status'),
                    AppDropdownField(
                      hint: 'Select status',
                      value: _status,
                      items: const [
                        'Employed',
                        'Self-employed',
                        'Unemployed',
                        'Student',
                        'Retired',
                      ],
                      onChanged: (v) => setState(() => _status = v),
                    ),
                    const SizedBox(height: 16),
                    const FieldLabel('Expected monthly activity'),
                    AppDropdownField(
                      hint: 'Select range',
                      value: _activity,
                      items: const [
                        'Under €1,000',
                        '€1,000 – €5,000',
                        '€5,000 – €20,000',
                        'Over €20,000',
                      ],
                      onChanged: (v) => setState(() => _activity = v),
                    ),
                    const SizedBox(height: 16),
                    const NoticeBanner(
                        'This information helps us meet regulatory requirements '
                        'and protect your account.',
                        type: NoticeType.info),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: PrimaryButton(
                'Review Information',
                onPressed: () => Navigator.pushNamed(
                    context, AppRoutes.profileKycReview),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
