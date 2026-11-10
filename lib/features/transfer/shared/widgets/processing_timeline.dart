import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../data/models/processing_step.dart';

/// The step timeline: a status marker and connector down the left, the step's
/// title, timestamp and subtitle on the right.
///
/// Shared by the post-confirmation Processing Transfer screen and the
/// Transfer Progress screen reached from Transfer Status.
class ProcessingTimeline extends StatelessWidget {
  final List<ProcessingStep> steps;

  /// Wraps the rows in the white shadowed card both screens draw.
  final bool card;

  const ProcessingTimeline(this.steps, {super.key, this.card = true});

  @override
  Widget build(BuildContext context) {
    final rows = Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          _step(steps[i], isLast: i == steps.length - 1),
      ],
    );
    if (!card) return rows;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.card,
      ),
      child: rows,
    );
  }

  /// One timeline row: status marker and its connector on the left, the
  /// step's text on the right.
  Widget _step(ProcessingStep step, {required bool isLast}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              _marker(step),
              if (!isLast)
                Expanded(
                  child: Container(width: 1, color: AppColors.divider),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(step.title,
                            style: const TextStyle(
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.w700,
                                fontSize: 17)),
                      ),
                      if (step.time.isNotEmpty)
                        Text(step.time,
                            style: const TextStyle(
                                color: AppColors.textGrey, fontSize: 15)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(step.subtitle,
                      style: const TextStyle(
                          color: AppColors.textGrey, fontSize: 15)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _marker(ProcessingStep step) {
    if (step.done) {
      return Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(
            color: AppColors.success, shape: BoxShape.circle),
        child: const Icon(Icons.check, size: 18, color: Colors.white),
      );
    }
    if (step.inProgress) {
      return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            color: AppColors.accentYellow.withValues(alpha: 0.55),
            shape: BoxShape.circle),
        child: const Icon(Icons.schedule,
            size: 18, color: AppColors.primaryDark),
      );
    }
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.divider, width: 1.5),
      ),
    );
  }
}
