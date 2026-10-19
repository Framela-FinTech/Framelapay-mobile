import '../models/support_models.dart';

abstract class SupportRepository {
  Future<List<HelpArticle>> getArticles();
  Future<List<SupportRequest>> getRequests();
}

class MockSupportRepository implements SupportRepository {
  @override
  Future<List<HelpArticle>> getArticles() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return const [
      HelpArticle(
        title: 'Why is my transfer processing?',
        category: 'Transfers',
        body:
            'Track the current step from Activity → transaction → View Transfer Progress. If the expected delivery time has passed, report a problem from that transaction so our team can help.',
      ),
      HelpArticle(
        title: 'How do I change my transaction PIN?',
        category: 'Security',
        body:
            'Open Profile → Security → Transaction PIN. Verify your current PIN, create a new six-digit PIN and confirm it. Your app sign-in passcode is separate.',
      ),
      HelpArticle(
        title: 'How do I remove a lost device?',
        category: 'Security',
        body:
            'Open Profile → Security → Trusted Devices, select the lost device and choose Remove Device. Verify the request with your transaction PIN.',
      ),
      HelpArticle(
        title: 'How do I download a statement?',
        category: 'Documents',
        body:
            'Open Profile → Statements & Receipts → Account Statements. Select a wallet and period, then generate and download your statement.',
      ),
    ];
  }

  @override
  Future<List<SupportRequest>> getRequests() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return const [
      SupportRequest(
        reference: 'FRM-10429',
        subject: 'Open · Account enquiry',
        status: 'Open',
      ),
    ];
  }
}
