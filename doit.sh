EVEN_RANDOM_NUMBER = 1024 + rand(0..20000) * 2
PORT1 = EVEN_RANDOM_NUMBER
PORT2 = EVEN_RANDOM_NUMBER + 1
ANDROID_ADB_SERVER_PORT = EVEN_RANDOM_NUMBER + 2

`ANDROID_ADB_SERVER_PORT=#{ANDROID_ADB_SERVER_PORT} /opt/android-sdk/platform-tools/adb start-server`

sleep 1

Thread.new {
  `ANDROID_ADB_SERVER_PORT=#{ANDROID_ADB_SERVER_PORT} /opt/android-sdk/emulator/emulator -ports #{PORT1},#{PORT2} -avd EmulatorInDocker -skip-adb-auth -no-window -gpu swiftshader_indirect -no-snapshot -noaudio -no-boot-anim > /root/emulator.log`
}

sleep 30

`ANDROID_ADB_SERVER_PORT=#{ANDROID_ADB_SERVER_PORT} /opt/android-sdk/platform-tools/adb -s emulator-#{PORT1} wait-for-device shell 'while [[ -z $(getprop sys.boot_completed) ]]; do sleep 1; done;'`

sleep 3

`ANDROID_ADB_SERVER_PORT=#{ANDROID_ADB_SERVER_PORT} /opt/android-sdk/platform-tools/adb -s emulator-#{PORT1} install /root/app.apk`

sleep 3

`ANDROID_ADB_SERVER_PORT=#{ANDROID_ADB_SERVER_PORT} /opt/android-sdk/platform-tools/adb -s emulator-#{PORT1} install /root/androidTest.apk`

`ANDROID_ADB_SERVER_PORT=#{ANDROID_ADB_SERVER_PORT} /opt/android-sdk/platform-tools/adb -s emulator-#{PORT1} shell am instrument -w -m --no-window-animation -e debug false -e class com.squareup.instrumentation.tests.ActivateSquareCardSwipeTest#swipeForCardVerification com.squareup.instrumentation > /root/instrument.log`
