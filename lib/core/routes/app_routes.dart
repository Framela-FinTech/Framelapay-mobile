import 'package:flutter/material.dart';

import '../../data/models/transfer_recipient.dart';
import '../../data/models/transfer_auth_flow.dart';
import '../../data/models/fiat_transfer.dart';
import '../../features/onboarding/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/welcome_screen.dart';
import '../../features/auth/create_account_screen.dart';
import '../../features/auth/phone_verification_screen.dart';
import '../../features/auth/create_password_screen.dart';
import '../../features/biometrics/biometrics_setup_screen.dart';
import '../../features/biometrics/fingerprint_capture_screen.dart';
import '../../features/biometrics/biometrics_success_screen.dart';
import '../../features/kyc/kyc_intro_screen.dart';
import '../../features/kyc/kyc_step1_screen.dart';
import '../../features/kyc/kyc_step2_screen.dart';
import '../../features/kyc/kyc_id_type_screen.dart';
import '../../features/kyc/kyc_document_capture_screen.dart';
import '../../features/kyc/kyc_selfie_capture_screen.dart';
import '../../features/kyc/kyc_status_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/home/quick_actions_screen.dart';
import '../../features/home/notifications_screen.dart';
import '../../features/placeholder/coming_soon_screen.dart';
import '../../features/wallet/wallet_tab_screen.dart';
import '../../features/wallet/add_money_select_wallet_screen.dart';
import '../../features/wallet/choose_method_screen.dart';
import '../../features/wallet/fund_wallet_details_screen.dart';
import '../../features/wallet/fund_card_screen.dart';
import '../../features/wallet/add_money_success_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/profile/widgets/profile_placeholder_screen.dart';
import '../../data/models/currency_wallet.dart';

import '../../features/transfer/shared/transfer_screen.dart';
import '../../features/transfer/shared/send_stablecoin_wallet_screen.dart';
import '../../features/transfer/shared/choose_network_screen.dart';
import '../../features/transfer/shared/send_stablecoin_recipient_screen.dart';
import '../../features/transfer/to_framela_user/find_framela_user_screen.dart';
import '../../features/transfer/to_framela_user/enter_amount_screen.dart';
import '../../features/transfer/to_external_wallet/enter_wallet_address_screen.dart';
import '../../features/transfer/to_external_wallet/verify_wallet_address_screen.dart';
import '../../features/transfer/shared/review_transfer_screen.dart';
import '../../features/transfer/shared/verify_fingerprint_screen.dart';
import '../../features/transfer/shared/enter_passcode_screen.dart';
import '../../features/transfer/shared/processing_transfer_screen.dart';
import '../../features/transfer/shared/transaction_details_screen.dart';

import '../../features/transfer/fiat/transfer_details_screen.dart';
import '../../features/transfer/fiat/select_recipient_screen.dart';
import '../../features/transfer/fiat/add_recipient_short_screen.dart';
import '../../features/transfer/fiat/add_recipient_full_screen.dart';
import '../../features/transfer/fiat/account_verified_screen.dart';
import '../../features/transfer/fiat/fx_quote_screen.dart';
import '../../features/transfer/fiat/fiat_review_transfer_screen.dart';
import '../../features/transfer/fiat/transfer_completed_screen.dart';
import '../../features/transfer/fiat/fiat_transaction_details_screen.dart';
import '../../features/transfer/bank/bank_redirect_screen.dart';
import '../../features/transfer/bank/payment_instruction_screen.dart';
import '../../features/transfer/card/pay_with_card_screen.dart';
import '../../features/transfer/card/card_verification_screen.dart';
import '../../features/transfer/wallet/select_wallet_screen.dart';

/// Every route name lives here — one source of truth.
/// Add a new constant + case whenever a new screen needs to be reachable.
class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const onboarding = '/onboarding';
  static const welcome = '/welcome';
  static const createAccount = '/create-account';
  static const phoneVerification = '/phone-verification';
  static const createPassword = '/create-password';

  static const biometricsSetup = '/biometrics-setup';
  static const fingerprintCapture = '/fingerprint-capture';
  static const biometricsSuccess = '/biometrics-success';

  static const kycIntro = '/kyc-intro';
  static const kycStep1 = '/kyc-step1';
  static const kycStep2 = '/kyc-step2';
  static const kycIdType = '/kyc-id-type';
  static const kycDocumentCapture = '/kyc-document-capture';
  static const kycSelfieCapture = '/kyc-selfie-capture';
  static const kycStatus = '/kyc-status';

  static const home = '/home';
  static const quickActions = '/quick-actions';
  static const notifications = '/notifications';

  // Bottom-nav tab destinations. Activity is still a stub (ComingSoonScreen)
  // until its real screen is built; Wallet and Profile are live.
  static const walletTab = '/wallet-tab';
  static const activity = '/activity';
  static const profile = '/profile';

  // Add Money flow (fund a wallet).
  static const addMoneySelectWallet = '/add-money-select-wallet';
  static const chooseMethod = '/choose-method';
  static const fundWalletDetails = '/fund-wallet-details';
  static const fundCard = '/fund-card';
  static const addMoneySuccess = '/add-money-success';

  // Profile section.
  static const personalInformation = '/personal-information';
  static const referral = '/referral';
  static const helpSupport = '/help-support';
  static const deactivateAccount = '/deactivate-account';
  static const signOut = '/sign-out';
  static const changePhoto = '/change-photo';
  // Sub-flow entry points (screens land in their own sub-flows).
  static const profileKycStatus = '/profile-kyc-status';
  static const beneficiariesList = '/beneficiaries';
  static const statementsHub = '/statements';
  static const securityHome = '/security';
  static const settingsHome = '/settings';

  static const transferHub = '/transfer-hub';
  static const sendStablecoinWallet = '/send-stablecoin-wallet';
  static const chooseNetwork = '/choose-network';
  static const sendStablecoinRecipient = '/send-stablecoin-recipient';
  static const findFramelaUser = '/find-framela-user';
  static const enterAmount = '/enter-amount';

  static const enterWalletAddress = '/enter-wallet-address';
  static const verifyWalletAddress = '/verify-wallet-address';

  static const reviewTransfer = '/review-transfer';
  static const verifyFingerprint = '/verify-fingerprint';
  static const enterPasscode = '/enter-passcode';
  static const processingTransfer = '/processing-transfer';
  static const transactionDetails = '/transaction-details';

  // Fiat flows (Bank / Card / Wallet) — shared + method-specific screens.
  static const fiatTransferDetails = '/fiat-transfer-details';
  static const fiatSelectRecipient = '/fiat-select-recipient';
  static const fiatAddRecipientShort = '/fiat-add-recipient-short';
  static const fiatAddRecipientFull = '/fiat-add-recipient-full';
  static const fiatAccountVerified = '/fiat-account-verified';
  static const fiatFxQuote = '/fiat-fx-quote';
  static const fiatReviewTransfer = '/fiat-review-transfer';
  static const transferCompleted = '/transfer-completed';
  static const fiatTransactionDetails = '/fiat-transaction-details';

  static const bankRedirect = '/bank-redirect';
  static const bankPaymentInstruction = '/bank-payment-instruction';

  static const payWithCard = '/pay-with-card';
  static const cardVerification = '/card-verification';

  static const selectWallet = '/select-wallet';

  // Note: kycProcessing is intentionally NOT a named route here —
  // it takes a required `nextRoute` constructor parameter, so it's
  // navigated to directly via MaterialPageRoute at each call site
  // instead of through this switch statement.

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _page(const SplashScreen());
      case onboarding:
        return _page(const OnboardingScreen());
      case welcome:
        return _page(const WelcomeScreen());
      case createAccount:
        return _page(const CreateAccountScreen());
      case phoneVerification:
        final phone = settings.arguments as String? ?? '';
        return _page(PhoneVerificationScreen(phoneNumber: phone));
      case createPassword:
        return _page(const CreatePasswordScreen());

      case biometricsSetup:
        return _page(const BiometricsSetupScreen());
      case fingerprintCapture:
        return _page(const FingerprintCaptureScreen());
      case biometricsSuccess:
        return _page(const BiometricsSuccessScreen());

      case kycIntro:
        return _page(const KycIntroScreen());
      case kycStep1:
        return _page(const KycStep1Screen());
      case kycStep2:
        return _page(const KycStep2Screen());
      case kycIdType:
        return _page(const KycIdTypeScreen());
      case kycDocumentCapture:
        return _page(const KycDocumentCaptureScreen());
      case kycSelfieCapture:
        return _page(const KycSelfieCaptureScreen());
      case kycStatus:
        final verified = settings.arguments as bool? ?? false;
        return _page(KycStatusScreen(isVerified: verified));

      case home:
        return _page(const HomeScreen());
      case quickActions:
        return _page(const QuickActionsScreen());
      case notifications:
        return _page(const NotificationsScreen());

      case walletTab:
        return _page(const WalletTabScreen());
      case activity:
        return _page(const ComingSoonScreen(title: 'Activity', navIndex: 3));

      case addMoneySelectWallet:
        return _page(const AddMoneySelectWalletScreen());
      case chooseMethod:
        final wallet = settings.arguments as CurrencyWallet;
        return _page(ChooseMethodScreen(wallet: wallet));
      case fundWalletDetails:
        final wallet = settings.arguments as CurrencyWallet;
        return _page(FundWalletDetailsScreen(wallet: wallet));
      case fundCard:
        final wallet = settings.arguments as CurrencyWallet;
        return _page(FundCardScreen(wallet: wallet));
      case addMoneySuccess:
        final wallet = settings.arguments as CurrencyWallet;
        return _page(AddMoneySuccessScreen(wallet: wallet));

      // ---- Profile section ----
      case profile:
        return _page(const ProfileScreen());
      // Permanent "Coming soon" placeholders.
      case personalInformation:
        return _page(
            const ProfilePlaceholderScreen(title: 'Personal Information'));
      case referral:
        return _page(const ProfilePlaceholderScreen(title: 'Referral'));
      case helpSupport:
        return _page(const ProfilePlaceholderScreen(title: 'Help & Support'));
      case deactivateAccount:
        return _page(
            const ProfilePlaceholderScreen(title: 'Deactivate Account'));
      case signOut:
        return _page(const ProfilePlaceholderScreen(title: 'Sign Out'));
      // Temporary placeholders — repointed when each sub-flow is built.
      case changePhoto:
        return _page(
            const ProfilePlaceholderScreen(title: 'Edit Profile Photo'));
      case profileKycStatus:
        return _page(const ProfilePlaceholderScreen(title: 'KYC Status'));
      case beneficiariesList:
        return _page(const ProfilePlaceholderScreen(title: 'Beneficiaries'));
      case statementsHub:
        return _page(
            const ProfilePlaceholderScreen(title: 'Statements & Receipts'));
      case securityHome:
        return _page(const ProfilePlaceholderScreen(title: 'Security'));
      case settingsHome:
        return _page(const ProfilePlaceholderScreen(title: 'Settings'));

      case transferHub:
        return _page(const TransferScreen());
      case sendStablecoinWallet:
        return _page(const SendStablecoinWalletScreen());
      case chooseNetwork:
        return _page(const ChooseNetworkScreen());
      case sendStablecoinRecipient:
        return _page(const SendStablecoinRecipientScreen());
      case findFramelaUser:
        return _page(const FindFramelaUserScreen());
      case enterAmount:
        return _page(const EnterAmountScreen());

      case enterWalletAddress:
        return _page(const EnterWalletAddressScreen());
      case verifyWalletAddress:
        return _page(const VerifyWalletAddressScreen());

      case reviewTransfer:
        final recipient = settings.arguments as TransferRecipient;
        return _page(ReviewTransferScreen(recipient: recipient));
      // The auth gate + processing are now shared by stablecoin and fiat;
      // they carry a neutral TransferAuthFlow instead of a specific model.
      case verifyFingerprint:
        final flow = settings.arguments as TransferAuthFlow;
        return _page(VerifyFingerprintScreen(flow: flow));
      case enterPasscode:
        final flow = settings.arguments as TransferAuthFlow;
        return _page(EnterPasscodeScreen(flow: flow));
      case processingTransfer:
        final flow = settings.arguments as TransferAuthFlow;
        return _page(ProcessingTransferScreen(flow: flow));
      case transactionDetails:
        final recipient = settings.arguments as TransferRecipient;
        return _page(TransactionDetailsScreen(recipient: recipient));

      // ---- Fiat flows (Bank / Card / Wallet) ----
      case fiatTransferDetails:
        final transfer = settings.arguments as FiatTransfer;
        return _page(TransferDetailsScreen(transfer: transfer));
      case fiatSelectRecipient:
        final transfer = settings.arguments as FiatTransfer;
        return _page(SelectRecipientScreen(transfer: transfer));
      case fiatAddRecipientShort:
        final transfer = settings.arguments as FiatTransfer;
        return _page(AddRecipientShortScreen(transfer: transfer));
      case fiatAddRecipientFull:
        final transfer = settings.arguments as FiatTransfer;
        return _page(AddRecipientFullScreen(transfer: transfer));
      case fiatAccountVerified:
        final transfer = settings.arguments as FiatTransfer;
        return _page(AccountVerifiedScreen(transfer: transfer));
      case fiatFxQuote:
        final transfer = settings.arguments as FiatTransfer;
        return _page(FxQuoteScreen(transfer: transfer));
      case fiatReviewTransfer:
        final transfer = settings.arguments as FiatTransfer;
        return _page(FiatReviewTransferScreen(transfer: transfer));
      case transferCompleted:
        final transfer = settings.arguments as FiatTransfer;
        return _page(TransferCompletedScreen(transfer: transfer));
      case fiatTransactionDetails:
        final transfer = settings.arguments as FiatTransfer;
        return _page(FiatTransactionDetailsScreen(transfer: transfer));

      case bankRedirect:
        final transfer = settings.arguments as FiatTransfer;
        return _page(BankRedirectScreen(transfer: transfer));
      case bankPaymentInstruction:
        final transfer = settings.arguments as FiatTransfer;
        return _page(PaymentInstructionScreen(transfer: transfer));

      case payWithCard:
        final transfer = settings.arguments as FiatTransfer;
        return _page(PayWithCardScreen(transfer: transfer));
      case cardVerification:
        final transfer = settings.arguments as FiatTransfer;
        return _page(CardVerificationScreen(transfer: transfer));

      case selectWallet:
        return _page(const SelectWalletScreen());

      default:
        return _page(Scaffold(
          body: Center(child: Text('No route defined for ${settings.name}')),
        ));
    }
  }

  static MaterialPageRoute _page(Widget child) {
    return MaterialPageRoute(builder: (_) => child);
  }
}