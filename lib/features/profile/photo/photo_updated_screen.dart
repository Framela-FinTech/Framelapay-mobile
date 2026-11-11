import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// "Photo Updated" — confirmation that the new profile photo is visible.
class PhotoUpdatedScreen extends StatelessWidget {
  const PhotoUpdatedScreen({super.key});

  void _returnToProfile(BuildContext context) {
    Navigator.popUntil(
        context, (r) => r.settings.name == AppRoutes.profile || r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _returnToProfile(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.pageGrey,
        appBar: whiteAppBar('Photo Updated'),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
                  child: const Column(
                    children: [
                      IconBadge(
                        icon: 'check-circle',
                        halo: AppColors.successSoft,
                        size: 104,
                        glyphSize: 42,
                        glyphColor: AppColors.success,
                      ),
                      SizedBox(height: 24),
                      ScreenHeading(
                        'Profile photo updated',
                        helper:
                            'Your new profile photo is now visible on your account.',
                        center: true,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: PrimaryButton(
                  'Return To Profile',
                  onPressed: () => _returnToProfile(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
