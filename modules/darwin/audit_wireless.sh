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
  print_function "audit_wireless"
  string="Wifi information menu"
  check_message "${string}"
  if [ "${os_name}" = "Darwin" ]; then
    if [ "${my_id}" != "0" ] && [ "${use_sudo}" = "0" ]; then
      verbose_message "Requires sudo to check" "notice"
      return
    fi
    if [ "${os_name}" = "Darwin" ] && [ "${os_version}" -ge 14 ]; then
      command="find /Users -maxdepth 1 | grep -vE \"localized|Shared\" | cut -f3 -d/"
      command_message "${command}"
      user_list=$( eval "${command}" )
      for user_name in ${user_list}; do
        check_osx_defaults_user "com.apple.controlcenter.plist" "WiFi" "2" "int" "currentHost" "${user_name}"
      done
    else
      # answer="/System/Library/CoreServices/MenuExtras/AirPort.menu"
      command="defaults read com.apple.systemuiserver menuExtras 2> /dev/null | grep \"AirPort.menu\" | sed \"s/[ ,\\\",\\\,]//g\" | grep -c \"AirPort\" |sed \"s/ //g\""
      command_message "${command}"
      check=$( eval "${command}" )
      if [ "${check}" = "0" ]; then
        increment_secure   "Wireless status menu is not enabled"
      else
        increment_insecure "Wireless status menu is enabled"
      fi
    fi
  else
    if [ "${os_name}" = "Linux" ]; then
      command="command -v nmcli 2> /dev/null | sed \"s/ //g\""
      command_message "${command}"
      check=$( eval "${command}" )
      if [ "${check}" = "1" ]; then
        command="nmcli radio all | grep -c enabled"
        command_message "${command}"
        check=$( eval "${command}" )
      else
        command="find /sys/class/net/*/ -type d -name wireless | wc -l | sed \"s/ //g\""
        command_message "${command}"
        check=$( eval "${command}" )
      fi
      if [ "${check}" = "0" ]; then
        increment_secure   "Wireless is enabled"
      else
        increment_insecure "Wireless not enabled"
      fi
    else
      na_message "${string}"
    fi
  fi
}
