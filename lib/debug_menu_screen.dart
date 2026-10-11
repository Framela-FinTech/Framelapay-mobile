import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'core/routes/app_routes.dart';
import 'data/models/transfer_recipient.dart';
import 'data/models/transfer_auth_flow.dart';
import 'data/models/processing_step.dart';
import 'data/models/fiat_transfer.dart';
import 'data/models/fiat_beneficiary.dart';
import 'data/models/transfer_method.dart';

import 'features/onboarding/splash_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/auth/welcome_screen.dart';
import 'features/auth/create_account_screen.dart';
import 'features/auth/phone_verification_screen.dart';
import 'features/auth/create_password_screen.dart';
import 'features/biometrics/biometrics_setup_screen.dart';
import 'features/biometrics/fingerprint_capture_screen.dart';
import 'features/biometrics/biometrics_success_screen.dart';
import 'features/kyc/kyc_intro_screen.dart';
import 'features/kyc/kyc_step1_screen.dart';
import 'features/kyc/kyc_step2_screen.dart';
import 'features/kyc/kyc_id_type_screen.dart';
import 'features/kyc/kyc_document_capture_screen.dart';
import 'features/kyc/kyc_processing_screen.dart';
import 'features/kyc/kyc_selfie_capture_screen.dart';
import 'features/kyc/kyc_status_screen.dart';
import 'features/home/home_screen.dart';
import 'features/home/quick_actions_screen.dart';
import 'features/home/notifications_screen.dart';
import 'features/placeholder/coming_soon_screen.dart';
import 'features/wallet/wallet_tab_screen.dart';
import 'features/wallet/add_money_select_wallet_screen.dart';
import 'features/wallet/choose_method_screen.dart';
import 'features/wallet/fund_wallet_details_screen.dart';
import 'features/wallet/fund_card_screen.dart';
import 'features/wallet/add_money_success_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/profile/settings/settings_screen.dart';
import 'features/profile/settings/appearance_screen.dart';
import 'features/profile/settings/notifications_settings_screen.dart';
import 'features/profile/settings/language_region_screen.dart';
import 'features/profile/security/security_screen.dart';
import 'features/profile/security/password_screen.dart';
import 'features/profile/security/change_password_screen.dart';
import 'features/profile/security/reset_password_screen.dart';
import 'features/profile/security/verify_email_screen.dart';
import 'features/profile/security/create_new_password_screen.dart';
import 'features/profile/statements/statements_hub_screen.dart';
import 'features/profile/statements/account_statements_screen.dart';
import 'features/profile/statements/statement_ready_screen.dart';
import 'features/profile/statements/transaction_receipts_screen.dart';
import 'features/profile/statements/receipt_detail_screen.dart';
import 'features/profile/beneficiaries/beneficiaries_list_screen.dart';
import 'features/profile/beneficiaries/add_beneficiary_screen.dart';
import 'features/profile/beneficiaries/confirm_beneficiary_screen.dart';
import 'features/profile/beneficiaries/beneficiary_details_screen.dart';
import 'features/profile/beneficiaries/edit_beneficiary_screen.dart';
import 'features/profile/beneficiaries/remove_beneficiary_screen.dart';
import 'features/profile/photo/change_profile_photo_screen.dart';
import 'features/profile/photo/adjust_profile_photo_screen.dart';
import 'features/profile/photo/remove_profile_photo_screen.dart';
import 'features/profile/photo/profile_photo_removed_screen.dart';
import 'features/profile/widgets/profile_success_screen.dart';
import 'data/models/transaction_receipt.dart';
import 'data/models/currency_wallet.dart';

import 'features/transfer/shared/transfer_screen.dart';
import 'features/transfer/shared/send_stablecoin_wallet_screen.dart';
import 'features/transfer/shared/choose_network_screen.dart';
import 'features/transfer/shared/send_stablecoin_recipient_screen.dart';
import 'features/transfer/to_framela_user/find_framela_user_screen.dart';
import 'features/transfer/to_framela_user/enter_amount_screen.dart';
import 'features/transfer/to_external_wallet/enter_wallet_address_screen.dart';
import 'features/transfer/to_external_wallet/verify_wallet_address_screen.dart';
import 'features/transfer/shared/review_transfer_screen.dart';
import 'features/transfer/shared/verify_fingerprint_screen.dart';
import 'features/transfer/shared/enter_passcode_screen.dart';
import 'features/transfer/shared/processing_transfer_screen.dart';
import 'features/transfer/shared/transaction_details_screen.dart';

import 'features/transfer/fiat/transfer_details_screen.dart';
import 'features/transfer/fiat/select_recipient_screen.dart';
import 'features/transfer/fiat/add_recipient_short_screen.dart';
import 'features/transfer/fiat/add_recipient_full_screen.dart';
import 'features/transfer/fiat/account_verified_screen.dart';
import 'features/transfer/fiat/fx_quote_screen.dart';
import 'features/transfer/fiat/fiat_review_transfer_screen.dart';
import 'features/transfer/fiat/transfer_completed_screen.dart';
import 'features/transfer/fiat/fiat_transaction_details_screen.dart';
import 'features/transfer/bank/bank_redirect_screen.dart';
import 'features/transfer/bank/payment_instruction_screen.dart';
import 'features/transfer/card/pay_with_card_screen.dart';
import 'features/transfer/card/card_verification_screen.dart';
import 'features/transfer/wallet/select_wallet_screen.dart';

/// Sample recipient used only for previewing screens in this debug menu.
/// Real recipients are built dynamically during the actual app flow.
const _sampleRecipient = TransferRecipient(
  type: RecipientType.framelaUser,
  name: 'Cynthia Nkechi',
  handle: '@cynthian',
  walletAddress: '0x8a71...94cd',
);

/// Sample auth/processing continuation for previewing the shared auth gate
/// and processing screens (they no longer take a recipient directly).
const _sampleAuthFlow = TransferAuthFlow(
  completionRoute: AppRoutes.transactionDetails,
  completionArgs: _sampleRecipient,
  processingSteps: [
    ProcessingStep(
        title: 'Transfer initiated',
        time: '10:41 AM',
        subtitle: 'Your transfer has been created',
        done: true),
    ProcessingStep(
        title: 'Finalizing transfer', subtitle: 'Almost there...'),
  ],
);

/// Sample fiat transfer used to preview the Bank/Card/Wallet screens.
const _sampleFiatBeneficiary = FiatBeneficiary(
  fullName: 'Ken Okafor',
  bankName: 'GTBank',
  accountNumber: '0071231234',
  country: 'Nigeria',
  purpose: 'Family support',
);

const _sampleFiatTransfer = FiatTransfer(
  method: TransferMethod.bank,
  beneficiary: _sampleFiatBeneficiary,
);

/// Sample wallet used to preview the Add Money screens.
const _sampleWallet = CurrencyWallet(
  code: 'EUR',
  name: 'Euro',
  symbol: '€',
  balance: 2500,
);

class DebugMenuScreen extends StatelessWidget {
  const DebugMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = <String, Map<String, Widget>>{
      'Onboarding & Auth': {
        'Splash': const SplashScreen(),
        'Onboarding Carousel': const OnboardingScreen(),
        'Welcome': const WelcomeScreen(),
        'Create Account': const CreateAccountScreen(),
        'Phone Verification':
            const PhoneVerificationScreen(phoneNumber: '+234 812 345 6789'),
        'Create Password': const CreatePasswordScreen(),
      },
      'Biometrics': {
        'Biometrics Setup': const BiometricsSetupScreen(),
        'Fingerprint Capture': const FingerprintCaptureScreen(),
        'Biometrics Success': const BiometricsSuccessScreen(),
      },
      'KYC Verification': {
        'KYC Intro': const KycIntroScreen(),
        'KYC Step 1 - Personal Details': const KycStep1Screen(),
        'KYC Step 2 - About You': const KycStep2Screen(),
        'KYC ID Type': const KycIdTypeScreen(),
        'KYC Document Capture': const KycDocumentCaptureScreen(),
        'KYC Processing (generic)':
            const KycProcessingScreen(nextRoute: AppRoutes.kycSelfieCapture),
        'KYC Selfie Capture': const KycSelfieCaptureScreen(),
        'KYC Status - Pending': const KycStatusScreen(isVerified: false),
        'KYC Status - Verified': const KycStatusScreen(isVerified: true),
      },
      'Home': {
        'Home Dashboard': const HomeScreen(),
        'Quick Actions Menu': const QuickActionsScreen(),
        'Notifications': const NotificationsScreen(),
      },
      'Wallet / Add Money': {
        'Wallet Tab': const WalletTabScreen(),
        'Wallet Tab (Action required)':
            const WalletTabScreen(forceActionRequired: true),
        'Add Money - Select Wallet': const AddMoneySelectWalletScreen(),
        'Choose Method': const ChooseMethodScreen(wallet: _sampleWallet),
        'Fund Wallet (bank details)':
            const FundWalletDetailsScreen(wallet: _sampleWallet),
        'Fund with Card': const FundCardScreen(wallet: _sampleWallet),
        'Add Money Success':
            const AddMoneySuccessScreen(wallet: _sampleWallet),
      },
      'Profile': {
        'Profile Hub': const ProfileScreen(),
      },
      'Profile / Settings': {
        'Settings Hub': const SettingsScreen(),
        'Appearance': const AppearanceScreen(),
        'Notifications': const NotificationsSettingsScreen(),
        'Language & Region': const LanguageRegionScreen(),
      },
      'Profile / Security': {
        'Security Hub': const SecurityScreen(),
        'Password (Change/Reset)': const PasswordScreen(),
        'Change Password': const ChangePasswordScreen(),
        'Reset Password - Email': const ResetPasswordScreen(),
        'Reset Password - Verify Email':
            const VerifyEmailScreen(email: 'cynthia.nkechi@email.com'),
        'Reset Password - Create New': const CreateNewPasswordScreen(),
      },
      'Profile / Statements': {
        'Statements & Receipts Hub': const StatementsHubScreen(),
        'Account Statements': const AccountStatementsScreen(),
        'Statement Ready': const StatementReadyScreen(
            summary: 'EUR Wallet • 2026-06-01 to 2026-09-30'),
        'Transaction Receipts': const TransactionReceiptsScreen(),
        'Receipt Detail': ReceiptDetailScreen(receipt: sampleReceipts[0]),
      },
      'Profile / Photo': {
        'Change Profile Photo': const ChangeProfilePhotoScreen(),
        'Adjust Profile Photo': const AdjustProfilePhotoScreen(),
        'Photo Updated': const ProfileSuccessScreen(
          title: 'Profile photo updated',
          message: 'Your new profile photo is now visible on your account.',
          primary: SuccessButton('Return to Profile', AppRoutes.profile),
        ),
        'Remove Profile Photo?': const RemoveProfilePhotoScreen(),
        'Profile Photo Removed': const ProfilePhotoRemovedScreen(),
      },
      'Profile / Beneficiaries': {
        'Beneficiaries List': const BeneficiariesListScreen(),
        'Add Beneficiary': const AddBeneficiaryScreen(),
        'Confirm Beneficiary':
            ConfirmBeneficiaryScreen(beneficiary: sampleBeneficiaries[0]),
        'Beneficiary Saved': const ProfileSuccessScreen(
          title: 'Beneficiary saved',
          message: 'This recipient is now available in your saved list.',
          primary:
              SuccessButton('Return to Beneficiaries', AppRoutes.beneficiariesList),
        ),
        'Beneficiary Details':
            BeneficiaryDetailsScreen(beneficiary: sampleBeneficiaries[0]),
        'Edit Beneficiary':
            EditBeneficiaryScreen(beneficiary: sampleBeneficiaries[0]),
        'Remove Beneficiary':
            RemoveBeneficiaryScreen(beneficiary: sampleBeneficiaries[0]),
      },
      'Bottom Nav Stubs': {
        'Activity (Coming soon)':
            const ComingSoonScreen(title: 'Activity', navIndex: 3),
      },
      'Stablecoin Transfer': {
        'Transfer Hub': const TransferScreen(),
        'Send Stablecoin - Wallet': const SendStablecoinWalletScreen(),
        'Choose Network': const ChooseNetworkScreen(),
        'Who Are You Sending To': const SendStablecoinRecipientScreen(),
        'Find FramelaPay User': const FindFramelaUserScreen(),
        'Enter Amount (to FramelaPay user)': const EnterAmountScreen(),
        'Enter Wallet Address (external)': const EnterWalletAddressScreen(),
        'Verify Wallet Address (external)': const VerifyWalletAddressScreen(),
        'Review Transfer':
            const ReviewTransferScreen(recipient: _sampleRecipient),
        'Verify Fingerprint':
            const VerifyFingerprintScreen(flow: _sampleAuthFlow),
        'Enter Passcode': const EnterPasscodeScreen(flow: _sampleAuthFlow),
        'Processing Transfer':
            const ProcessingTransferScreen(flow: _sampleAuthFlow),
        'Transaction Details':
            const TransactionDetailsScreen(recipient: _sampleRecipient),
      },
      'Fiat Transfer (Bank / Card / Wallet)': {
        'Transfer Details':
            const TransferDetailsScreen(transfer: _sampleFiatTransfer),
        'Select Recipient':
            const SelectRecipientScreen(transfer: _sampleFiatTransfer),
        'Add Recipient (short)':
            const AddRecipientShortScreen(transfer: _sampleFiatTransfer),
        'Add Recipient (full)':
            const AddRecipientFullScreen(transfer: _sampleFiatTransfer),
        'Account Verified':
            const AccountVerifiedScreen(transfer: _sampleFiatTransfer),
        'FX Quote': const FxQuoteScreen(transfer: _sampleFiatTransfer),
        '[Bank] Redirect':
            const BankRedirectScreen(transfer: _sampleFiatTransfer),
        '[Bank] Payment Instruction':
            const PaymentInstructionScreen(transfer: _sampleFiatTransfer),
        '[Card] Pay with Card':
            const PayWithCardScreen(transfer: _sampleFiatTransfer),
        '[Card] Card Verification':
            const CardVerificationScreen(transfer: _sampleFiatTransfer),
        '[Wallet] Select Wallet': const SelectWalletScreen(),
        'Review Transfer (fiat)':
            const FiatReviewTransferScreen(transfer: _sampleFiatTransfer),
        'Transfer Completed':
            const TransferCompletedScreen(transfer: _sampleFiatTransfer),
        'Transaction Details (fiat)':
            const FiatTransactionDetailsScreen(transfer: _sampleFiatTransfer),
      },
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        title: const Text('Framela — Screen Preview',
            style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
      body: ListView(
        children: sections.entries.map((section) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: Text(
                  section.key,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.textGrey,
                    letterSpacing: 1,
                  ),
                ),
              ),
              ...section.value.entries.map((entry) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(entry.key),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => entry.value),
                      ),
                    ),
                    const Divider(height: 1),
                  ],
                );
              }),
            ],
          );
        }).toList(),
      ),
    );
  }
}