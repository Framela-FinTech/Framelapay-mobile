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
import '../../features/activity/activity_screen.dart';
import '../../features/wallet/wallet_tab_screen.dart';
import '../../features/wallet/add_money_select_wallet_screen.dart';
import '../../features/wallet/choose_method_screen.dart';
import '../../features/wallet/fund_wallet_details_screen.dart';
import '../../features/wallet/fund_card_screen.dart';
import '../../features/wallet/add_money_success_screen.dart';
import '../../features/wallet/receive_money_screen.dart';
import '../../features/wallet/receive_details_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/profile/widgets/profile_placeholder_screen.dart';
import '../../features/profile/settings/settings_screen.dart';
import '../../features/profile/settings/appearance_screen.dart';
import '../../features/profile/settings/notifications_settings_screen.dart';
import '../../features/profile/settings/language_region_screen.dart';
import '../../features/profile/security/security_screen.dart';
import '../../features/profile/security/password_screen.dart';
import '../../features/profile/security/change_password_screen.dart';
import '../../features/profile/security/reset_password_screen.dart';
import '../../features/profile/security/verify_email_screen.dart';
import '../../features/profile/security/create_new_password_screen.dart';
import '../../features/profile/statements/statements_hub_screen.dart';
import '../../features/profile/statements/account_statements_screen.dart';
import '../../features/profile/statements/statement_ready_screen.dart';
import '../../features/profile/statements/transaction_receipts_screen.dart';
import '../../features/profile/statements/receipt_detail_screen.dart';
import '../../features/profile/beneficiaries/beneficiaries_list_screen.dart';
import '../../features/profile/beneficiaries/add_beneficiary_screen.dart';
import '../../features/profile/beneficiaries/confirm_beneficiary_screen.dart';
import '../../features/profile/beneficiaries/beneficiary_details_screen.dart';
import '../../features/profile/beneficiaries/edit_beneficiary_screen.dart';
import '../../features/profile/beneficiaries/remove_beneficiary_screen.dart';
import '../../features/profile/photo/change_profile_photo_screen.dart';
import '../../features/profile/photo/adjust_profile_photo_screen.dart';
import '../../features/profile/photo/remove_profile_photo_screen.dart';
import '../../features/profile/photo/profile_photo_removed_screen.dart';
import '../../features/profile/kyc/profile_kyc_status_screen.dart';
import '../../features/profile/kyc/upgrade_verification_screen.dart';
import '../../features/profile/kyc/identity_verification_screen.dart';
import '../../features/profile/kyc/address_verification_screen.dart';
import '../../features/profile/kyc/source_of_funds_screen.dart';
import '../../features/profile/kyc/review_verification_screen.dart';
import '../../features/profile/kyc/verification_submitted_screen.dart';
import '../../features/profile/kyc/verification_successful_screen.dart';
import '../../features/profile/widgets/profile_success_screen.dart';
import '../../features/profile/support/help_support_screens.dart';
import '../../features/profile/account_controls/deactivate_account_screens.dart';
import '../../features/profile/account_controls/sign_out_screens.dart';
import '../../features/profile/referral/referral_screen.dart';
import '../../features/profile/security/trusted_devices_screens.dart';
import '../../data/models/transaction_receipt.dart';
import '../../data/models/fiat_beneficiary.dart';
import '../../data/models/currency_wallet.dart';
import '../../data/models/support_models.dart';

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
import '../../features/transfer/shared/stablecoin_completed_screen.dart';

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
import '../../features/transfer/wallet/convert_select_wallet_screen.dart';
import '../../features/transfer/wallet/convert_funds_screen.dart';
import '../../features/transfer/wallet/conversion_completed_screen.dart';
import '../../features/transfer/wallet/conversion_receipt_screen.dart';
import '../../data/models/conversion_result.dart';
import '../../data/models/exchange_rate.dart';
import '../../features/exchange/exchange_rates_screen.dart';
import '../../features/exchange/select_currency_pair_screen.dart';
import '../../features/exchange/currency_pair_updated_screen.dart';
import '../../features/exchange/rate_pair_detail_screen.dart';
import '../../features/exchange/rate_alerts_screen.dart';
import '../../features/exchange/rate_alert_form_screen.dart';
import '../../features/exchange/rate_alert_created_screen.dart';
import '../../data/models/rate_alert.dart';
import '../../data/models/currency_wallet.dart';

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

  // Bottom-nav tab destinations.
  static const walletTab = '/wallet-tab';
  static const activity = '/activity';
  static const profile = '/profile';

  // Add Money flow (fund a wallet).
  static const addMoneySelectWallet = '/add-money-select-wallet';
  static const chooseMethod = '/choose-method';
  static const fundWalletDetails = '/fund-wallet-details';
  static const fundCard = '/fund-card';
  static const addMoneySuccess = '/add-money-success';

  // Receive Money flow.
  static const receive = '/receive';
  static const receiveDetails = '/receive/details';

  // Profile section.
  static const personalInformation = '/personal-information';
  static const referral = '/referral';
  static const helpSupport = '/help-support';
  static const helpCentre = '/help-centre';
  static const helpArticle = '/help-centre/article';
  static const liveSupport = '/live-support';
  static const supportRequests = '/support-requests';
  static const reportProblem = '/report-problem';
  static const startLiveSupport = '/start-live-support';
  static const deactivateAccount = '/deactivate-account';
  static const accountCheck = '/deactivate-account/check';
  static const deactivateDetails = '/deactivate-account/details';
  static const securityVerification = '/deactivate-account/verification';
  static const accountDeactivated = '/deactivate-account/complete';
  static const reactivateAccount = '/reactivate-account';
  static const accountReactivated = '/reactivate-account/complete';
  static const signOut = '/sign-out';
  static const login = '/login';
  static const changePhoto = '/change-photo';
  static const adjustProfilePhoto = '/change-photo/adjust';
  static const photoUpdated = '/change-photo/updated';
  static const removeProfilePhoto = '/change-photo/remove';
  static const profilePhotoRemoved = '/change-photo/removed';
  // Sub-flow entry points (screens land in their own sub-flows).
  static const profileKycStatus = '/profile-kyc-status';
  // Profile KYC upgrade (Tier 2 -> Tier 3). Separate from onboarding KYC.
  static const profileKycUpgrade = '/profile-kyc/upgrade';
  static const profileKycIdentity = '/profile-kyc/identity';
  static const profileKycAddress = '/profile-kyc/address';
  static const profileKycSourceOfFunds = '/profile-kyc/source-of-funds';
  static const profileKycReview = '/profile-kyc/review';
  static const profileKycSubmitted = '/profile-kyc/submitted';
  static const profileKycSuccessful = '/profile-kyc/successful';
  static const beneficiariesList = '/beneficiaries';
  static const statementsHub = '/statements';
  static const securityHome = '/security';
  static const settingsHome = '/settings';
  // Settings sub-screens.
  static const appearance = '/settings/appearance';
  static const notificationsSettings = '/settings/notifications';
  static const languageRegion = '/settings/language-region';
  // Security sub-screens.
  static const securityPassword = '/security/password';
  static const changePassword = '/security/change-password';
  static const resetPassword = '/security/reset-password';
  static const resetVerifyEmail = '/security/reset-password/verify-email';
  static const createNewPassword = '/security/reset-password/create';
  static const transactionPin = '/security/transaction-pin';
  static const trustedDevices = '/security/trusted-devices';
  static const deviceDetails = '/security/trusted-devices/detail';
  static const removeDevice = '/security/trusted-devices/remove';
  static const deviceActionComplete = '/security/trusted-devices/complete';
  // Beneficiaries sub-screens.
  static const addBeneficiary = '/beneficiaries/add';
  static const confirmBeneficiary = '/beneficiaries/confirm';
  static const beneficiarySaved = '/beneficiaries/saved';
  static const beneficiaryDetails = '/beneficiaries/detail';
  static const editBeneficiary = '/beneficiaries/edit';
  static const removeBeneficiary = '/beneficiaries/remove';
  // Statements & Receipts sub-screens.
  static const accountStatements = '/statements/account';
  static const statementReady = '/statements/ready';
  static const transactionReceipts = '/statements/receipts';
  static const receiptDetail = '/statements/receipts/detail';

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
  static const stablecoinCompleted = '/stablecoin-completed';
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

  // Standalone conversion journey (Conversion board), reached from the Wallet
  // tab. Converting mid-transfer from Send Money uses the bottom sheet.
  // Exchange rates (Exchange board). Rate alerts are a later pass.
  static const exchangeRates = '/exchange-rates';
  static const selectCurrencyPair = '/exchange-rates/select-pair';
  static const currencyPairUpdated = '/exchange-rates/pair-updated';
  static const ratePairDetail = '/exchange-rates/pair';
  static const rateAlerts = '/exchange-rates/alerts';
  static const rateAlertForm = '/exchange-rates/alerts/edit';
  static const rateAlertCreated = '/exchange-rates/alerts/created';

  static const convertSelectWallet = '/convert-select-wallet';
  static const convertFunds = '/convert-funds';
  static const conversionCompleted = '/conversion-completed';
  static const conversionReceipt = '/conversion-receipt';

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
        return _page(const ActivityScreen());

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

      case receive:
        return _page(const ReceiveMoneyScreen());
      case receiveDetails:
        final wallet = settings.arguments as CurrencyWallet;
        return _page(ReceiveDetailsScreen(wallet: wallet));

      // ---- Profile section ----
      case profile:
        return _page(const ProfileScreen());
      // Permanent "Coming soon" placeholders.
      case personalInformation:
        return _page(
            const ProfilePlaceholderScreen(title: 'Personal Information'));
      case referral:
        return _page(const ReferralScreen());
      case helpSupport:
        return _page(const HelpSupportScreen());
      case helpCentre:
        return _page(const HelpCentreScreen());
      case helpArticle:
        final article = settings.arguments is HelpArticle
            ? settings.arguments as HelpArticle
            : null;
        if (article == null) return _page(const HelpCentreScreen());
        return _page(HelpArticleScreen(article: article));
      case liveSupport:
        return _page(const LiveSupportScreen());
      case supportRequests:
        return _page(const SupportRequestsScreen());
      case reportProblem:
        return _page(const ReportProblemScreen());
      case startLiveSupport:
        return _page(const StartLiveSupportScreen());
      case deactivateAccount:
        return _page(const DeactivateAccountScreen());
      case accountCheck:
        return _page(const AccountCheckScreen());
      case deactivateDetails:
        return _page(const DeactivateDetailsScreen());
      case securityVerification:
        return _page(const SecurityVerificationScreen());
      case accountDeactivated:
        return _page(const AccountDeactivatedScreen());
      case reactivateAccount:
        return _page(const ReactivateAccountScreen());
      case accountReactivated:
        return _page(const AccountReactivatedScreen());
      case signOut:
        return _page(const SignOutScreen());
      case login:
        return _page(const LoginScreen());
      // Temporary placeholders — repointed when each sub-flow is built.
      case changePhoto:
        return _page(const ChangeProfilePhotoScreen());
      case adjustProfilePhoto:
        return _page(const AdjustProfilePhotoScreen());
      case photoUpdated:
        return _page(const ProfileSuccessScreen(
          title: 'Profile photo updated',
          message: 'Your new profile photo is now visible on your account.',
          primary: SuccessButton('Return to Profile', profile),
        ));
      case removeProfilePhoto:
        return _page(const RemoveProfilePhotoScreen());
      case profilePhotoRemoved:
        return _page(const ProfilePhotoRemovedScreen());
      case profileKycStatus:
        return _page(const ProfileKycStatusScreen());
      case profileKycUpgrade:
        return _page(const UpgradeVerificationScreen());
      case profileKycIdentity:
        return _page(const IdentityVerificationScreen());
      case profileKycAddress:
        return _page(const AddressVerificationScreen());
      case profileKycSourceOfFunds:
        return _page(const SourceOfFundsScreen());
      case profileKycReview:
        return _page(const ReviewVerificationScreen());
      case profileKycSubmitted:
        return _page(const VerificationSubmittedScreen());
      case profileKycSuccessful:
        return _page(const VerificationSuccessfulScreen());
      case beneficiariesList:
        return _page(const BeneficiariesListScreen());
      case addBeneficiary:
        return _page(const AddBeneficiaryScreen());
      case confirmBeneficiary:
        final beneficiary = settings.arguments as FiatBeneficiary;
        return _page(ConfirmBeneficiaryScreen(beneficiary: beneficiary));
      case beneficiarySaved:
        return _page(const ProfileSuccessScreen(
          title: 'Beneficiary saved',
          message: 'This recipient is now available in your saved list.',
          primary: SuccessButton('Return to Beneficiaries', beneficiariesList),
        ));
      case beneficiaryDetails:
        final beneficiary = settings.arguments as FiatBeneficiary;
        return _page(BeneficiaryDetailsScreen(beneficiary: beneficiary));
      case editBeneficiary:
        final beneficiary = settings.arguments as FiatBeneficiary;
        return _page(EditBeneficiaryScreen(beneficiary: beneficiary));
      case removeBeneficiary:
        final beneficiary = settings.arguments as FiatBeneficiary;
        return _page(RemoveBeneficiaryScreen(beneficiary: beneficiary));
      case statementsHub:
        return _page(const StatementsHubScreen());
      case accountStatements:
        return _page(const AccountStatementsScreen());
      case statementReady:
        final summary = settings.arguments as String? ?? '';
        return _page(StatementReadyScreen(summary: summary));
      case transactionReceipts:
        return _page(const TransactionReceiptsScreen());
      case receiptDetail:
        final receipt = settings.arguments as TransactionReceipt;
        return _page(ReceiptDetailScreen(receipt: receipt));
      case securityHome:
        return _page(const SecurityScreen());
      case securityPassword:
        return _page(const PasswordScreen());
      case changePassword:
        return _page(const ChangePasswordScreen());
      case resetPassword:
        return _page(const ResetPasswordScreen());
      case resetVerifyEmail:
        final email = settings.arguments as String? ?? '';
        return _page(VerifyEmailScreen(email: email));
      case createNewPassword:
        return _page(const CreateNewPasswordScreen());
      case transactionPin:
        return _page(const ProfilePlaceholderScreen(title: 'Transaction PIN'));
      case trustedDevices:
        return _page(const TrustedDevicesScreen());
      case deviceDetails:
        final current = settings.arguments is bool
            ? settings.arguments as bool
            : true;
        return _page(DeviceDetailsScreen(current: current));
      case removeDevice:
        return _page(const RemoveDeviceScreen());
      case deviceActionComplete:
        return _page(const DeviceActionCompleteScreen());
      case settingsHome:
        return _page(const SettingsScreen());
      case appearance:
        return _page(const AppearanceScreen());
      case notificationsSettings:
        return _page(const NotificationsSettingsScreen());
      case languageRegion:
        return _page(const LanguageRegionScreen());

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
      case stablecoinCompleted:
        final recipient = settings.arguments as TransferRecipient;
        return _page(StablecoinCompletedScreen(recipient: recipient));
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

      case exchangeRates:
        return _page(const ExchangeRatesScreen());

      case selectCurrencyPair:
        return _page(const SelectCurrencyPairScreen());

      case currencyPairUpdated:
        return _page(CurrencyPairUpdatedScreen(
            pair: settings.arguments as CurrencyPair));

      case ratePairDetail:
        return _page(
            RatePairDetailScreen(pair: settings.arguments as CurrencyPair));

      case rateAlerts:
        return _page(const RateAlertsScreen());

      case rateAlertForm:
        // Null argument creates a new alert; a RateAlert edits that one.
        return _page(
            RateAlertFormScreen(alert: settings.arguments as RateAlert?));

      case rateAlertCreated:
        return _page(
            RateAlertCreatedScreen(alert: settings.arguments as RateAlert));

      case convertSelectWallet:
        return _page(const ConvertSelectWalletScreen());

      case convertFunds:
        return _page(
            ConvertFundsScreen(from: settings.arguments as CurrencyWallet?));

      case conversionCompleted:
        return _page(ConversionCompletedScreen(
            result: settings.arguments as ConversionResult));

      case conversionReceipt:
        return _page(ConversionReceiptScreen(
            result: settings.arguments as ConversionResult));

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
