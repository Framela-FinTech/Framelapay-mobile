import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_icon.dart';

/// Reusable presentational pieces for the fiat transfer flows (Bank / Card /
/// Wallet). Centralizing these keeps every screen on the same design tokens
/// (radii, fills, paddings) and keeps each screen file short enough to avoid
/// overflow at 360x640.

/// Screen heading (24 w800) with a textGrey helper line below it.
class ScreenHeading extends StatelessWidget {
  final String title;
  final String? helper;
  const ScreenHeading(this.title, {super.key, this.helper});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w800,
                fontSize: 24)),
        if (helper != null) ...[
          const SizedBox(height: 4),
          Text(helper!,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 15)),
        ],
      ],
    );
  }
}

/// Section title (17 w700).
class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w700,
            fontSize: 17));
  }
}

/// Small field label (15 w600) shown above inputs/dropdowns.
class FieldLabel extends StatelessWidget {
  final String text;
  const FieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: const TextStyle(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w600,
              fontSize: 15)),
    );
  }
}

/// Filled text input (radius 12, inputFill, no border).
class AppTextInput extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? prefixText;
  final int? maxLength;
  final bool obscureText;
  const AppTextInput({
    super.key,
    this.hint,
    this.controller,
    this.keyboardType,
    this.prefixText,
    this.maxLength,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 16, color: AppColors.primaryDark),
      decoration: InputDecoration(
        counterText: '',
        prefixText: prefixText,
        prefixStyle:
            const TextStyle(fontSize: 16, color: AppColors.primaryDark),
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 16, color: AppColors.textGrey),
        filled: true,
        // Figma: white field with a hairline outline, not a grey fill.
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.all(16),
        border: _fieldBorder(),
        enabledBorder: _fieldBorder(),
        focusedBorder: _fieldBorder(focused: true),
      ),
    );
  }
}

/// Shared outline for the white form fields.
OutlineInputBorder _fieldBorder({bool focused = false}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(
      color: focused ? AppColors.primaryDark : AppColors.divider,
    ),
  );
}

/// Filled dropdown (radius 12, inputFill, trailing arrow) over String items.
class AppDropdownField extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  const AppDropdownField({
    super.key,
    required this.hint,
    required this.items,
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      icon: const AppIcon('chevron-down',
          size: 22, color: AppColors.primaryDark),
      style: const TextStyle(fontSize: 16, color: AppColors.primaryDark),
      hint: Text(hint,
          style: const TextStyle(fontSize: 16, color: AppColors.textGrey)),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.all(16),
        border: _fieldBorder(),
        enabledBorder: _fieldBorder(),
        focusedBorder: _fieldBorder(focused: true),
      ),
      items: items
          .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
    );
  }
}

/// A key/value summary row (label 13 textGrey, value 13 w600; bold = w700).
class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final Widget? trailing;
  const SummaryRow(this.label, this.value,
      {super.key, this.bold = false, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 15)),
          Row(
            children: [
              Text(value,
                  style: TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: bold ? FontWeight.w800 : FontWeight.w700,
                      fontSize: 15)),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
        ],
      ),
    );
  }
}

enum NoticeType { info, warning, success }

/// Rounded notice banner (radius 12, padding 12) in info/warning/success tones.
class NoticeBanner extends StatelessWidget {
  final String text;
  final String? title;
  final NoticeType type;
  const NoticeBanner(this.text,
      {super.key, this.title, this.type = NoticeType.info});

  @override
  Widget build(BuildContext context) {
    late final Color bg;
    late final Color fg;
    late final IconData icon;
    switch (type) {
      case NoticeType.warning:
        bg = AppColors.warningSoft;
        fg = AppColors.primaryDark;
        icon = Icons.warning_amber_rounded;
      case NoticeType.success:
        bg = AppColors.successSoft;
        fg = AppColors.success;
        icon = Icons.check_circle_outline;
      case NoticeType.info:
        bg = AppColors.infoPanel;
        fg = AppColors.primaryDark;
        icon = Icons.error_outline;
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon,
              size: 22,
              color: type == NoticeType.warning
                  ? AppColors.accentYellow
                  : fg),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(title!,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: fg)),
                  const SizedBox(height: 2),
                ],
                Text(text,
                    style: TextStyle(
                        fontSize: 14, height: 1.35, color: fg)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Rate/resend timer pill on the soft caution fill (radius 12, padding 10/6).
class TimerPill extends StatelessWidget {
  final String text;
  const TimerPill(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.warningSoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer_outlined,
              size: 14, color: AppColors.primaryDark),
          const SizedBox(width: 6),
          Text(text,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark)),
        ],
      ),
    );
  }
}

/// Primary CTA: full width, height 56, dark bg + white fg (required on the
/// white-background fiat screens per the design rules).
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const PrimaryButton(this.label, {super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}

/// A white AppBar with a black back button and a plain-text title.
AppBar whiteAppBar(String title) {
  return AppBar(
    backgroundColor: AppColors.white,
    elevation: 0,
    leading: const BackButton(color: AppColors.primaryDark),
    title: Text(title,
        style: const TextStyle(
            color: AppColors.primaryDark,
            fontSize: 20,
            fontWeight: FontWeight.w700)),
  );
}
