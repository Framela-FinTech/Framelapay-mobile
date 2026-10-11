class UserProfile {
  final String name;
  final String framelaId;
  final bool isKycVerified;

  const UserProfile({
    required this.name,
    required this.framelaId,
    this.isKycVerified = false,
  });
}