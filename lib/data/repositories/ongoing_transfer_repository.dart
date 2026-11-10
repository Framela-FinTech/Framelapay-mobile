import '../models/ongoing_transfer.dart';
import '../models/processing_step.dart';

abstract class OngoingTransferRepository {
  Future<List<OngoingTransfer>> getOngoingTransfers();
}

class MockOngoingTransferRepository implements OngoingTransferRepository {
  @override
  Future<List<OngoingTransfer>> getOngoingTransfers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      OngoingTransfer(
        id: 't1',
        recipient: 'Amina Yusuf',
        amount: r'$150.00',
        method: 'Debit/Credit Card',
        startedAt: '12 Oct 2026 · 10:24',
        stage: OngoingStage.processing,
        youSend: r'$150.00',
        fee: r'$2.50',
        totalPayment: r'$152.50',
        recipientReceives: '₦235,125.00',
        reference: 'FRM-20261012-10427',
        destinationBank: 'Zenith Bank',
        accountNumber: '•••• 5678',
        steps: [
          ProcessingStep(
              title: 'Transfer initiated',
              subtitle: 'Completed · 10:24',
              done: true),
          ProcessingStep(
              title: 'Payment received',
              subtitle: 'Completed · 10:25',
              done: true),
          ProcessingStep(
              title: 'Compliance checks',
              subtitle: 'Completed · 10:26',
              done: true),
          ProcessingStep(
              title: 'Partner processing',
              subtitle: 'In progress',
              inProgress: true),
          ProcessingStep(title: 'Recipient payout', subtitle: 'Waiting'),
          ProcessingStep(title: 'Completed', subtitle: 'Waiting'),
        ],
      ),
      OngoingTransfer(
        id: 't2',
        recipient: 'Ken Okafor',
        amount: r'$500.00',
        method: 'Bank Transfer',
        startedAt: '12 Oct 2026 · 11:05',
        stage: OngoingStage.pendingPayment,
        youSend: r'$500.00',
        fee: r'$2.50',
        totalPayment: r'$502.50',
        recipientReceives: '₦783,750.00',
        reference: 'FRM-20261012-10429',
        destinationBank: 'GTBank',
        accountNumber: '•••• 6789',
        steps: [
          ProcessingStep(
              title: 'Transfer initiated',
              subtitle: 'Completed · 11:05',
              done: true),
          ProcessingStep(
              title: 'Payment received',
              subtitle: 'Waiting for your payment',
              inProgress: true),
          ProcessingStep(title: 'Compliance checks', subtitle: 'Waiting'),
          ProcessingStep(title: 'Partner processing', subtitle: 'Waiting'),
          ProcessingStep(title: 'Recipient payout', subtitle: 'Waiting'),
          ProcessingStep(title: 'Completed', subtitle: 'Waiting'),
        ],
      ),
    ];
  }
}
