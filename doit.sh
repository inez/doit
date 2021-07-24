echo "Hello world!"
/android/sdk/launch-emulator.sh &
sleep 60
/android/sdk/platform-tools/adb shell getprop dev.bootcomplete
