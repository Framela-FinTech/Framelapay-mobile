import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../data/models/processing_step.dart';
import 'widgets/processing_timeline.dart';
import '../../../data/models/transfer_auth_flow.dart';

// Figma uses a lighter blue behind the spinner than in the closing notice.

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
                  color: AppColors.infoSoft,
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
              ProcessingTimeline(steps),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.infoPanel,
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
}
