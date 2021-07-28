EVEN_RANDOM_NUMBER = 1024 + rand(0..20000) * 2
PORT1 = EVEN_RANDOM_NUMBER
PORT2 = EVEN_RANDOM_NUMBER + 1
ANDROID_ADB_SERVER_PORT = EVEN_RANDOM_NUMBER + 2

puts "PORT1: #{PORT1}"
puts "PORT2: #{PORT2}"
puts "ANDROID_ADB_SERVER_PORT: #{ANDROID_ADB_SERVER_PORT}"

`ANDROID_ADB_SERVER_PORT=#{ANDROID_ADB_SERVER_PORT} /opt/android-sdk/platform-tools/adb start-server`

raise unless $?.success?

sleep 1

Thread.new {
  `ANDROID_ADB_SERVER_PORT=#{ANDROID_ADB_SERVER_PORT} /opt/android-sdk/emulator/emulator -ports #{PORT1},#{PORT2} -avd EmulatorInDocker -skip-adb-auth -no-window -gpu swiftshader_indirect -no-snapshot -noaudio -no-boot-anim > /root/emulator.log`
}

sleep 30

`ANDROID_ADB_SERVER_PORT=#{ANDROID_ADB_SERVER_PORT} /opt/android-sdk/platform-tools/adb -s emulator-#{PORT1} wait-for-device shell 'while [[ -z $(getprop sys.boot_completed) ]]; do sleep 1; done;'`
raise unless $?.success?

sleep 3

`ANDROID_ADB_SERVER_PORT=#{ANDROID_ADB_SERVER_PORT} /opt/android-sdk/platform-tools/adb -s emulator-#{PORT1} install /root/app.apk`
raise unless $?.success?

sleep 3

`ANDROID_ADB_SERVER_PORT=#{ANDROID_ADB_SERVER_PORT} /opt/android-sdk/platform-tools/adb -s emulator-#{PORT1} install /root/androidTest.apk`
raise unless $?.success?

puts "About to start tests"

`ANDROID_ADB_SERVER_PORT=#{ANDROID_ADB_SERVER_PORT} /opt/android-sdk/platform-tools/adb -s emulator-#{PORT1} shell am instrument -w -m --no-window-animation -e debug false -e class com.squareup.instrumentation.tests.ActivateSquareCardSwipeTest#swipeForCardVerification,com.squareup.instrumentation.tests.CancelSquareCardTest#cancelCardForGenericReason_cancelBizbankingSuccess_userSubmitsFeedback,com.squareup.instrumentation.tests.DeepLinkPasscodeTest#noPermissions_grantPermissions_pairingR12,com.squareup.instrumentation.tests.NetworkErrorsTest#testSessionExpired,com.squareup.instrumentation.tests.OrderTicketsTest#removeCardOnTicketIdentifierScreenCancel,com.squareup.instrumentation.tests.PosLoginTest#testUnitScreenBackToBeginning,com.squareup.instrumentation.tests.PrintersSettingsTest#printCompactTicketsSwitch_stateIsPersistedAfterSavingChanges,com.squareup.instrumentation.tests.PrintingTest#orderTicketNameActionBarWorksOnPhone,com.squareup.instrumentation.tests.SquareCardMailOrderTest#stampsHittingClearShouldDeleteAllStamps,com.squareup.instrumentation.tests.bizbanking.ResetSquareCardPinTest#resetPin_WeakPasscode,com.squareup.instrumentation.tests.crm.ManageLoyaltyTest#adjustPoints_twice,com.squareup.instrumentation.tests.loyalty.LoyaltyEnrollmentIntegrationTest#alwaysShowLoyalty_cashNoReceipt_skipEnrollment,com.squareup.instrumentation.tests.loyalty.LoyaltyEnrollmentMiscTest#cardPayment_noReceipt_doesNotPrefillBecauseCanada,com.squareup.instrumentation.tests.orderhub.OrderHubOrderDetailsTest#cancelOrder_continueToRefund,com.squareup.instrumentation.tests.orderhub.OrderHubOverviewScreenTest#ensureEmptyOrder_hasProperDataDisplayedInDetailRow,com.squareup.instrumentation.tests.paymentflow.ContactlessPaymentFlowTest#splitTenderContactlessOnly,com.squareup.instrumentation.tests.paymentflow.OrdersPaymentMethodV2BartTest#selectCustomerCardOnFile_withOrdersEnabled,com.squareup.instrumentation.tests.paymentflow.PaymentMethodV2BartTest#cancelChargeCardOnFileFromSelectPaymentScreenPhone,com.squareup.instrumentation.tests.paymentflow.sqlitequeue.SqliteCapturesQueuePaymentMethodV2Test#giftCardDisabledOnZeroPayment_noCustomer,com.squareup.instrumentation.tests.redeemrewards.RedeemRewardByCodeTest#codeRedemption_redeemCouponTwice,com.squareup.instrumentation.tests.referrals.ReferralsV2OnboardingIntegrationTest#activationPrompt_verifyButtonGoesToOnBoarding,com.squareup.instrumentation.tests.settings.SignatureSettingsTest#collectSignatureToggleHiddenWhenNeverCollectSignatureFeatureDisabled com.squareup.instrumentation > /root/instrument.log`
raise unless $?.success?

puts "Done with tests"

puts `tail -100 /root/emulator.log`
puts `tail -100 /root/instrument.log`
