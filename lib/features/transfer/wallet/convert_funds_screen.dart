import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/currency_wallet.dart';
import '../../../data/repositories/currency_wallet_repository.dart';
import '../fiat/widgets/fiat_form_widgets.dart';
import 'convert_funds_form.dart';

/// "Convert Funds" as a full screen — the presentation the Conversion board
/// draws, reached from the Wallet tab via Select From Wallet, and continuing
/// to a completion screen and a receipt.
class ConvertFundsScreen extends StatefulWidget {
  /// The wallet chosen on the previous step, if any.
  final CurrencyWallet? from;
  const ConvertFundsScreen({super.key, this.from});

  @override
  State<ConvertFundsScreen> createState() => _ConvertFundsScreenState();
}

class _ConvertFundsScreenState extends State<ConvertFundsScreen> {
  final CurrencyWalletRepository _repo = MockCurrencyWalletRepository();
  List<CurrencyWallet> _wallets = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final wallets = await _repo.getWallets();
    if (!mounted) return;
    setState(() {
      _wallets = wallets;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageGrey,
      appBar: whiteAppBar('Convert Funds'),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                    20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 24),
                child: ConvertFundsForm(
                  wallets: _wallets,
                  initialFrom: widget.from,
                  onConverted: (result) => Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.conversionCompleted,
                    arguments: result,
                  ),
                ),
              ),
      ),
    );
  }
}
