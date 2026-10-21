import 'package:flutter/material.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_icon.dart';

class DeactivateAccountScreen extends StatelessWidget {
  const DeactivateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _AccountControlScaffold(
      title: 'Sign Out',
      child: Column(
        children: [
          const _StatusIcon(icon: 'power', color: AppColors.accentYellow),
          const SizedBox(height: 18),
          const _Heading(
            title: 'Temporarily deactivate your account',
            message:
                'You can reactivate later by signing in and completing security verification.',
          ),
          const SizedBox(height: 24),
          const _Checklist(items: [
            'Your profile and legally required records will be retained.',
            'All trusted devices will be signed out.',
            'Sending and receiving will remain unavailable until reactivation.',
          ]),
          const SizedBox(height: 20),
          const _Notice(
            text:
                'Your wallets must have zero balance and no pending transactions before deactivation.',
          ),
          const SizedBox(height: 18),
          _DangerButton(
            label: 'Check Your Account',
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.accountCheck),
          ),
          _SecondaryButton(
            label: 'Proceed',
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.deactivateDetails),
          ),
        ],
      ),
    );
  }
}

class AccountCheckScreen extends StatelessWidget {
  const AccountCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _AccountControlScaffold(
      title: 'Account Check',
      child: Column(
        children: [
          _StatusIcon(
              icon: 'close',
              color: AppColors.error,
              background: AppColors.error.withValues(alpha: 0.12)),
          const SizedBox(height: 18),
          const _Heading(
            title: 'Resolve these items first',
            message: 'Your account cannot be deactivated yet.',
          ),
          const SizedBox(height: 20),
          const _CheckRow(
            title: 'EUR Wallet balance',
            subtitle: '€184.20 must be withdrawn or transferred.',
            valid: false,
          ),
          const _CheckRow(
            title: 'No pending transfers',
            subtitle: 'All transfers are complete.',
          ),
          const _CheckRow(
            title: 'No open disputes or loans',
            subtitle: '',
          ),
          const SizedBox(height: 18),
          _PrimaryButton(
            label: 'Move Remaining Money',
            onPressed: () => Navigator.pop(context),
          ),
          _SecondaryButton(
            label: 'Return to Profile',
            onPressed: () => Navigator.popUntil(
              context,
              ModalRoute.withName(AppRoutes.profile),
            ),
          ),
        ],
      ),
    );
  }
}

class DeactivateDetailsScreen extends StatefulWidget {
  const DeactivateDetailsScreen({super.key});

  @override
  State<DeactivateDetailsScreen> createState() =>
      _DeactivateDetailsScreenState();
}

class _DeactivateDetailsScreenState extends State<DeactivateDetailsScreen> {
  String _reason = 'No longer using service';

  @override
  Widget build(BuildContext context) {
    return _AccountControlScaffold(
      title: 'Deactivate Account',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StatusIcon(icon: 'shield', color: AppColors.accentYellow),
          const SizedBox(height: 18),
          const _Heading(
            title: 'Deactivate your account?',
            message:
                'This will sign you out and temporarily disable all account activity.',
          ),
          const SizedBox(height: 24),
          const _FieldLabel('Reason for deactivating'),
          DropdownButtonFormField<String>(
            initialValue: _reason,
            items: const [
              DropdownMenuItem(
                  value: 'No longer using service',
                  child: Text('No longer using service')),
              DropdownMenuItem(
                  value: 'Taking a break', child: Text('Taking a break')),
              DropdownMenuItem(value: 'Other', child: Text('Other')),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _reason = value);
            },
          ),
          const SizedBox(height: 12),
          const _Notice(
            text:
                'You can reactivate later. Fresh identity verification may be required.',
            warning: true,
          ),
          const SizedBox(height: 18),
          _DangerButton(
            label: 'Continue to Verification',
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.securityVerification),
          ),
          _SecondaryButton(
            label: 'Keep My Account Active',
            onPressed: () => Navigator.popUntil(
                context, ModalRoute.withName(AppRoutes.profile)),
          ),
        ],
      ),
    );
  }
}

class SecurityVerificationScreen extends StatefulWidget {
  const SecurityVerificationScreen({super.key});

  @override
  State<SecurityVerificationScreen> createState() =>
      _SecurityVerificationScreenState();
}

class _SecurityVerificationScreenState
    extends State<SecurityVerificationScreen> {
  final _pin = TextEditingController();

  @override
  void dispose() {
    _pin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _AccountControlScaffold(
      title: 'Security Verification',
      child: Column(
        children: [
          const _StatusIcon(icon: 'lock', color: AppColors.iconBlue),
          const SizedBox(height: 18),
          const _Heading(
            title: 'Confirm it’s you',
            message: 'Enter your transaction PIN to deactivate your account.',
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _pin,
            obscureText: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Transaction PIN'),
          ),
          const SizedBox(height: 14),
          const _Notice(
              text:
                  'Never share your PIN with anyone, including FramelaPay Support.'),
          const SizedBox(height: 18),
          _DangerButton(
            label: 'Deactivate Account',
            onPressed: () {
              if (_pin.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Enter your transaction PIN')));
                return;
              }
              Navigator.pushNamed(context, AppRoutes.accountDeactivated);
            },
          ),
        ],
      ),
    );
  }
}

class AccountDeactivatedScreen extends StatelessWidget {
  const AccountDeactivatedScreen({super.key});

  void _go(BuildContext context, String route) => Navigator.popUntil(
      context, (entry) => entry.settings.name == route || entry.isFirst);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _go(context, AppRoutes.profile);
      },
      child: _AccountControlScaffold(
        title: 'Account Deactivated',
        child: Column(
          children: [
            _StatusIcon(
                icon: 'power',
                color: AppColors.success,
                background: AppColors.success.withValues(alpha: 0.12)),
            const SizedBox(height: 18),
            const _Heading(
              title: 'Your account is deactivated',
              message:
                  'Your data has been retained according to our Privacy Policy and legal obligations.',
            ),
            const SizedBox(height: 30),
            _PrimaryButton(
              label: 'Reactivate Account',
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.reactivateAccount),
            ),
            _SecondaryButton(
              label: 'Return to Welcome',
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.welcome, (_) => false),
            ),
          ],
        ),
      ),
    );
  }
}

class ReactivateAccountScreen extends StatefulWidget {
  const ReactivateAccountScreen({super.key});

  @override
  State<ReactivateAccountScreen> createState() =>
      _ReactivateAccountScreenState();
}

class _ReactivateAccountScreenState extends State<ReactivateAccountScreen> {
  final _email = TextEditingController(text: 'cynthia.nkechi@email.com');
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _AccountControlScaffold(
      title: 'Reactivate Account',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatusIcon(
              icon: 'refresh',
              color: AppColors.iconBlue,
              background: AppColors.inputFill),
          const SizedBox(height: 18),
          const _Heading(
            title: 'Welcome back, Cynthia',
            message:
                'Complete security verification to restore account access.',
          ),
          const SizedBox(height: 24),
          const _FieldLabel('Email address'),
          TextField(
              controller: _email, keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 14),
          const _FieldLabel('Password'),
          TextField(controller: _password, obscureText: true),
          const SizedBox(height: 18),
          _PrimaryButton(
            label: 'Continue',
            onPressed: () {
              if (_email.text.isEmpty || _password.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Enter your email and password')));
                return;
              }
              Navigator.pushNamed(context, AppRoutes.accountReactivated);
            },
          ),
        ],
      ),
    );
  }
}

class AccountReactivatedScreen extends StatelessWidget {
  const AccountReactivatedScreen({super.key});

  void _go(BuildContext context, String route) => Navigator.popUntil(
      context, (entry) => entry.settings.name == route || entry.isFirst);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _go(context, AppRoutes.profile);
      },
      child: _AccountControlScaffold(
        title: 'Account Reactivated',
        child: Column(
          children: [
            const _StatusIcon(
                icon: 'refresh',
                color: AppColors.iconBlue,
                background: AppColors.inputFill),
            const SizedBox(height: 18),
            const _Heading(
              title: 'Account reactivated successfully',
              message:
                  'You can now use FramelaPay again. Review your security and KYC status before transferring money.',
            ),
            const SizedBox(height: 30),
            _PrimaryButton(
              label: 'Continue to Profile',
              onPressed: () => _go(context, AppRoutes.profile),
            ),
            _SecondaryButton(
              label: 'Back to Settings',
              onPressed: () => _go(context, AppRoutes.settingsHome),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountControlScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  const _AccountControlScaffold({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: AppBar(
        title: Text(title),
        leading: const BackButton(),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
          child: child,
        ),
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final String icon;
  final Color color;
  final Color background;
  const _StatusIcon({
    required this.icon,
    required this.color,
    this.background = AppColors.accentYellow,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        child: Center(child: AppIcon(icon, size: 32, color: color)),
      );
}

class _Heading extends StatelessWidget {
  final String title;
  final String message;
  const _Heading({required this.title, required this.message});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(title,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.textGrey, fontSize: 12, height: 1.4)),
        ],
      );
}

class _Checklist extends StatelessWidget {
  final List<String> items;
  const _Checklist({required this.items});

  @override
  Widget build(BuildContext context) => Column(
        children:
            items.map((item) => _CheckRow(title: item, subtitle: '')).toList(),
      );
}

class _CheckRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool valid;
  const _CheckRow(
      {required this.title, required this.subtitle, this.valid = true});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppIcon(valid ? 'check-circle' : 'close-circle',
                size: 18, color: valid ? AppColors.success : AppColors.error),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                  if (subtitle.isNotEmpty)
                    Text(subtitle,
                        style: const TextStyle(
                            color: AppColors.textGrey, fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
      );
}

class _Notice extends StatelessWidget {
  final String text;
  final bool warning;
  const _Notice({required this.text, this.warning = false});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: warning
              ? AppColors.accentYellow.withValues(alpha: 0.55)
              : AppColors.inputFill,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppIcon('info-circle',
                size: 16,
                color: warning ? AppColors.primaryDark : AppColors.iconBlue),
            const SizedBox(width: 8),
            Expanded(
                child: Text(text,
                    style: const TextStyle(fontSize: 10, height: 1.35))),
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
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      );
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _PrimaryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: ElevatedButton(onPressed: onPressed, child: Text(label)),
      );
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
          child: Text(label),
        ),
      );
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _SecondaryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton(onPressed: onPressed, child: Text(label)),
        ),
      );
}
