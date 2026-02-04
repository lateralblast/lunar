#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2010
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_safari_tracking
#
# Check Safari Tracking
#
# Refer to Section(s) 6.3.4-6 Page(s) 385-402 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_safari_tracking () {
  print_function "audit_safari_tracking"
  string="Safari Cross-site Tracking"
  check_message "${string}"
  if [ "${os_name}" = "Darwin" ]; then
    if [ "${long_os_version}" -ge 1014 ]; then
      if [ "${my_id}" != "0" ] && [ "${use_sudo}" = "0" ]; then
        verbose_message "Requires sudo to check" "notice"
        return
      fi
      if [ "${audit_mode}" != 2 ]; then
        command="ls /Users | grep -v Shared"
        command_message "${command}"
        user_list=$( eval "${command}" )
        for user_name in ${user_list}; do
          check_osx_defaults_user "com.apple.Safari" "BlockStoragePolicy"                               "2"        "int"  "${user_name}"
          check_osx_defaults_user "com.apple.Safari" "WebKitStorageBlockingPolicy"                      "1"        "int"  "${user_name}"
          check_osx_defaults_user "com.apple.Safari" "WebKitPreferences.storageBlockingPolicy"          "1"        "int"  "${user_name}"
          check_osx_defaults_user "com.apple.Safari" "WBSPrivacyProxyAvailabilityTraffic"               "33422572" "int"  "${user_name}"
          check_osx_defaults_user "com.apple.Safari" "WebKitPreferences.privateClickMeasurementEnabled" "1"        "bool" "${user_name}"
          check_osx_defaults_user "com.apple.Safari" "ShowFullURLInSmartSearchField"                    "1"        "bool" "${user_name}"
        done
      fi
    fi
  else
    na_message "${string}"
  fi
}
