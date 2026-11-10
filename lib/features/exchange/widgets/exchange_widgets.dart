import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/exchange_rate.dart';

/// Segmented 1D / 7D / 1M / 3M control. Grey track, pale-blue active pill.
class RangeTabs extends StatelessWidget {
  final RateRange selected;
  final ValueChanged<RateRange> onChanged;
  const RangeTabs({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.pageGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          for (final range in RateRange.values)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(range),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: range == selected
                        ? AppColors.infoHalo
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    range.label,
                    style: TextStyle(
                      color: range == selected
                          ? AppColors.chartLine
                          : AppColors.primaryDark,
                      fontSize: 14,
                      fontWeight: range == selected
                          ? FontWeight.w700
                          : FontWeight.w500,
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

/// Green or red movement pill, e.g. "▲ +1.0% (7D)".
class ChangePill extends StatelessWidget {
  final String text;
  final bool isUp;

  /// Pills inside a list row are plain text; the headline one has a fill.
  final bool filled;

  const ChangePill(this.text,
      {super.key, required this.isUp, this.filled = true});

  @override
  Widget build(BuildContext context) {
    final colour = isUp ? AppColors.success : AppColors.error;
    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(isUp ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            size: 18, color: colour),
        Text(text,
            style: TextStyle(
                color: colour, fontSize: 13, fontWeight: FontWeight.w700)),
      ],
    );
    if (!filled) return row;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isUp ? AppColors.successSoft : AppColors.error.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: row,
    );
  }
}

/// Flag + code + name, used on both sides of a pair.
class CurrencyBadge extends StatelessWidget {
  final String code;
  final String name;
  final String country;
  const CurrencyBadge(
      {super.key,
      required this.code,
      required this.name,
      required this.country});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipOval(
          child:
              CountryFlag.fromCountryCode(country, height: 38, width: 38),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(code,
                  style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 17,
                      fontWeight: FontWeight.w800)),
              Text(name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: AppColors.textGrey, fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }
}
