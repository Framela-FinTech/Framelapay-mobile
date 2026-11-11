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
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Adjust Profile Picture'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 190,
                  height: 190,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/cynthia_avatar.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Position and Scale',
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.remove,
                        size: 20, color: AppColors.primaryDark),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppColors.chartLine,
                          inactiveTrackColor: AppColors.divider,
                          thumbColor: AppColors.chartLine,
                          overlayColor:
                              AppColors.chartLine.withValues(alpha: 0.15),
                          trackHeight: 4,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 7),
                        ),
                        child: Slider(
                          value: _scale,
                          onChanged: (v) => setState(() => _scale = v),
                        ),
                      ),
                    ),
                    const Icon(Icons.add,
                        size: 20, color: AppColors.primaryDark),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.infoNotice,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: 20, color: AppColors.primaryDark),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Your photo will be cropped into a circle.',
                        style: TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                'Save Photo',
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.photoUpdated),
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                'Choose Another',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
