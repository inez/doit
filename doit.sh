#!/bin/bash
echo "Hello world 25.1/1!"
/android/sdk/launch-emulator.sh > launch-emulator.log 2>&1 &
echo "Hello world 25.2!"
while [ "`/android/sdk/platform-tools/adb shell getprop sys.boot_completed | tr -d '\r' `" != "1" ] ; do sleep 1; done
echo "Hello world 25.3!"
/android/sdk/platform-tools/adb shell getprop dev.bootcomplete ; /android/sdk/platform-tools/adb install /app.apk ; /android/sdk/platform-tools/adb install /androidTest.apk ; /android/sdk/platform-tools/adb shell am instrument -w -m --no-window-animation -e debug false -e class com.squareup.instrumentation.tests.ActivateSquareCardSwipeTest#swipeForCardVerification com.squareup.instrumentation
