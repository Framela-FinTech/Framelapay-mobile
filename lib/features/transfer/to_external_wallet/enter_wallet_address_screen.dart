import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_icon.dart';
import '../fiat/widgets/fiat_form_widgets.dart';
import '../shared/widgets/asset_network_bar.dart';

/// External-wallet send — recipient address plus amount.
///
/// The Home Transfer board draws only the FramelaPay-user path for this flow,
/// so there is no frame to match this screen against. It follows the house
/// conventions instead and reuses [AssetNetworkBar], the bar the matched
/// sibling screens (Enter Recipient, Enter Amount, Review) already carry.
class EnterWalletAddressScreen extends StatefulWidget {
  const EnterWalletAddressScreen({super.key});

  @override
  State<EnterWalletAddressScreen> createState() =>
      _EnterWalletAddressScreenState();
}

class _EnterWalletAddressScreenState extends State<EnterWalletAddressScreen> {
  /// Spendable balance behind "Use max" — a stand-in until wallets are live.
  static const _availableBalance = '1,250.00';
  static const _networkFee = '0.50 USDC';

  final _addressController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _useMax() {
    _amountController.text = _availableBalance;
    _amountController.selection = TextSelection.fromPosition(
      TextPosition(offset: _amountController.text.length),
    );
    setState(() {});
  }

  void _pickRecent(String address) {
    _addressController.text = address;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Enter Recipient'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AssetNetworkBar(onChange: () => Navigator.pop(context)),
                    const SizedBox(height: 22),
                    const ScreenHeading(
                      'Enter recipient address',
                      helper:
                          'Paste the wallet address or scan a QR code to get '
                          "the recipient's address.",
                    ),
                    const SizedBox(height: 18),
                    const FieldLabel('Wallet address'),
                    AppTextInput(
                      controller: _addressController,
                      hint: '0x...',
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const FieldLabel('Amount'),
                        GestureDetector(
                          onTap: _useMax,
                          child: const Text('Use max',
                              style: TextStyle(
                                  color: AppColors.accentYellow,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14)),
                        ),
                      ],
                    ),
                    AppTextInput(
                      controller: _amountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      hint: '0.00',
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 14),
                    InfoCard(
                      children: [
                        const SummaryRow(
                            'Available balance', '$_availableBalance USDC'),
                        const Divider(height: 1, color: AppColors.divider),
                        const SummaryRow('Network fee', _networkFee),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const SectionTitle('Recent addresses'),
                    const SizedBox(height: 12),
                    _walletTile('My MetaMask', '0x3a71...F3d9'),
                    _walletTile('Coinbase Wallet', '0x89c4...2e10'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: PrimaryButton(
                'Continue',
                onPressed: _addressController.text.trim().isEmpty
                    ? null
                    : () => Navigator.pushNamed(
                        context, AppRoutes.verifyWalletAddress),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _walletTile(String name, String address) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _pickRecent(address),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                    color: AppColors.iconTileSoft, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const AppIcon('wallet',
                    size: 20, color: AppColors.primary50),
              ),
              const SizedBox(width: 12),
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
                    Text(address,
                        style: const TextStyle(
                            color: AppColors.textGrey, fontSize: 13)),
                  ],
                ),
              ),
              const AppIcon('chevron-right', color: AppColors.textGrey),
            ],
          ),
        ),
      ),
    );
  }
}
