import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_icon.dart';

/// Reusable presentational pieces for the fiat transfer flows (Bank / Card /
/// Wallet). Centralizing these keeps every screen on the same design tokens
/// (radii, fills, paddings) and keeps each screen file short enough to avoid
/// overflow at 360x640.

/// Screen heading (20 w700) with a textGrey helper line 6 below it.
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
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
        if (helper != null) ...[
          const SizedBox(height: 6),
          Text(helper!,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
        ],
      ],
    );
  }
}

/// Section title (15 w700).
class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15));
  }
}

/// Small field label (13 w600) shown above inputs/dropdowns.
class FieldLabel extends StatelessWidget {
  final String text;
  const FieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
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
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        counterText: '',
        prefixText: prefixText,
        prefixStyle: const TextStyle(fontSize: 14, color: Colors.black),
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: AppColors.textGrey),
        filled: true,
        fillColor: AppColors.inputFill,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
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
          size: 20, color: AppColors.textGrey),
      style: const TextStyle(fontSize: 14, color: Colors.black),
      hint: Text(hint,
          style: const TextStyle(fontSize: 14, color: AppColors.textGrey)),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.inputFill,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
          Row(
            children: [
              Text(value,
                  style: TextStyle(
                      fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
                      fontSize: 13)),
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
    Color bg;
    Color fg;
    switch (type) {
      case NoticeType.warning:
        bg = const Color(0xFFFFF4E5);
        fg = Colors.black87;
        break;
      case NoticeType.success:
        bg = const Color(0xFFE3F7EC);
        fg = AppColors.success;
        break;
      case NoticeType.info:
        bg = AppColors.inputFill;
        fg = AppColors.textGrey;
        break;
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              children: [
                if (type == NoticeType.warning)
                  const AppIcon('info-triangle',
                      size: 14, color: Colors.orange),
                if (type == NoticeType.warning) const SizedBox(width: 6),
                Text(title!,
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 12, color: fg)),
              ],
            ),
            const SizedBox(height: 4),
          ],
          Text(text, style: TextStyle(fontSize: 11, color: fg)),
        ],
      ),
    );
  }
}

/// Rate/resend timer pill (accentYellow @ ~15%, radius 12, padding 10/6).
class TimerPill extends StatelessWidget {
  final String text;
  const TimerPill(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accentYellow.withOpacity(0.15),
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
    leading: const BackButton(color: Colors.black),
    title: Text(title, style: const TextStyle(color: Colors.black, fontSize: 16)),
  );
}
