import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';

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
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Send Stablecoin',
            style: TextStyle(color: Colors.black, fontSize: 16)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text('Find a FramelaPay user',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
              const SizedBox(height: 6),
              const Text(
                'Send USDC instantly to another FramelaPay user using their username, email or phone number.',
                style: TextStyle(color: AppColors.textGrey, fontSize: 12),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search by username, email or phone number',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: AppColors.inputFill,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent contacts',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)),
                  TextButton(onPressed: () {}, child: const Text('View all')),
                ],
              ),
              ..._contacts.map((c) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                        backgroundColor: AppColors.inputFill,
                        child:
                            Icon(Icons.person, color: AppColors.primaryDark)),
                    title: Text(c['name']!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: Text(c['handle']!,
                        style: const TextStyle(
                            color: AppColors.textGrey, fontSize: 12)),
                    trailing: const Icon(Icons.chevron_right,
                        color: AppColors.textGrey),
                    onTap: () => Navigator.pushNamed(
                        context, AppRoutes.enterAmount,
                        arguments: c),
                  )),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('New to FramelaPay?',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                          SizedBox(height: 2),
                          Text('Invite a friend to join and get rewarded.',
                              style: TextStyle(
                                  color: AppColors.textGrey, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  foregroundColor: Colors.white,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.enterAmount),
                child: const Text('Continue'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}