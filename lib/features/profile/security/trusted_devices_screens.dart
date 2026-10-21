import 'package:flutter/material.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_icon.dart';

class TrustedDevicesScreen extends StatelessWidget {
  const TrustedDevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SecurityScaffold(
      title: 'Trusted Devices',
      child: Column(
        children: [
          _DeviceTile(
            name: 'iPhone 15',
            subtitle: 'Current device',
            onTap: () => Navigator.pushNamed(context, AppRoutes.deviceDetails,
                arguments: true),
          ),
          _DeviceTile(
            name: 'iPhone 13 — previous phone',
            subtitle: 'Previous device · Manage access',
            onTap: () => Navigator.pushNamed(context, AppRoutes.deviceDetails,
                arguments: false),
          ),
          const SizedBox(height: 12),
          const _Notice(
              text:
                  'You can revoke a lost or previous phone from your new verified device. Pairing a new device does not automatically remove older devices.'),
        ],
      ),
    );
  }
}

class DeviceDetailsScreen extends StatelessWidget {
  final bool current;
  const DeviceDetailsScreen({super.key, this.current = true});

  @override
  Widget build(BuildContext context) {
    return _SecurityScaffold(
      title: 'Device Details',
      child: Column(
        children: [
          const _DeviceIcon(),
          const SizedBox(height: 14),
          Text(current ? 'iPhone 15' : 'iPhone 13',
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(current ? 'Current device' : 'Previous device',
              style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
          const SizedBox(height: 28),
          const _Notice(
              text:
                  'Remove access if you no longer recognise or use this device.'),
          const SizedBox(height: 14),
          if (!current)
            _DangerButton(
              label: 'Remove Device',
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.removeDevice),
            ),
        ],
      ),
    );
  }
}

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
    return _SecurityScaffold(
      title: 'Remove Device?',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _FieldLabel('Enter Transaction PIN'),
          TextField(
              controller: _pin,
              obscureText: true,
              keyboardType: TextInputType.number),
          const SizedBox(height: 14),
          _DangerButton(
            label: 'Verify and Remove Device',
            onPressed: () {
              if (_pin.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Enter your transaction PIN')));
                return;
              }
              Navigator.pushNamed(context, AppRoutes.deviceActionComplete);
            },
          ),
        ],
      ),
    );
  }
}

class DeviceActionCompleteScreen extends StatelessWidget {
  const DeviceActionCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.popUntil(
              context, ModalRoute.withName(AppRoutes.securityHome));
        }
      },
      child: _SecurityScaffold(
        title: 'Action Complete',
        child: Column(
          children: [
            const _DeviceIcon(),
            const SizedBox(height: 18),
            const Text('You are signed out',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            const Text('Your account and records remain safe.',
                style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
            const SizedBox(height: 34),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.popUntil(
                    context, ModalRoute.withName(AppRoutes.securityHome)),
                child: const Text('Return to Settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecurityScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  const _SecurityScaffold({required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.pageGrey,
        appBar: AppBar(
          title: Text(title),
          backgroundColor: AppColors.white,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24), child: child),
        ),
      );
}

class _DeviceTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final VoidCallback onTap;
  const _DeviceTile(
      {required this.name, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          leading: const AppIcon('mobile', color: AppColors.primaryDark),
          title: Text(name,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          subtitle: Text(subtitle,
              style: const TextStyle(fontSize: 10, color: AppColors.textGrey)),
          trailing:
              const AppIcon('chevron-right', color: AppColors.primaryDark),
          onTap: onTap,
        ),
      );
}

class _DeviceIcon extends StatelessWidget {
  const _DeviceIcon();

  @override
  Widget build(BuildContext context) => Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
            color: AppColors.inputFill, shape: BoxShape.circle),
        child: const Center(
            child: AppIcon('mobile', size: 28, color: AppColors.iconBlue)),
      );
}

class _Notice extends StatelessWidget {
  final String text;
  const _Notice({required this.text});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppIcon('info-circle', size: 15, color: AppColors.iconBlue),
            const SizedBox(width: 8),
            Expanded(
                child: Text(text,
                    style: const TextStyle(fontSize: 10, height: 1.4))),
          ],
        ),
      );
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)));
}

class _DangerButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _DangerButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.white),
            onPressed: onPressed,
            child: Text(label)),
      );
}
