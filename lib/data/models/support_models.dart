class HelpArticle {
  final String title;
  final String category;
  final String body;

  const HelpArticle({
    required this.title,
    required this.category,
    required this.body,
  });
}

class SupportRequest {
  final String reference;
  final String subject;
  final String status;

  const SupportRequest({
    required this.reference,
    required this.subject,
    required this.status,
  });
}
