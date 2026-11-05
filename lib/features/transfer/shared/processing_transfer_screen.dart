import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../data/models/processing_step.dart';
import '../../../data/models/transfer_auth_flow.dart';

/// Figma's pale blue, used for the spinner halo and the closing notice.
const Color _paleBlue = Color(0xFFDCE7F7);

/// Shared "Processing Transfer" screen for BOTH the stablecoin and fiat flows.
///
/// Generalized to render whatever [ProcessingStep] list the flow supplies and
/// then navigate to the flow's completion route. The chrome (AppBar + back)
/// is unchanged from the original stablecoin screen so that flow behaves
/// exactly as before; only the data source and the completion target are now
/// driven by [TransferAuthFlow].
class ProcessingTransferScreen extends StatefulWidget {
  final TransferAuthFlow flow;
  const ProcessingTransferScreen({super.key, required this.flow});

  @override
  State<ProcessingTransferScreen> createState() =>
      _ProcessingTransferScreenState();
}

class _ProcessingTransferScreenState extends State<ProcessingTransferScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          widget.flow.completionRoute,
          arguments: widget.flow.completionArgs,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final steps = widget.flow.processingSteps;
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: AppColors.primaryDark),
        title: const Text('Processing Transfer',
            style: TextStyle(
                color: AppColors.primaryDark,
                fontSize: 20,
                fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: const BoxDecoration(
                  color: _paleBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.sync,
                    size: 54, color: AppColors.primaryDark),
              ),
              const SizedBox(height: 20),
              const Text("We're Processing Your Transfer",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w800,
                      fontSize: 24)),
              const SizedBox(height: 6),
              const Text('You can safely close the app.',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 15)),
              const SizedBox(height: 26),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppShadows.card,
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < steps.length; i++)
                      _step(steps[i], isLast: i == steps.length - 1),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _paleBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline,
                        size: 24, color: AppColors.primaryDark),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "You can safely close the app. We'll notify you when the transfer is completed.",
                        style: TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 15,
                            height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
