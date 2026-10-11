import '../models/user_profile.dart';

abstract class UserRepository {
  Future<UserProfile> getCurrentUser();
}

class MockUserRepository implements UserRepository {
  @override
  Future<UserProfile> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const UserProfile(
      name: 'Cynthia',
      framelaId: 'FRM48291380',
      isKycVerified: true,
    );
  }
}