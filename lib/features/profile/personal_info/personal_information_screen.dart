import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/repositories/user_repository.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';
import 'personal_info_widgets.dart';

/// Personal Information Hub screen.
/// Matches Row 0, Frame 0 of the `Personal Information Edit.png` Figma board.
class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final UserRepository _repo = MockUserRepository();
  UserProfile? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _repo.getCurrentUser();
    if (!mounted) return;
    setState(() {
      _user = user;
      _loading = false;
    });
  }

  void _showEditEmailSheet(UserProfile user) {
    final controller = TextEditingController(text: user.email);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Edit Email Address',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Email address',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.neutral60,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.inputFill,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryDark),
                ),
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              'Save Email',
              onPressed: () async {
                final newEmail = controller.text.trim();
                if (newEmail.isNotEmpty) {
                  final updated = user.copyWith(email: newEmail);
                  await _repo.updateCurrentUser(updated);
                  if (mounted) {
                    setState(() => _user = updated);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Email address updated')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditPhoneSheet(UserProfile user) {
    final controller = TextEditingController(text: user.phoneNumber);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Edit Phone Number',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Phone number',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.neutral60,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.inputFill,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryDark),
                ),
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              'Save Phone Number',
              onPressed: () async {
                final newPhone = controller.text.trim();
                if (newPhone.isNotEmpty) {
                  final updated = user.copyWith(phoneNumber: newPhone);
                  await _repo.updateCurrentUser(updated);
                  if (mounted) {
                    setState(() => _user = updated);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Phone number updated')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;

    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Personal Information'),
      body: SafeArea(
        child: _loading || user == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Photo with change trigger
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.changePhoto,
                        ),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 84,
                                  height: 84,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE2E8F0),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.person_outline,
                                      size: 44,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: AppColors.accentYellow,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 15,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Tap your photo to change it',
                              style: TextStyle(
                                color: AppColors.neutral60,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Section 1: IDENTITY
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: PersonalInfoSectionHeader('IDENTITY'),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.divider, width: 1),
                      ),
                      child: Column(
                        children: [
                          PersonalInfoTile(
                            iconName: 'folder-user',
                            label: 'Full name',
                            value: user.name,
                            actionText: 'Request correction',
                            onActionTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.requestNameCorrection,
                            ),
                          ),
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: AppColors.divider,
                          ),
                          PersonalInfoTile(
                            iconName: 'calendar',
                            label: 'Date of birth',
                            value: user.dateOfBirth,
                            actionText: 'Request correction',
                            onActionTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.requestDobCorrection,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Section 2: CONTACT DETAILS
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: PersonalInfoSectionHeader('CONTACT DETAILS'),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.divider, width: 1),
                      ),
                      child: Column(
                        children: [
                          PersonalInfoTile(
                            iconName: 'mail',
                            label: 'Email address',
                            value: user.email,
                            actionText: 'Edit',
                            onActionTap: () => _showEditEmailSheet(user),
                          ),
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: AppColors.divider,
                          ),
                          PersonalInfoTile(
                            iconName: 'phone',
                            label: 'Phone number',
                            value: user.phoneNumber,
                            actionText: 'Edit',
                            onActionTap: () => _showEditPhoneSheet(user),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Section 3: ADDRESS
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: PersonalInfoSectionHeader('ADDRESS'),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.divider, width: 1),
                      ),
                      child: Column(
                        children: [
                          PersonalInfoTile(
                            iconName: 'location',
                            label: 'Residential address',
                            value: user.address,
                            actionText: 'Edit',
                            onActionTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.editResidentialAddress,
                            ),
                          ),
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: AppColors.divider,
                          ),
                          PersonalInfoTile(
                            iconName: 'globe',
                            label: 'Country / Region',
                            value: user.country,
                          ),
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: AppColors.divider,
                          ),
                          PersonalInfoTile(
                            iconName: 'bank',
                            label: 'City',
                            value: user.city,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Bottom notice banner
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.infoNotice,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryDark,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.shield_outlined,
                                size: 14,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Changes to verified details may require review.',
                              style: TextStyle(
                                color: AppColors.primaryDark,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
