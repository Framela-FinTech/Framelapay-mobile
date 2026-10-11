import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Icon style: outline (linear) by default, filled (bold) for active/selected
/// states — active bottom-nav tab, selected list rows, completed/verified steps.
enum AppIconStyle { linear, bold }

/// The single place icons are rendered in the app.
///
/// Icons come from the designer's Iconly pack, exported as SVGs to
/// `assets/icons/<name>-<style>.svg` and loaded via flutter_svg. No other file
/// should call `SvgPicture` or `Icons.*` directly for a mapped slot — use
/// `AppIcon('<name>')` so the icon set can be managed centrally.
///
/// Fallback: if an SVG for the requested name/style has not been exported yet
/// (see [_exportedAssets]), a Material icon from [_fallbackLinear] /
/// [_fallbackBold] is rendered instead, so nothing ever crashes or renders
/// blank. As SVGs are added to `assets/icons/`, add their `<name>-<style>`
/// key to [_exportedAssets] and they take over automatically — no call-site
/// changes needed.
class AppIcon extends StatelessWidget {
  final String name;
  final double size;
  final Color? color;
  final AppIconStyle style;

  const AppIcon(
    this.name, {
    super.key,
    this.size = 24,
    this.color,
    this.style = AppIconStyle.linear,
  });

  /// `<name>-<style>` keys for the SVGs actually present in assets/icons/.
  /// Extend this as more icons are exported from Figma.
  static const Set<String> _exportedAssets = {
    'home-linear',
    'wallet-bold',
    'folder-user-linear',
    'folder-user-bold',
    'bell-linear',
    'bell-bold',
    'eye-linear',
    'eye-bold',
    'eye-slash-linear',
    'arrow-up-linear',
    'bank-linear',
  };

  /// Material fallbacks (outline) for every mapped slot.
  static const Map<String, IconData> _fallbackLinear = {
    'home': Icons.home_outlined,
    'send': Icons.send_outlined,
    'activity': Icons.access_time, // clock/history — bottom-nav Activity tab
    'wallet': Icons.account_balance_wallet_outlined,
    'folder-user': Icons.person_outline, // stand-in: no plain user in the pack
    'bell': Icons.notifications_outlined,
    'eye': Icons.visibility_outlined,
    'eye-slash': Icons.visibility_off_outlined,
    'arrow-up': Icons.arrow_upward,
    'arrow-down': Icons.arrow_downward,
    'bank': Icons.account_balance_outlined,
    'card': Icons.credit_card_outlined,
    'coins': Icons.monetization_on_outlined,
    'shield': Icons.shield_outlined,
    'BTC': Icons.currency_bitcoin,
    'receipt': Icons.receipt_long_outlined,
    'calendar': Icons.calendar_today_outlined, // date fields
    'chart-up': Icons.trending_up,
    'coins-alt': Icons.savings_outlined,
    'gift': Icons.card_giftcard, // Referral
    'power': Icons.power_settings_new, // Deactivate account
    'logout': Icons.logout, // Sign out
    'lock': Icons.lock_outline,
    'lifebuoy': Icons.support_agent_outlined,
    'question-circle': Icons.help_outline,
    'settings': Icons.settings_outlined,
    'globe': Icons.language_outlined, // Language & Region
    'call': Icons.call_outlined,
    'wifi': Icons.wifi,
    'bulb': Icons.lightbulb_outline,
    'tv': Icons.tv_outlined,
    'target': Icons.gps_fixed,
    'graduating-cap': Icons.school_outlined,
    'naira': Icons.money_outlined,
    'dollar': Icons.attach_money,
    'pounds': Icons.currency_pound,
    'euro': Icons.euro,
    'coin-swap': Icons.swap_horiz,
    'data': Icons.hub_outlined,
    'QR-code': Icons.qr_code,
    'verified': Icons.verified_outlined,
    'shield-tick': Icons.verified_user_outlined,
    'pencil-edit': Icons.edit_outlined,
    'fingerprint': Icons.fingerprint,
    'face-id': Icons.face_outlined,
    'check-circle': Icons.check_circle_outline,
    'radio-button': Icons.radio_button_unchecked,
    'copy': Icons.copy_outlined,
    'share': Icons.share_outlined,
    'chevron-left': Icons.chevron_left,
    'chevron-right': Icons.chevron_right,
    'search': Icons.search,
    'chevron-down': Icons.keyboard_arrow_down,
    'info-circle': Icons.info_outline,
    'info-triangle': Icons.warning_amber_outlined,
  };

  /// Filled Material fallbacks for the bold style, where a filled counterpart
  /// reads better. Names not listed reuse [_fallbackLinear].
  static const Map<String, IconData> _fallbackBold = {
    'home': Icons.home,
    'activity': Icons.access_time_filled,
    'wallet': Icons.account_balance_wallet,
    'folder-user': Icons.person,
    'bell': Icons.notifications,
    'eye': Icons.visibility,
    'shield': Icons.shield,
    'lock': Icons.lock,
    'verified': Icons.verified,
    'check-circle': Icons.check_circle,
    'card': Icons.credit_card,
    'shield-tick': Icons.verified_user,
  };

  bool get _hasSvg => _exportedAssets.contains('$name-${style.name}');

  @override
  Widget build(BuildContext context) {
    final resolved =
        color ?? IconTheme.of(context).color ?? const Color(0xFF0B0E2C);

    if (_hasSvg) {
      return SvgPicture.asset(
        'assets/icons/$name-${style.name}.svg',
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(resolved, BlendMode.srcIn),
        placeholderBuilder: (_) => _material(resolved),
      );
    }
    return _material(resolved);
  }

  Widget _material(Color resolved) {
    final data = (style == AppIconStyle.bold
            ? _fallbackBold[name]
            : null) ??
        _fallbackLinear[name] ??
        Icons.help_outline;
    return Icon(data, size: size, color: resolved);
  }
}
