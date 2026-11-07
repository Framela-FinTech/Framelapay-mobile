import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../data/models/fiat_transfer.dart';
import '../fiat/widgets/fiat_form_widgets.dart';

/// Screen 7 (Bank) — simulated redirect to the user's banking app.
/// Auto-advances to the payment-instruction screen after ~3s.
class BankRedirectScreen extends StatefulWidget {
  final FiatTransfer transfer;
  const BankRedirectScreen({super.key, required this.transfer});

  @override
  State<BankRedirectScreen> createState() => _BankRedirectScreenState();
}

class _BankRedirectScreenState extends State<BankRedirectScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.bankPaymentInstruction,
          arguments: widget.transfer,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: whiteAppBar('Bank Transfer'),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 24),
          // spaceBetween so the lock caption sits at the foot of the screen
          // rather than floating under the heading.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox.shrink(),
              Column(
                children: [
                  IconBadge(
                    icon: 'bank',
                    halo: AppColors.iconTileSoft,
                    size: 132,
                    glyphSize: 60,
                  ),
                  SizedBox(height: 24),
                  ScreenHeading(
                    'Redirecting you to your bank',
                    helper:
                        "You'll complete the transfer securely in your bank's app.",
                    center: true,
                  ),
                ],
              ),
              Column(
                children: [
                  AppIcon('lock', size: 20, color: AppColors.textGrey),
                  SizedBox(height: 8),
                  Text(
                      'You will return to Framela automatically after '
                      'completing the transfer',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: AppColors.textGrey, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
