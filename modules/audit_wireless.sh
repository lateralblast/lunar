#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_wireless
#
# Wireless checks
#
# Refer to Section(s) 4.2   Page(s) 98-9    CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 3.1.2 Page(s) 177-9   CIS Ubuntu 22.04 Benchmark v1.0.0
# Refer to Section(s) 3.1.2 Page(s) 357-60  CIS Ubuntu 24.04 Benchmark v1.0.0
# Refer to Section(s) 2.4.1 Page(s) 133-6   CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_wireless () {
  if [ "${os_name}" = "Darwin" ]; then
    string="Wifi information menu"
    verbose_message "${string}" "check"
    if [ "${os_name}" = "Darwin" ] && [ "${os_version}" -ge 14 ]; then
      user_list=$( find /Users -maxdepth 1 | grep -vE "localized|Shared" | cut -f3 -d/ )
      for user_name in ${user_list}; do
        check_osx_defaults_user "com.apple.controlcenter.plist" "WiFi" "2" "int" "currentHost" "${user_name}"
      done
    else
      # answer="/System/Library/CoreServices/MenuExtras/AirPort.menu"
      check=$( defaults read com.apple.systemuiserver menuExtras 2> /dev/null | grep "AirPort.menu" | sed "s/[ ,\",\,]//g" | grep -c "AirPort" |sed "s/ //g" )
      if [ "${check}" = "0" ]; then
        increment_secure   "Wireless status menu is not enabled"
      else
        increment_insecure "Wireless status menu is enabled"
      fi
    fi
  else
    if [ "${os_name}" = "Linux" ]; then
      check=$( command -v nmcli 2> /dev/null | sed "s/ //g" )
      if [ "${check}" = "1" ]; then
        check=$(nmcli radio all | grep -c enabled )
      else
        check=$(find /sys/class/net/*/ -type d -name wireless | wc -l | sed "s/ //g" )
      fi
      if [ "${check}" = "0" ]; then
        increment_secure   "Wireless is enabled"
      else
        increment_insecure "Wireless not enabled"
      fi
    fi
  fi
}
