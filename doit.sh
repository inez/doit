echo "Hello world!"
/android/sdk/launch-emulator.sh > launch-emulator.log 2>&1 &
sleep 60
/android/sdk/platform-tools/adb shell getprop dev.bootcomplete
pwd
ls -al
/android/sdk/platform-tools/adb install /app.apk
/android/sdk/platform-tools/adb install /androidTest.apk
