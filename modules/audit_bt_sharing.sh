#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_bt_sharing
#
# Check BT sharing
#
# Refer to Section(s) 2.1.1           Page(s) 8-11        CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section(s) 2.1.1-3         Page(s) 21-5        CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 2.3.3.11,2.4.4  Page(s) 118-20,37-9 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_bt_sharing () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message         "Bluetooth services and file sharing"      "check"
    check_osx_defaults_int  "/Library/Preferences/com.apple.Bluetooth" "ControllerPowerState"      "0"
    check_osx_defaults_int  "/Library/Preferences/com.apple.Bluetooth" "PANServices"               "0"
    check_osx_defaults_bool "/Library/Preferences/com.apple.Bluetooth" "BluetoothSystemWakeEnable" "0"
    backup_file="bluetooth_discover"
    if [ "$audit_mode" != 2 ]; then
      if [ "$os_version" -ge 14 ]; then
        user_list=$( find /Users -maxdepth 1 -type d |grep -vE "localized|Shared" |cut -f3 -d/ )
        for user_name in $user_list; do
          check_osx_defaults_user "com.apple.Bluetooth"           "PrefKeyServicesEnabled" "0"  "bool" "$user_name"
          check_osx_defaults_user "com.apple.controlcenter.plist" "Bluetooth"              "18" "int"  "$user_name"
        done
      fi
      check=$( /usr/sbin/system_profiler SPBluetoothDataType |grep -i power |cut -f2 -d: |sed "s/ //g" )
      if [ ! "$check" = "Off" ]; then
        check=$( /usr/sbin/system_profiler SPBluetoothDataType |grep -i discoverable |cut -f2 -d: |sed "s/ //g" )
        if [ "$check" = "Off" ]; then
          increment_secure   "Bluetooth is not discoverable"
        else
          increment_insecure "Bluetooth is discoverable"
        fi
      else
        increment_secure "Bluetooth is turned off"
      fi
      check=$( defaults read com.apple.systemuiserver menuExtras 2>&1 |grep Bluetooth.menu |sed "s/[ ,\",\,]//g" )
      if [ "$check" = "/System/Library/CoreServices/MenuExtras/Bluetooth.menu" ]; then
        increment_secure   "Bluetooth status menu is enabled"
      else
        increment_insecure "Bluetooth status menu is not enabled"
      fi
    fi
  fi
}
