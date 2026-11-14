import 'package:flutter/material.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_icon.dart';
import '../../transfer/fiat/widgets/fiat_form_widgets.dart';

/// "Trusted Devices" — lists the user's paired devices.
class TrustedDevicesScreen extends StatelessWidget {
  const TrustedDevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Trusted Devices'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            children: [
              _deviceCard(
                context,
                name: 'iPhone 15',
                subtitle: 'Current device',
                isCurrent: true,
              ),
              _deviceCard(
                context,
                name: 'iPhone 13 — previous phone',
                subtitle: 'Previous device · Manage access',
                isCurrent: false,
              ),
              const SizedBox(height: 14),
              _infoNotice(
                'You can revoke a lost or previous phone from your new '
                'verified device. Pairing a new device does not '
                'automatically remove older devices.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _deviceCard(
    BuildContext context, {
    required String name,
    required String subtitle,
    required bool isCurrent,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, AppRoutes.deviceDetails,
            arguments: isCurrent),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.iconTileSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: AppIcon('mobile',
                      size: 20, color: AppColors.primaryDark),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 15)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: const TextStyle(
                            color: AppColors.textGrey, fontSize: 13)),
                  ],
                ),
              ),
              const AppIcon('chevron-right',
                  size: 18, color: AppColors.textGrey),
            ],
          ),
        ),
      ),
    );
  }
}

/// "Device Details" — shows the selected device with an option to remove it.
class DeviceDetailsScreen extends StatelessWidget {
  final bool current;
  const DeviceDetailsScreen({super.key, this.current = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Device Details'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
                child: Column(
                  children: [
                    _deviceBadge(),
                    const SizedBox(height: 18),
                    Text(current ? 'iPhone 15' : 'iPhone 13',
                        style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 22,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Text(current ? 'Current device' : 'Previous device',
                        style: const TextStyle(
                            color: AppColors.textGrey, fontSize: 14)),
                    const SizedBox(height: 28),
                    _infoNotice(
                      'Remove access if you no longer recognise or use '
                      'this device.',
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(56),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.removeDevice),
                  child: const Text('Remove Device',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Remove Device?" — enter a transaction PIN to confirm removal.
class RemoveDeviceScreen extends StatefulWidget {
  const RemoveDeviceScreen({super.key});

  @override
  State<RemoveDeviceScreen> createState() => _RemoveDeviceScreenState();
}

class _RemoveDeviceScreenState extends State<RemoveDeviceScreen> {
  final _pin = TextEditingController();

  @override
  void dispose() {
    _pin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Remove Device?'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FieldLabel('Enter Transaction PIN'),
                    AppTextInput(
                      controller: _pin,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      hint: '',
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(56),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    if (_pin.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Enter your transaction PIN')));
                      return;
                    }
                    Navigator.pushNamed(
                        context, AppRoutes.deviceActionComplete);
                  },
                  child: const Text('Verify and Remove Device',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Action Complete" — confirms the device has been removed.
class DeviceActionCompleteScreen extends StatelessWidget {
  const DeviceActionCompleteScreen({super.key});

  void _returnToSecurity(BuildContext context) {
    Navigator.popUntil(
      context,
      (r) => r.settings.name == AppRoutes.securityHome || r.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _returnToSecurity(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.pageGrey,
        appBar: whiteAppBar('Action Complete'),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
                  child: Column(
                    children: [
                      _deviceBadge(),
                      const SizedBox(height: 22),
                      const ScreenHeading(
                        'You are signed out',
                        helper: 'Your account and records remain safe.',
                        center: true,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: PrimaryButton(
                  'Return to Settings',
                  onPressed: () => _returnToSecurity(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---- Shared helpers ----

Widget _deviceBadge() {
  return Container(
    width: 96,
    height: 96,
    decoration: const BoxDecoration(
      color: AppColors.infoSoft,
      shape: BoxShape.circle,
    ),
    child: const Center(
      child: AppIcon('mobile', size: 40, color: AppColors.iconBlue),
    ),
  );
}

Widget _infoNotice(String text) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.infoNotice,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info_outline, size: 20, color: AppColors.primaryDark),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text,
              style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.4)),
        ),
      ],
    ),
  );
}
