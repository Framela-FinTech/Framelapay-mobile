import 'processing_step.dart';

/// Neutral continuation threaded through the shared auth gate
/// (fingerprint / passcode) and the processing screen.
///
/// This is what lets those three screens be shared by BOTH the stablecoin
/// and fiat flows without either knowing about the other's model:
///   - [processingSteps] are rendered by the processing screen,
///   - then it navigates to [completionRoute] with [completionArgs].
///
/// Stablecoin builds this with its own steps + the stablecoin transaction
/// details route/recipient; fiat builds it with the fiat steps + the
/// "Transfer completed" route/`FiatTransfer`.
class TransferAuthFlow {
  final List<ProcessingStep> processingSteps;
  final String completionRoute;
  final Object? completionArgs;

  const TransferAuthFlow({
    required this.processingSteps,
    required this.completionRoute,
    this.completionArgs,
  });
}
