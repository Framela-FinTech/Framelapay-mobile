import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../data/models/processing_step.dart';
import '../../../data/models/transfer_auth_flow.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Processing Transfer',
            style: TextStyle(color: Colors.black, fontSize: 16)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              const SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                    strokeWidth: 4, color: AppColors.accentYellow),
              ),
              const SizedBox(height: 20),
              const Text("We're processing your transfer",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
              const SizedBox(height: 6),
              const Text('You can safely close the app.',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
              const SizedBox(height: 32),
              ...widget.flow.processingSteps.map(_step),
              const SizedBox(height: 24),
              const Text("We'll notify you once the transfer is completed.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _step(ProcessingStep step) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIcon(
              step.done ? 'check-circle' : 'radio-button',
              style: step.done ? AppIconStyle.bold : AppIconStyle.linear,
              color: step.done ? AppColors.success : AppColors.textGrey,
              size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(step.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14)),
                    ),
                    if (step.time.isNotEmpty)
                      Text(step.time,
                          style: const TextStyle(
                              color: AppColors.textGrey, fontSize: 11)),
                  ],
                ),
                Text(step.subtitle,
                    style: const TextStyle(
                        color: AppColors.textGrey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
