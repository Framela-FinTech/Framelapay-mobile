import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// Adjust Profile Photo — preview + position/scale slider before saving.
class AdjustProfilePhotoScreen extends StatefulWidget {
  const AdjustProfilePhotoScreen({super.key});

  @override
  State<AdjustProfilePhotoScreen> createState() =>
      _AdjustProfilePhotoScreenState();
}

class _AdjustProfilePhotoScreenState extends State<AdjustProfilePhotoScreen> {
  double _scale = 0.4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Adjust Profile Photo'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                      color: Color(0xFFDCE6FB), shape: BoxShape.circle),
                  child: const AppIcon('folder-user',
                      size: 72, color: AppColors.primaryDark),
                ),
              ),
              const SizedBox(height: 24),
              Text('POSITION AND SCALE',
                  style: TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.remove, size: 20),
                    Expanded(
                      child: Slider(
                        value: _scale,
                        activeColor: AppColors.primaryDark,
                        onChanged: (v) => setState(() => _scale = v),
                      ),
                    ),
                    const Icon(Icons.add, size: 20),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const NoticeBanner('Your photo will be cropped into a circle.',
                  type: NoticeType.info),
              const SizedBox(height: 24),
              PrimaryButton(
                'Save Photo',
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.photoUpdated),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    side: const BorderSide(color: AppColors.divider),
                    foregroundColor: AppColors.primaryDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Choose Another'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
