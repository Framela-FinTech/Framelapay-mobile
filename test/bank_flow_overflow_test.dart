// Smoke test: every screen in the fiat bank flow must lay out at 360x640
// without a RenderFlex overflow. Overflow is reported through FlutterError,
// which the test binding turns into a test failure, so simply building and
// pumping each screen is the assertion.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:framela/core/theme/app_theme.dart';
import 'package:framela/data/models/fiat_beneficiary.dart';
import 'package:framela/data/models/fiat_transfer.dart';
import 'package:framela/data/models/transfer_method.dart';
import 'package:framela/features/transfer/bank/bank_redirect_screen.dart';
import 'package:framela/features/transfer/bank/payment_instruction_screen.dart';
import 'package:framela/features/transfer/fiat/account_verified_screen.dart';
import 'package:framela/features/transfer/fiat/add_recipient_full_screen.dart';
import 'package:framela/features/transfer/fiat/add_recipient_short_screen.dart';
import 'package:framela/features/transfer/fiat/fiat_review_transfer_screen.dart';
import 'package:framela/features/transfer/fiat/fiat_transaction_details_screen.dart';
import 'package:framela/features/transfer/fiat/fx_quote_screen.dart';
import 'package:framela/features/transfer/fiat/select_recipient_screen.dart';
import 'package:framela/features/transfer/fiat/transfer_completed_screen.dart';
import 'package:framela/features/transfer/fiat/transfer_details_screen.dart';
import 'package:framela/data/models/transaction_receipt.dart';
import 'package:framela/features/profile/statements/receipt_detail_screen.dart';

const _beneficiary = FiatBeneficiary(
  fullName: 'Ken Okafor',
  bankName: 'Zenith Bank',
  accountNumber: '0071236789',
  country: 'Nigeria',
  relationship: 'Family member',
  purpose: 'Family support',
);

const _transfer = FiatTransfer(
  method: TransferMethod.bank,
  beneficiary: _beneficiary,
);

/// The default test font draws every glyph as a full em box, which is close
/// to twice the width of real Inter text — without this the measurements are
/// meaningless and the test reports overflows that cannot happen on device.
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

  // The smallest screen the design has to survive.
  const size = Size(360, 640);

  Future<void> pumpScreen(WidgetTester tester, Widget screen,
      {Duration extra = Duration.zero}) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.lightTheme,
      home: screen,
      // Several screens navigate on a timer or a tap; swallow the target so
      // nothing throws for a missing route.
      onGenerateRoute: (_) =>
          MaterialPageRoute(builder: (_) => const SizedBox.shrink()),
    ));

    // Fixed pumps rather than pumpAndSettle: FxQuoteScreen runs a periodic
    // countdown timer that never settles.
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
    // Screens that auto-advance on a delay leave a pending timer otherwise.
    if (extra > Duration.zero) await tester.pump(extra);
  }

  final screens = <String, Widget>{
    'Destination': const TransferDetailsScreen(transfer: _transfer),
    'Select Recipient': const SelectRecipientScreen(transfer: _transfer),
    'Add Recipient': const AddRecipientShortScreen(transfer: _transfer),
    'Sending Purpose': const AddRecipientFullScreen(transfer: _transfer),
    'Confirm Recipient': const AccountVerifiedScreen(transfer: _transfer),
    'FX Quote': const FxQuoteScreen(transfer: _transfer),
    'Bank Redirect': const BankRedirectScreen(transfer: _transfer),
    'Payment Instruction': const PaymentInstructionScreen(transfer: _transfer),
    'Review Transfer': const FiatReviewTransferScreen(transfer: _transfer),
    'Transfer Completed': const TransferCompletedScreen(transfer: _transfer),
    'Receipt': const FiatTransactionDetailsScreen(transfer: _transfer),
  };

  // Bank Redirect pushes on a 3s delay; let it fire so no timer is pending.
  const extras = {'Bank Redirect': Duration(seconds: 4)};

  screens.forEach((name, screen) {
    testWidgets('$name lays out at 360x640', (tester) async {
      await pumpScreen(tester, screen,
          extra: extras[name] ?? Duration.zero);
      expect(tester.takeException(), isNull, reason: '$name overflowed');
    });
  });

  // The Statements receipt now renders through the shared ReceiptCard; check
  // every status still lays out, since that screen is outside the bank flow.
  for (final r in sampleReceipts) {
    testWidgets('Statements receipt (${r.status.name}) lays out at 360x640',
        (tester) async {
      await pumpScreen(tester, ReceiptDetailScreen(receipt: r));
      expect(tester.takeException(), isNull,
          reason: 'receipt ${r.status.name} overflowed');
    });
  }
}
