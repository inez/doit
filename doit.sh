echo "Hello world!"
/android/sdk/launch-emulator.sh > launch-emulator.log 2>&1 &
sleep 75
echo "Hello world 1!"
/android/sdk/platform-tools/adb shell getprop dev.bootcomplete
/android/sdk/platform-tools/adb shell getprop dev.bootcomplete
/android/sdk/platform-tools/adb shell getprop dev.bootcomplete
echo "Hello world 2!"
pwd
ls -al
/android/sdk/platform-tools/adb install /app.apk
/android/sdk/platform-tools/adb install /androidTest.apk
/android/sdk/platform-tools/adb shell am instrument -w -m --no-window-animation -e debug false -e class com.squareup.instrumentation.tests.ActivateSquareCardSwipeTest#swipeForCardVerification com.squareup.instrumentation
