require 'timeout'

EVEN_RANDOM_NUMBER = 1024 + rand(0..20000) * 2
PORT1 = EVEN_RANDOM_NUMBER
PORT2 = EVEN_RANDOM_NUMBER + 1
ANDROID_ADB_SERVER_PORT = EVEN_RANDOM_NUMBER + 2

puts "PORT1: #{PORT1}"
puts "PORT2: #{PORT2}"
puts "ANDROID_ADB_SERVER_PORT: #{ANDROID_ADB_SERVER_PORT}"

`ANDROID_ADB_SERVER_PORT=#{ANDROID_ADB_SERVER_PORT} /opt/android-sdk/platform-tools/adb start-server`
unless $?.success?
  sleep 3
  `ANDROID_ADB_SERVER_PORT=#{ANDROID_ADB_SERVER_PORT} /opt/android-sdk/platform-tools/adb start-server`
  unless $?.success?
    sleep 3
    `ANDROID_ADB_SERVER_PORT=#{ANDROID_ADB_SERVER_PORT} /opt/android-sdk/platform-tools/adb start-server`
    unless $?.success?
      raise
    end
  end
end

sleep 1

Thread.new {
  `ANDROID_ADB_SERVER_PORT=#{ANDROID_ADB_SERVER_PORT} /opt/android-sdk/emulator/emulator -ports #{PORT1},#{PORT2} -avd EmulatorInDocker -skip-adb-auth -no-window -gpu swiftshader_indirect -no-snapshot -noaudio -no-boot-anim > /root/emulator.log`
}

sleep 30

puts 'First attempt to wait-for-device'
pid = Process.spawn("ANDROID_ADB_SERVER_PORT=#{ANDROID_ADB_SERVER_PORT} /opt/android-sdk/platform-tools/adb -s emulator-#{PORT1} wait-for-device shell 'while [[ -z $(getprop sys.boot_completed) ]]; do sleep 1; done;'")
begin
  Timeout.timeout(45) do
    puts 'waiting for the process to end'
    Process.wait(pid)
    puts 'process finished in time'
  end
rescue Timeout::Error
  puts 'process not finished in time, killing it'
  Process.kill('TERM', pid)
end

puts 'Second attempt to wait-for-device'
pid = Process.spawn("ANDROID_ADB_SERVER_PORT=#{ANDROID_ADB_SERVER_PORT} /opt/android-sdk/platform-tools/adb -s emulator-#{PORT1} wait-for-device shell 'while [[ -z $(getprop sys.boot_completed) ]]; do sleep 1; done;'")
begin
  Timeout.timeout(45) do
    puts 'waiting for the process to end'
    Process.wait(pid)
    puts 'process finished in time'
  end
rescue Timeout::Error
  puts 'process not finished in time, killing it'
  Process.kill('TERM', pid)
  raise
end

sleep 3

`ANDROID_ADB_SERVER_PORT=#{ANDROID_ADB_SERVER_PORT} /opt/android-sdk/platform-tools/adb -s emulator-#{PORT1} install /root/app.apk`
raise unless $?.success?

sleep 3

`ANDROID_ADB_SERVER_PORT=#{ANDROID_ADB_SERVER_PORT} /opt/android-sdk/platform-tools/adb -s emulator-#{PORT1} install /root/androidTest.apk`
raise unless $?.success?

puts "About to start tests"

`ANDROID_ADB_SERVER_PORT=#{ANDROID_ADB_SERVER_PORT} /opt/android-sdk/platform-tools/adb -s emulator-#{PORT1} shell am instrument -w -m --no-window-animation -e debug false -e class com.squareup.instrumentation.tests.ActivateSquareCardSwipeTest#swipeForCardVerification com.squareup.instrumentation > /root/instrument.log`
raise unless $?.success?

puts "Done with tests"

puts `tail -100 /root/emulator.log`
puts `tail -100 /root/instrument.log`
