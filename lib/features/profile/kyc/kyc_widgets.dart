import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_icon.dart';

/// Status pill used for "Verified" / "Active" badges in the
/// profile KYC upgrade flow. Both "Verified" and "Active" in the Figma board
/// use an amber/gold pill background with dark amber text.
class KycPill extends StatelessWidget {
  final String text;
  final Color background;
  final Color color;

  const KycPill(
    this.text, {
    super.key,
    this.background = AppColors.warningPill,
    this.color = const Color(0xFF8A5300),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

/// White upload card: bare icon, title, hint, and light filled "Choose file" button.
class KycUploadCard extends StatelessWidget {
  final String icon;
  final String title;
  final String hint;
  final VoidCallback? onChooseFile;

  const KycUploadCard({
    super.key,
    required this.icon,
    required this.title,
    required this.hint,
    this.onChooseFile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          AppIcon(icon, size: 44, color: AppColors.primary50),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 17,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hint,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
          ),
          const SizedBox(height: 18),
          Material(
            color: const Color(0xFFF0F5FA),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: onChooseFile ?? () {},
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                child: Text(
                  'Choose file',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
