require 'timeout'

EVEN_RANDOM_NUMBER = 1024 + rand(0..20000) * 2
PORT1 = EVEN_RANDOM_NUMBER
PORT2 = EVEN_RANDOM_NUMBER + 1
ANDROID_ADB_SERVER_PORT = EVEN_RANDOM_NUMBER + 2

puts "PORT1: #{PORT1}"
puts "PORT2: #{PORT2}"
puts "ANDROID_ADB_SERVER_PORT: #{ANDROID_ADB_SERVER_PORT}"

begin
  retries ||= 0
  `ANDROID_ADB_SERVER_PORT=#{ANDROID_ADB_SERVER_PORT} /opt/android-sdk/platform-tools/adb start-server`
  raise unless $?.success?
rescue
  puts "In rescue"
  if (retries += 1) < 10
    sleep 3
    retry
  else
    raise
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

puts "Installing app"

pid = Process.spawn("ANDROID_ADB_SERVER_PORT=#{ANDROID_ADB_SERVER_PORT} /opt/android-sdk/platform-tools/adb -s emulator-#{PORT1} install /root/app.apk")
begin
  Timeout.timeout(15) do
    puts 'waiting for the process to end'
    Process.wait(pid)
    puts 'process finished in time'
  end
rescue Timeout::Error
  puts 'process not finished in time, killing it'
  Process.kill('TERM', pid)
  sleep 3
  pid = Process.spawn("ANDROID_ADB_SERVER_PORT=#{ANDROID_ADB_SERVER_PORT} /opt/android-sdk/platform-tools/adb -s emulator-#{PORT1} install /root/app.apk")
  begin
    Timeout.timeout(15) do
      puts 'waiting for the process to end'
      Process.wait(pid)
      puts 'process finished in time'
    end
  rescue Timeout::Error
    puts 'process not finished in time, killing it'
    Process.kill('TERM', pid)
    raise
  end
end

sleep 3

puts "Installing androidTest"
pid = Process.spawn("ANDROID_ADB_SERVER_PORT=#{ANDROID_ADB_SERVER_PORT} /opt/android-sdk/platform-tools/adb -s emulator-#{PORT1} install /root/androidTest.apk")
begin
  Timeout.timeout(15) do
    puts 'waiting for the process to end'
    Process.wait(pid)
    puts 'process finished in time'
  end
rescue Timeout::Error
  puts 'process not finished in time, killing it'
  Process.kill('TERM', pid)
  sleep 3
  pid = Process.spawn("ANDROID_ADB_SERVER_PORT=#{ANDROID_ADB_SERVER_PORT} /opt/android-sdk/platform-tools/adb -s emulator-#{PORT1} install /root/androidTest.apk")
  begin
    Timeout.timeout(15) do
      puts 'waiting for the process to end'
      Process.wait(pid)
      puts 'process finished in time'
    end
  rescue Timeout::Error
    puts 'process not finished in time, killing it'
    Process.kill('TERM', pid)
    raise
  end
end

puts "About to start tests"


pid = Process.spawn("ANDROID_ADB_SERVER_PORT=#{ANDROID_ADB_SERVER_PORT} /opt/android-sdk/platform-tools/adb -s emulator-#{PORT1} shell am instrument -w -m --no-window-animation -e debug false -e class com.squareup.instrumentation.tests.ActivateSquareCardSwipeTest#swipeForCardVerification com.squareup.instrumentation > /root/instrument.log")
begin
  Timeout.timeout(300) do
    puts 'waiting for the process to end'
    Process.wait(pid)
    puts 'process finished in time'
  end
rescue Timeout::Error
  puts 'process not finished in time, killing it'
  Process.kill('TERM', pid)
  puts "Done with tests the bad way"
  puts "EMULATOR"
  puts `tail -250 /root/emulator.log`
  puts "INSTRUMENT"
  puts `tail -250 /root/instrument.log`
  raise
end

puts "Done with tests"
puts `tail -100 /root/emulator.log`
puts `tail -100 /root/instrument.log`
