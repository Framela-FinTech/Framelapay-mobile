import 'transfer_method.dart';
import 'fiat_beneficiary.dart';

/// The single value object threaded through every fiat transfer screen
/// (Bank, Card, Wallet). Each screen reads what it needs and passes a
/// `copyWith`-updated copy to the next route — the same pattern the
/// stablecoin flow uses with `TransferRecipient`.
///
/// All business numbers (amounts, fee, rate) originate from mock repositories
/// and are carried here, never hard-coded inside widgets.
class FiatTransfer {
  final TransferMethod method;

  final String senderName;

  // Send side (what the user pays).
  final String sendCurrencyCode; // USD
  final String sendCurrencySymbol; // $
  final double sendAmount; // 500.00

  // Receive side (what the recipient gets).
  final String receiveCurrencyCode; // NGN
  final String receiveCurrencySymbol; // ₦
  final double receiveAmount; // 810250.00

  final double fee; // 2.50, in send currency
  final double fxRate; // 1620.50 receive units per 1 send unit

  final FiatBeneficiary? beneficiary;
  final String purpose;
  final String status;
  final String transactionId;
  final String dateTime;
  final String deliveryEstimate;

  /// Source wallet code when [method] is wallet (e.g. "USD").
  final String? sourceWalletCode;

  /// Card descriptor when [method] is card (e.g. "Visa ****4242").
  final String? cardLabel;

  const FiatTransfer({
    required this.method,
    this.senderName = 'Cynthia Nkechi',
    this.sendCurrencyCode = 'USD',
    this.sendCurrencySymbol = r'$',
    this.sendAmount = 500.00,
    this.receiveCurrencyCode = 'NGN',
    this.receiveCurrencySymbol = '₦',
    this.receiveAmount = 810250.00,
    this.fee = 2.50,
    this.fxRate = 1620.50,
    this.beneficiary,
    this.purpose = 'Family support',
    this.status = 'Completed',
    this.transactionId = 'FRM123456789',
    this.dateTime = '17 May 2026, 10:45 AM',
    this.deliveryEstimate = 'Estimated Today',
    this.sourceWalletCode,
    this.cardLabel,
  });

  double get total => sendAmount + fee;

  String get formattedSendAmount => '$sendCurrencySymbol${_fmt(sendAmount)}';
  String get formattedReceiveAmount =>
      '$receiveCurrencySymbol${_fmt(receiveAmount)}';
  String get formattedFee => '$sendCurrencySymbol${_fmt(fee)}';
  String get formattedTotal => '$sendCurrencySymbol${_fmt(total)}';

  /// "1 USD = 1,620.50 NGN"
  String get formattedRate =>
      '1 $sendCurrencyCode = ${_fmt(fxRate)} $receiveCurrencyCode';

  String get methodLabel => method.label;

  FiatTransfer copyWith({
    TransferMethod? method,
    String? senderName,
    String? sendCurrencyCode,
    String? sendCurrencySymbol,
    double? sendAmount,
    String? receiveCurrencyCode,
    String? receiveCurrencySymbol,
    double? receiveAmount,
    double? fee,
    double? fxRate,
    FiatBeneficiary? beneficiary,
    String? purpose,
    String? status,
    String? transactionId,
    String? dateTime,
    String? deliveryEstimate,
    String? sourceWalletCode,
    String? cardLabel,
  }) {
    return FiatTransfer(
      method: method ?? this.method,
      senderName: senderName ?? this.senderName,
      sendCurrencyCode: sendCurrencyCode ?? this.sendCurrencyCode,
      sendCurrencySymbol: sendCurrencySymbol ?? this.sendCurrencySymbol,
      sendAmount: sendAmount ?? this.sendAmount,
      receiveCurrencyCode: receiveCurrencyCode ?? this.receiveCurrencyCode,
      receiveCurrencySymbol:
          receiveCurrencySymbol ?? this.receiveCurrencySymbol,
      receiveAmount: receiveAmount ?? this.receiveAmount,
      fee: fee ?? this.fee,
      fxRate: fxRate ?? this.fxRate,
      beneficiary: beneficiary ?? this.beneficiary,
      purpose: purpose ?? this.purpose,
      status: status ?? this.status,
      transactionId: transactionId ?? this.transactionId,
      dateTime: dateTime ?? this.dateTime,
      deliveryEstimate: deliveryEstimate ?? this.deliveryEstimate,
      sourceWalletCode: sourceWalletCode ?? this.sourceWalletCode,
      cardLabel: cardLabel ?? this.cardLabel,
    );
  }

  /// Thousands-separated amount with 2 decimals, e.g. 810250 -> "810,250.00".
  static String _fmt(double v) {
    final s = v.toStringAsFixed(2);
    final parts = s.split('.');
    final withCommas = parts[0].replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (m) => '${m[1]},',
    );
    return '$withCommas.${parts[1]}';
  }
}
