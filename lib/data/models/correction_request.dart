class CorrectionRequest {
  final String requestType;
  final String currentValue;
  final String requestedValue;
  final String reason;
  final String documentName;
  final String reference;
  final String status;
  final String title;
  final String? extraDetail;

  const CorrectionRequest({
    required this.requestType,
    required this.currentValue,
    required this.requestedValue,
    required this.reason,
    this.documentName = 'Attached',
    this.reference = 'FRM-PI-2048',
    this.status = 'Under review',
    required this.title,
    this.extraDetail,
  });
}
