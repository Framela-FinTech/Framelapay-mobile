import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/widgets/app_icon.dart';
import '../shared/widgets/asset_network_bar.dart';

/// Stablecoin step: pick the FramelaPay user to send to.
class FindFramelaUserScreen extends StatelessWidget {
  const FindFramelaUserScreen({super.key});

  final List<Map<String, String>> _contacts = const [
    {'name': 'Cynthia Nkechi', 'handle': '@cynthian'},
    {'name': 'Tunde Adedayo', 'handle': '@tundea'},
    {'name': 'Daniel Amara', 'handle': '@amara'},
    {'name': 'Temi Olayinka', 'handle': '@temi'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: AppColors.primaryDark),
        title: const Text('Enter Recipient',
            style: TextStyle(
                color: AppColors.primaryDark,
                fontSize: 20,
                fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AssetNetworkBar(onChange: () => Navigator.pop(context)),
              const SizedBox(height: 26),
              const Text('Find a FramelaPay user',
                  style: TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 17)),
              const SizedBox(height: 4),
              const Text(
                'Send USDC instantly to another FramelaPay user using their username, email or phone number.',
                style: TextStyle(color: AppColors.textGrey, fontSize: 15),
              ),
              const SizedBox(height: 18),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search by username, email or phone number',
                  hintStyle: const TextStyle(
                      color: AppColors.textGrey, fontSize: 15),
                  prefixIcon: const AppIcon('search',
                      size: 20, color: AppColors.textGrey),
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent contacts',
                      style: TextStyle(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 17)),
                  GestureDetector(
                    onTap: () {},
                    child: const Text('View all',
                        style: TextStyle(
                            color: AppColors.accentYellow,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ..._contacts.map((c) => _contactCard(context, c)),
              const SizedBox(height: 10),
              _inviteBanner(),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(56),
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.enterAmount),
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contactCard(BuildContext context, Map<String, String> contact) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.pushNamed(context, AppRoutes.enterAmount,
            arguments: contact),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: AppShadows.card,
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.inputFill,
                child: AppIcon('folder-user',
                    size: 24, color: AppColors.primaryDark),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(contact['name']!,
                        style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w600,
                            fontSize: 17)),
                    Text(contact['handle']!,
                        style: const TextStyle(
                            color: AppColors.textGrey, fontSize: 14)),
                  ],
                ),
              ),
              const AppIcon('chevron-right',
                  size: 22, color: AppColors.primaryDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inviteBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Figma: a pale blue panel, distinct from the white contact cards.
        color: AppColors.infoPanel,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_add_alt_1,
                size: 24, color: AppColors.primaryDark),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('New to FramelaPay?',
                    style: TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 17)),
                SizedBox(height: 2),
                Text('Invite a friend to join and get rewarded.',
                    style: TextStyle(
                        color: AppColors.textGrey, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
