// Screens OUTSIDE the transfer flow that consume the shared widget kit
// (`fiat_form_widgets.dart`, ~57 importers) or the mock FX rate. The bank and
// card design passes restyled that kit globally and moved the NGN rate, and
// there is no emulator on this machine, so this is the only check that those
// screens still lay out.
//
// Same 360x640 budget and the same real-font loading as the bank-flow test:
// the default test font draws every glyph as a full em box and reports
// overflows that cannot happen on a device.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:framela/core/theme/app_theme.dart';
import 'package:framela/data/models/currency_wallet.dart';
import 'package:framela/features/profile/beneficiaries/add_beneficiary_screen.dart';
import 'package:framela/features/profile/kyc/source_of_funds_screen.dart';
import 'package:framela/features/profile/security/change_password_screen.dart';
import 'package:framela/features/profile/statements/account_statements_screen.dart';
import 'package:framela/features/transfer/shared/choose_network_screen.dart';
import 'package:framela/features/transfer/wallet/convert_funds_sheet.dart';
import 'package:framela/features/wallet/fund_card_screen.dart';
import 'package:framela/features/wallet/fund_wallet_details_screen.dart';
import 'package:framela/features/wallet/receive_details_screen.dart';

const _wallet = CurrencyWallet(
  code: 'NGN',
  name: 'Nigerian Naira',
  symbol: '₦',
  balance: 150000,
);

const _wallets = [
  _wallet,
  CurrencyWallet(code: 'USD', name: 'US Dollar', symbol: r'$', balance: 350000),
  CurrencyWallet(code: 'GBP', name: 'British Pound', symbol: '£', balance: 1000),
];

Future<void> _loadInter() async {
  final loader = FontLoader('Inter');
  for (final weight in const [
    'Regular',
    'Medium',
    'SemiBold',
    'Bold',
    'ExtraBold',
  ]) {
    final bytes = File('assets/fonts/Inter-$weight.ttf').readAsBytesSync();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await loader.load();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(_loadInter);

  Future<void> pumpScreen(WidgetTester tester, Widget screen) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.lightTheme,
      home: screen,
      onGenerateRoute: (_) =>
          MaterialPageRoute(builder: (_) => const SizedBox.shrink()),
    ));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
  }

  final screens = <String, Widget>{
    'Choose Network': const ChooseNetworkScreen(),
    'Fund Wallet Details': const FundWalletDetailsScreen(wallet: _wallet),
    'Receive Details': const ReceiveDetailsScreen(wallet: _wallet),
    'Fund Card': const FundCardScreen(wallet: _wallet),
    'Add Beneficiary': const AddBeneficiaryScreen(),
    'Account Statements': const AccountStatementsScreen(),
    'Change Password': const ChangePasswordScreen(),
    'Source of Funds': const SourceOfFundsScreen(),
  };

  screens.forEach((name, screen) {
    testWidgets('$name lays out at 360x640', (tester) async {
      await pumpScreen(tester, screen);
      expect(tester.takeException(), isNull, reason: '$name overflowed');
    });
  });

  // The convert sheet is a modal, so it has to be opened rather than pumped.
  // It is the only TimerPill consumer and shows the NGN rate that moved.
  testWidgets('Convert Funds sheet lays out at 360x640', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => showConvertFundsSheet(context, _wallets),
            child: const Text('open'),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull, reason: 'convert sheet overflowed');
  });
}
