import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_icon.dart';

/// Section header label (e.g. IDENTITY, CONTACT DETAILS, ADDRESS)
class PersonalInfoSectionHeader extends StatelessWidget {
  final String label;

  const PersonalInfoSectionHeader(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: AppColors.neutral60,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// A row inside the Personal Information card
class PersonalInfoTile extends StatelessWidget {
  final String iconName;
  final String label;
  final String value;
  final String? actionText;
  final VoidCallback? onActionTap;
  final Color actionColor;

  const PersonalInfoTile({
    super.key,
    required this.iconName,
    required this.label,
    required this.value,
    this.actionText,
    this.onActionTap,
    this.actionColor = AppColors.accentYellow,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.iconTileSoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: AppIcon(
                iconName,
                size: 20,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.neutral60,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          if (actionText != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onActionTap,
              child: Text(
                actionText!,
                style: TextStyle(
                  color: actionColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Step subtitle (e.g. "STEP 1 OF 3")
class StepSubtitle extends StatelessWidget {
  final String text;

  const StepSubtitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: AppColors.neutral60,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

/// Bottom container for action buttons
class BottomBar extends StatelessWidget {
  final Widget child;

  const BottomBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      child: child,
    );
  }
}

/// Supporting document upload box
class UploadBox extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? attachedFileName;
  final VoidCallback onChooseFile;

  const UploadBox({
    super.key,
    required this.title,
    required this.subtitle,
    this.attachedFileName,
    required this.onChooseFile,
  });

  @override
  Widget build(BuildContext context) {
    final hasFile = attachedFileName != null;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasFile ? AppColors.success : AppColors.divider,
          width: hasFile ? 1.5 : 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: hasFile ? AppColors.successSoft : AppColors.iconTileSoft,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                hasFile ? Icons.check_circle_outline : Icons.cloud_upload_outlined,
                size: 28,
                color: hasFile ? AppColors.success : AppColors.primary40,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            hasFile ? attachedFileName! : title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hasFile ? 'File attached successfully' : subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: hasFile ? AppColors.success : AppColors.neutral60,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 18),
          InkWell(
            onTap: onChooseFile,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.divider, width: 1),
              ),
              child: Text(
                hasFile ? 'Replace file' : 'Choose file',
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Key-value row inside review / details cards
class ReviewDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool showDivider;

  const ReviewDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.neutral60,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 16),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.divider,
          ),
      ],
    );
  }
}

/// 3-step timeline indicator shown on Request Status screen
class TimelineStepper extends StatelessWidget {
  final int activeStep; // 0 = request received, 1 = verification review, 2 = decision and profile update

  const TimelineStepper({
    super.key,
    this.activeStep = 1,
  });

  @override
  Widget build(BuildContext context) {
    final steps = [
      ('Request received', const Color(0xFF16A34A)),
      ('Verification review', const Color(0xFFD97706)),
      ('Decision and profile update', AppColors.divider),
    ];

    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isCompleted = index < activeStep;
        final isCurrent = index == activeStep;
        final isLast = index == steps.length - 1;

        Color dotColor;
        if (isCompleted) {
          dotColor = const Color(0xFF16A34A);
        } else if (isCurrent) {
          dotColor = const Color(0xFFD97706);
        } else {
          dotColor = AppColors.divider;
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 24,
                    color: AppColors.divider,
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Text(
                step.$1,
                style: TextStyle(
                  color: (isCompleted || isCurrent)
                      ? AppColors.primaryDark
                      : AppColors.neutral60,
                  fontSize: 13,
                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
