import '../models/user_profile.dart';

abstract class UserRepository {
  Future<UserProfile> getCurrentUser();
  Future<void> updateCurrentUser(UserProfile user);
}

class MockUserRepository implements UserRepository {
  static UserProfile _currentUser = const UserProfile(
    name: 'Cynthia Nkechi',
    framelaId: 'FRM-482913',
    isKycVerified: true,
    dateOfBirth: '14 Mar 1995',
    email: 'cynthia@gmail.com',
    phoneNumber: '+234 803 123 4567',
    address: '12 Adetokunbo Ademola Street, Victoria Island',
    country: 'Nigeria',
    state: 'Lagos',
    city: 'Lagos',
    postalCode: '101241',
  );

  @override
  Future<UserProfile> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _currentUser;
  }

  @override
  Future<void> updateCurrentUser(UserProfile user) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _currentUser = user;
  }
}
