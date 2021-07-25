#!/bin/bash
echo "Hello world 25.1!"
/android/sdk/launch-emulator.sh > launch-emulator.log 2>&1 &
echo "Hello world 25.2!"
sleep 100
echo "Hello world 25.3!"
/android/sdk/platform-tools/adb shell getprop dev.bootcomplete
/android/sdk/platform-tools/adb install /app.apk
/android/sdk/platform-tools/adb install /androidTest.apk
echo "Hello world 25.4!"
# sleep $[ ( $RANDOM % 30 )  + 1 ]s
# /android/sdk/launch-emulator.sh > launch-emulator.log 2>&1 &
# sleep 120
# /android/sdk/platform-tools/adb shell am instrument -w -m --no-window-animation -e debug false -e class com.squareup.instrumentation.tests.ActivateSquareCardSwipeTest#swipeForCardVerification com.squareup.instrumentation
# /android/sdk/platform-tools/adb shell getprop dev.bootcomplete
# /android/sdk/platform-tools/adb shell am instrument -w -m --no-window-animation -e debug false -e class com.squareup.instrumentation.tests.ActivateSquareCardSwipeTest#swipeForCardVerification,com.squareup.instrumentation.tests.CancelSquareCardTest#cancelCardForGenericReason_cancelBizbankingSuccess_userSubmitsFeedback,com.squareup.instrumentation.tests.DeepLinkPasscodeTest#noPermissions_grantPermissions_pairingR12,com.squareup.instrumentation.tests.NetworkErrorsTest#testSessionExpired,com.squareup.instrumentation.tests.OrderTicketsTest#removeCardOnTicketIdentifierScreenCancel,com.squareup.instrumentation.tests.PosLoginTest#testUnitScreenBackToBeginning,com.squareup.instrumentation.tests.PrintersSettingsTest#printCompactTicketsSwitch_stateIsPersistedAfterSavingChanges,com.squareup.instrumentation.tests.PrintingTest#orderTicketNameActionBarWorksOnPhone,com.squareup.instrumentation.tests.SquareCardMailOrderTest#stampsHittingClearShouldDeleteAllStamps,com.squareup.instrumentation.tests.bizbanking.ResetSquareCardPinTest#resetPin_WeakPasscode,com.squareup.instrumentation.tests.crm.ManageLoyaltyTest#adjustPoints_twice,com.squareup.instrumentation.tests.loyalty.LoyaltyEnrollmentIntegrationTest#alwaysShowLoyalty_cashNoReceipt_skipEnrollment,com.squareup.instrumentation.tests.loyalty.LoyaltyEnrollmentMiscTest#cardPayment_noReceipt_doesNotPrefillBecauseCanada,com.squareup.instrumentation.tests.orderhub.OrderHubOrderDetailsTest#cancelOrder_continueToRefund,com.squareup.instrumentation.tests.orderhub.OrderHubOverviewScreenTest#ensureEmptyOrder_hasProperDataDisplayedInDetailRow,com.squareup.instrumentation.tests.paymentflow.ContactlessPaymentFlowTest#splitTenderContactlessOnly,com.squareup.instrumentation.tests.paymentflow.OrdersPaymentMethodV2BartTest#selectCustomerCardOnFile_withOrdersEnabled,com.squareup.instrumentation.tests.paymentflow.PaymentMethodV2BartTest#cancelChargeCardOnFileFromSelectPaymentScreenPhone,com.squareup.instrumentation.tests.paymentflow.sqlitequeue.SqliteCapturesQueuePaymentMethodV2Test#giftCardDisabledOnZeroPayment_noCustomer,com.squareup.instrumentation.tests.redeemrewards.RedeemRewardByCodeTest#codeRedemption_redeemCouponTwice,com.squareup.instrumentation.tests.referrals.ReferralsV2OnboardingIntegrationTest#activationPrompt_verifyButtonGoesToOnBoarding,com.squareup.instrumentation.tests.settings.SignatureSettingsTest#collectSignatureToggleHiddenWhenNeverCollectSignatureFeatureDisabled com.squareup.instrumentation
# /android/sdk/platform-tools/adb shell getprop dev.bootcomplete
# cat launch-emulator.log
