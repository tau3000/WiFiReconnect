#!/bin/sh
appname='ReconnectWifiOnWakeup'
dir=$(cd $(dirname $0); pwd)
airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'
device=$(networksetup -listallhardwareports | grep -A1 '^Hardware Port: Wi-Fi' | grep '^Device:' | head -1 | awk '{print $2}')
device=${device:-en0}

if pgrep -q -f 'awakened.*networksetup'; then
  osascript -e "display notification \"Alreadly started\" with title \"$appname\""
else
  "$dir/awakened" /bin/sh -c "$airport -I | grep -qi 'airport: off' || (networksetup -setairportpower $device off; sleep 1; networksetup -setairportpower $device on)" &
  osascript -e "display notification \"Successfully started on device $device\" with title \"$appname\""
fi
