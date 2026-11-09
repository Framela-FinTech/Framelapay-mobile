enum RecipientType { framelaUser, externalWallet }

class TransferRecipient {
  final RecipientType type;
  final String? name; // FramelaPay user's display name
  final String? handle; // e.g. @cynthia
  final String walletAddress;

  const TransferRecipient({
    required this.type,
    this.name,
    this.handle,
    required this.walletAddress,
  });

  bool get isFramelaUser => type == RecipientType.framelaUser;

  /// Truncated address for receipts and summaries, e.g. "0x8a71....94cd".
  String get shortAddress {
    if (walletAddress.length <= 12) return walletAddress;
    return '${walletAddress.substring(0, 6)}....'
        '${walletAddress.substring(walletAddress.length - 4)}';
  }

  /// Name to show for the payee, whichever kind of recipient this is.
  String get displayName =>
      isFramelaUser ? (name ?? handle ?? 'FramelaPay user') : shortAddress;
}