import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/widgets/app_icon.dart';

class ChooseNetworkScreen extends StatefulWidget {
  const ChooseNetworkScreen({super.key});

  @override
  State<ChooseNetworkScreen> createState() => _ChooseNetworkScreenState();
}

class _ChooseNetworkScreenState extends State<ChooseNetworkScreen> {
  String _selected = 'ethereum';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: AppColors.primaryDark),
        title: const Text('Choose Network',
            style: TextStyle(
                color: AppColors.primaryDark,
                fontSize: 20,
                fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Choose network',
                  style: TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 17)),
              const SizedBox(height: 6),
              const Text(
                'Select the blockchain network you want to use for this transfer.',
                style: TextStyle(color: AppColors.textGrey, fontSize: 14),
              ),
              const SizedBox(height: 18),
              _networkTile('ethereum', 'Ethereum', 'Ethereum Network'),
              _networkTile('base', 'Base', 'Base Network'),
              _networkTile('solana', 'Solana', 'Solana Network'),
              const SizedBox(height: 8),
              // Cream caution panel: bold lead line, grey detail beneath.
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.warningSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: AppColors.accentYellow, size: 24),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Make sure the recipient supports this network.',
                            style: TextStyle(
                                color: AppColors.primaryDark,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Sending on an unsupported network may result in permanent loss of funds.',
                            style: TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(56),
                  ),
                  onPressed: () => Navigator.pushNamed(
                      context, AppRoutes.sendStablecoinRecipient),
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _networkTile(String value, String title, String subtitle) {
    final selected = _selected == value;
    return InkWell(
      onTap: () => setState(() => _selected = value),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppShadows.card,
          border: Border.all(
            color: selected ? AppColors.accentYellow : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Network brand marks aren't in the icon pack yet.
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const AppIcon('data',
                  size: 24, color: AppColors.primaryDark),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 17)),
                  Text(subtitle,
                      style: const TextStyle(
                          color: AppColors.textGrey, fontSize: 15)),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selected,
              activeColor: AppColors.accentYellow,
              onChanged: (v) => setState(() => _selected = v!),
            ),
          ],
        ),
      ),
    );
  }
}