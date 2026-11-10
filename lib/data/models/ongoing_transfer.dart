import 'processing_step.dart';

/// Where an in-flight transfer currently sits.
enum OngoingStage { processing, pendingPayment }

extension OngoingStageLabel on OngoingStage {
  /// The pill on the Transfer Status card.
  String get label => switch (this) {
        OngoingStage.processing => 'Processing',
        OngoingStage.pendingPayment => 'Pending payment',
      };

  /// The grey sub-row under the amount.
  String get detail => switch (this) {
        OngoingStage.processing => 'Partner processing',
        OngoingStage.pendingPayment => 'Waiting for your payment',
      };
}

/// A transfer that has not settled yet, shown on Transfer Status.
class OngoingTransfer {
  final String id;
  final String recipient;
  final String amount;
  final String method;
  final String startedAt;
  final OngoingStage stage;

  /// Money detail for the Transfer Details screen.
  final String youSend;
  final String fee;
  final String totalPayment;
  final String recipientReceives;
  final String reference;
  final String destinationBank;
  final String accountNumber;

  final List<ProcessingStep> steps;

  const OngoingTransfer({
    required this.id,
    required this.recipient,
    required this.amount,
    required this.method,
    required this.startedAt,
    required this.stage,
    required this.youSend,
    required this.fee,
    required this.totalPayment,
    required this.recipientReceives,
    required this.reference,
    required this.destinationBank,
    required this.accountNumber,
    required this.steps,
  });

  /// e.g. "Debit/Credit Card · 12 Oct 2026 · 10:24"
  String get subtitle => '$method · $startedAt';
}
