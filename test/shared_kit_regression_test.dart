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
import 'package:framela/features/profile/profile_screen.dart';
import 'package:framela/features/profile/photo/change_profile_photo_screen.dart';
import 'package:framela/features/profile/photo/adjust_profile_photo_screen.dart';
import 'package:framela/features/profile/photo/photo_updated_screen.dart';
import 'package:framela/features/profile/photo/remove_profile_photo_screen.dart';
import 'package:framela/features/profile/photo/profile_photo_removed_screen.dart';
import 'package:framela/features/profile/kyc/source_of_funds_screen.dart';
import 'package:framela/features/profile/security/change_password_screen.dart';
import 'package:framela/features/profile/statements/account_statements_screen.dart';
import 'package:framela/features/activity/activity_screen.dart';
import 'package:framela/features/profile/referral/referral_screen.dart';
import 'package:framela/data/models/transfer_recipient.dart';
import 'package:framela/features/transfer/shared/choose_network_screen.dart';
import 'package:framela/features/transfer/shared/transaction_details_screen.dart';
import 'package:framela/features/transfer/to_external_wallet/enter_wallet_address_screen.dart';
import 'package:framela/features/transfer/to_external_wallet/verify_wallet_address_screen.dart';
import 'package:framela/data/models/conversion_result.dart';
import 'package:framela/data/models/exchange_rate.dart';
import 'package:framela/features/exchange/currency_pair_updated_screen.dart';
import 'package:framela/features/exchange/exchange_rates_screen.dart';
import 'package:framela/data/models/ongoing_transfer.dart';
import 'package:framela/data/models/processing_step.dart';
import 'package:framela/data/models/rate_alert.dart';
import 'package:framela/features/transfer/status/transfer_progress_screen.dart';
import 'package:framela/features/transfer/status/transfer_status_details_screen.dart';
import 'package:framela/features/transfer/status/transfer_status_screen.dart';
import 'package:framela/features/exchange/rate_alert_created_screen.dart';
import 'package:framela/features/exchange/rate_alert_form_screen.dart';
import 'package:framela/features/exchange/rate_alerts_screen.dart';
import 'package:framela/features/exchange/rate_pair_detail_screen.dart';
import 'package:framela/features/exchange/select_currency_pair_screen.dart';
import 'package:framela/features/transfer/wallet/conversion_completed_screen.dart';
import 'package:framela/features/transfer/wallet/conversion_receipt_screen.dart';
import 'package:framela/features/transfer/wallet/convert_funds_screen.dart';
import 'package:framela/features/transfer/wallet/convert_funds_sheet.dart';
import 'package:framela/features/transfer/wallet/convert_select_wallet_screen.dart';
import 'package:framela/features/transfer/wallet/select_wallet_screen.dart';
import 'package:framela/features/wallet/choose_wallet_balance_sheet.dart';
import 'package:framela/features/wallet/fund_card_screen.dart';
import 'package:framela/features/wallet/fund_wallet_details_screen.dart';
import 'package:framela/features/wallet/receive_details_screen.dart';

const _wallet = CurrencyWallet(
  code: 'NGN',
  name: 'Nigerian Naira',
  symbol: '₦',
  balance: 150000,
);

const _result = ConversionResult(
  from: CurrencyWallet(
      code: 'NGN', name: 'Nigerian Naira', symbol: '₦', balance: 500000),
  to: CurrencyWallet(
      code: 'USD', name: 'US Dollar', symbol: r'$', balance: 1250),
  amountConverted: 150000,
  fee: 1500,
  amountReceived: 99,
  rateText: '1 USD = 1,500.0000 NGN',
);

const _pair = CurrencyPair(
  baseCode: 'USD',
  baseName: 'US Dollar',
  baseCountry: 'US',
  quoteCode: 'NGN',
  quoteName: 'Nigerian Naira',
  quoteCountry: 'NG',
);

const _alert = RateAlert(
  id: 'a1',
  pair: _pair,
  condition: AlertCondition.atOrAbove,
  targetRate: 1520,
);

const _ongoing = OngoingTransfer(
  id: 't1',
  recipient: 'Amina Yusuf',
  amount: r'$150.00',
  method: 'Debit/Credit Card',
  startedAt: '12 Oct 2026 · 10:24',
  stage: OngoingStage.processing,
  youSend: r'$150.00',
  fee: r'$2.50',
  totalPayment: r'$152.50',
  recipientReceives: '₦235,125.00',
  reference: 'FRM-20261012-10427',
  destinationBank: 'Zenith Bank',
  accountNumber: '•••• 5678',
  steps: [
    ProcessingStep(
        title: 'Transfer initiated', subtitle: 'Completed · 10:24', done: true),
    ProcessingStep(
        title: 'Partner processing', subtitle: 'In progress', inProgress: true),
    ProcessingStep(title: 'Completed', subtitle: 'Waiting'),
  ],
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
    'Send Money': const SelectWalletScreen(),
    'Exchange Rates': const ExchangeRatesScreen(),
    'Select Currency Pair': const SelectCurrencyPairScreen(),
    'Currency Pair Updated': const CurrencyPairUpdatedScreen(pair: _pair),
    'Rate Pair Detail': const RatePairDetailScreen(pair: _pair),
    'Transfer Status': const TransferStatusScreen(),
    'Transfer Progress': const TransferProgressScreen(transfer: _ongoing),
    'Transfer Status Details':
        const TransferStatusDetailsScreen(transfer: _ongoing),
    'My Rate Alerts': const RateAlertsScreen(),
    'Set Rate Alert': const RateAlertFormScreen(),
    'Alert Details': const RateAlertFormScreen(alert: _alert),
    'Rate Alert Created': const RateAlertCreatedScreen(alert: _alert),
    'Convert Select Wallet': const ConvertSelectWalletScreen(),
    'Convert Funds screen': const ConvertFundsScreen(),
    'Conversion Completed': const ConversionCompletedScreen(result: _result),
    'Conversion Receipt': const ConversionReceiptScreen(result: _result),
    'Referral': const ReferralScreen(),
    'History': const ActivityScreen(),
    'Choose Network': const ChooseNetworkScreen(),
    'Enter Wallet Address': const EnterWalletAddressScreen(),
    'Verify Wallet Address': const VerifyWalletAddressScreen(),
    'Stablecoin Receipt': const TransactionDetailsScreen(
      recipient: TransferRecipient(
        type: RecipientType.framelaUser,
        name: 'Ken Okafor',
        handle: '@ken',
        walletAddress: '0x8a71C4b2e9F094cd',
      ),
    ),
    'Fund Wallet Details': const FundWalletDetailsScreen(wallet: _wallet),
    'Receive Details': const ReceiveDetailsScreen(wallet: _wallet),
    'Fund Card': const FundCardScreen(wallet: _wallet),
    'Add Beneficiary': const AddBeneficiaryScreen(),
    'Account Statements': const AccountStatementsScreen(),
    'Change Password': const ChangePasswordScreen(),
    'Source of Funds': const SourceOfFundsScreen(),
    'Profile': const ProfileScreen(),
    'Change Profile Picture': const ChangeProfilePhotoScreen(),
    'Adjust Profile Picture': const AdjustProfilePhotoScreen(),
    'Photo Updated': const PhotoUpdatedScreen(),
    'Remove Profile Picture': const RemoveProfilePhotoScreen(),
    'Profile Photo Removed': const ProfilePhotoRemovedScreen(),
  };

  screens.forEach((name, screen) {
    testWidgets('$name lays out at 360x640', (tester) async {
      await pumpScreen(tester, screen);
      expect(tester.takeException(), isNull, reason: '$name overflowed');
    });
  });

  // The History filter dropdowns anchor under the chip row rather than
  // presenting as bottom sheets, so the open state needs its own check.
  testWidgets('History filter dropdown lays out at 360x640', (tester) async {
    await pumpScreen(tester, const ActivityScreen());
    await tester.tap(find.text('All categories').first);
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Choose category'), findsOneWidget);
    expect(tester.takeException(), isNull,
        reason: 'History filter dropdown overflowed');
  });

  // The period picker is a bottom sheet with two tabs; both need checking.
  testWidgets('History period picker lays out at 360x640', (tester) async {
    await pumpScreen(tester, const ActivityScreen());
    await tester.tap(find.text('Oct 2026').first);
    // pumpAndSettle so the sheet finishes animating in — a fixed pump leaves
    // it off-screen, and taps on it then miss. Safe here: unlike the convert
    // sheet, the period picker runs no periodic timer.
    await tester.pumpAndSettle();
    expect(find.text('Choose period'), findsOneWidget);
    expect(find.text('Scroll to choose a month and year.'), findsOneWidget);
    expect(tester.takeException(), isNull, reason: 'period Month tab overflowed');

    await tester.tap(find.text('Time frame'));
    await tester.pumpAndSettle();
    expect(find.text('Apply Period'), findsOneWidget);
    expect(tester.takeException(), isNull,
        reason: 'period Time frame tab overflowed');
  });

  // Modals have to be opened rather than pumped directly.
  final sheets = <String, void Function(BuildContext)>{
    'Convert Funds': (c) => showConvertFundsSheet(c, _wallets),
    'Choose wallet balance': (c) => showChooseWalletBalanceSheet(c, _wallets),
  };

  sheets.forEach((name, open) {
    testWidgets('$name sheet lays out at 360x640', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => open(context),
              child: const Text('open'),
            ),
          ),
        ),
      ));
      await tester.tap(find.text('open'));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 400));
      expect(tester.takeException(), isNull, reason: '$name sheet overflowed');
    });
  });
}
