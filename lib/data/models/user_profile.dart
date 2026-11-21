class UserProfile {
  final String name;
  final String framelaId;
  final bool isKycVerified;
  final String dateOfBirth;
  final String email;
  final String phoneNumber;
  final String address;
  final String country;
  final String state;
  final String city;
  final String postalCode;

  const UserProfile({
    required this.name,
    required this.framelaId,
    this.isKycVerified = false,
    this.dateOfBirth = '14 Mar 1995',
    this.email = 'cynthia@gmail.com',
    this.phoneNumber = '+234 803 123 4567',
    this.address = '12 Adetokunbo Ademola Street, Victoria Island',
    this.country = 'Nigeria',
    this.state = 'Lagos',
    this.city = 'Lagos',
    this.postalCode = '101241',
  });

  UserProfile copyWith({
    String? name,
    String? framelaId,
    bool? isKycVerified,
    String? dateOfBirth,
    String? email,
    String? phoneNumber,
    String? address,
    String? country,
    String? state,
    String? city,
    String? postalCode,
  }) {
    return UserProfile(
      name: name ?? this.name,
      framelaId: framelaId ?? this.framelaId,
      isKycVerified: isKycVerified ?? this.isKycVerified,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
    );
  }
}
