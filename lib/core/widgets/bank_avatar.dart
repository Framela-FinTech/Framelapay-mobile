import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'app_icon.dart';

/// Bank name -> logo asset under `assets/icons/banks/`.
///
/// Keys are normalized by [_slug], so "GTBank", "GTBank PLC" and "gtbank" all
/// resolve to the same entry. A bank missing from this map renders the generic
/// glyph instead of a broken image, so adding a logo is a one-line change and
/// never a prerequisite for shipping a new bank.
/// Only banks whose logo file is actually present are listed. The rest render
/// the glyph deliberately — a wrong or placeholder mark is worse than none.
/// Still unsourced: FCMB, Fidelity, Heritage, Parallex, Polaris, Providus,
/// Titan Trust, Unity. Drop a file in and add its line here.
const Map<String, String> kBankLogos = {
  'gtbank': 'assets/icons/banks/gtbank.png',
  'zenithbank': 'assets/icons/banks/zenith.png',
  'accessbank': 'assets/icons/banks/access.png',
  'unitedbankforafrica': 'assets/icons/banks/uba.png',
  'firstbank': 'assets/icons/banks/first-bank.png',
  'kudabank': 'assets/icons/banks/kuda.png',
  'opay': 'assets/icons/banks/opay.png',
  'moniepoint': 'assets/icons/banks/moniepoint.png',
  'sterlingbank': 'assets/icons/banks/sterling.png',
  'unionbank': 'assets/icons/banks/union.png',
  'wemabank': 'assets/icons/banks/wema.png',
  'stanbicibtc': 'assets/icons/banks/stanbic.png',
  'keystonebank': 'assets/icons/banks/keystone.png',
  'jaizbank': 'assets/icons/banks/jaiz.png',
  'globusbank': 'assets/icons/banks/globus.png',
  'premiumtrustbank': 'assets/icons/banks/premiumtrust.png',
  'suntrustbank': 'assets/icons/banks/suntrust.png',
};

String _slug(String name) =>
    name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

/// Returns the logo asset for [bankName], or null when none is registered.
String? bankLogoAsset(String bankName) => kBankLogos[_slug(bankName)];

/// Circular bank mark for recipient tiles and bank pickers.
///
/// Falls back to the generic bank glyph when the bank has no registered logo,
/// so an unknown bank never renders blank.
class BankAvatar extends StatelessWidget {
  final String bankName;
  final double size;
  const BankAvatar(this.bankName, {super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    final asset = bankLogoAsset(bankName);
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.iconTileSoft,
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: asset == null
          ? AppIcon('bank', size: size * 0.5, color: AppColors.primary50)
          : Image.asset(
              asset,
              width: size,
              height: size,
              fit: BoxFit.cover,
              // A registered-but-missing file must not crash a list.
              errorBuilder: (_, __, ___) =>
                  AppIcon('bank', size: size * 0.5, color: AppColors.primary50),
            ),
    );
  }
}
