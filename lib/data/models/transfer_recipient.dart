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
}